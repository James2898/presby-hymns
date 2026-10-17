import 'package:drift/drift.dart';
import '../../../core/search/search_normalizer.dart';
import '../../../data/database/app_database.dart';
import '../domain/models/catalog_stats.dart';
import '../domain/models/search_hit.dart';

class HomeRepository {
  final AppDatabase _db;

  HomeRepository(this._db);

  /// Performs search:
  /// - Exact numeric query if string contains only digits (D10, AC-3)
  /// - FTS5 keyword search otherwise
  Future<GroupedSearchResults> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      return const GroupedSearchResults();
    }

    final isNumeric = RegExp(r'^\d+$').hasMatch(trimmed);

    if (isNumeric) {
      final number = int.tryParse(trimmed);
      if (number == null) return const GroupedSearchResults();
      return _searchExactNumber(number);
    } else {
      return _searchText(trimmed);
    }
  }

  Future<GroupedSearchResults> _searchExactNumber(int number) async {
    final rows = await _db.customSelect(
      '''
      SELECT t.hymn_id, h.hymn_number, t.language, t.title, t.first_line
      FROM hymn_texts t
      JOIN hymns h ON h.id = t.hymn_id
      WHERE h.hymn_number = ?
      ORDER BY t.language ASC
      ''',
      variables: [Variable.withInt(number)],
      readsFrom: {_db.hymns, _db.hymnTexts},
    ).get();

    final english = <SearchHit>[];
    final tagalog = <SearchHit>[];

    for (final row in rows) {
      final hit = SearchHit(
        hymnId: row.read<int>('hymn_id'),
        number: row.readNullable<int>('hymn_number'),
        language: row.read<String>('language'),
        title: row.read<String>('title'),
        firstLine: row.read<String>('first_line'),
      );

      if (hit.language == 'EN') {
        english.add(hit);
      } else if (hit.language == 'TL') {
        tagalog.add(hit);
      }
    }

    return GroupedSearchResults(
      english: english,
      tagalog: tagalog,
      englishTotal: english.length,
      tagalogTotal: tagalog.length,
    );
  }

  Future<GroupedSearchResults> _searchText(String query) async {
    final ftsQuery = SearchNormalizer.buildFtsQuery(query);
    if (ftsQuery.isEmpty) return const GroupedSearchResults();

    List<QueryRow> rows = [];
    try {
      rows = await _db.customSelect(
        '''
        SELECT t.hymn_id, h.hymn_number, t.language, t.title, t.first_line,
               bm25(hymn_fts, 10.0, 5.0, 1.0) AS rank
        FROM hymn_fts
        JOIN hymn_texts t ON t.id = hymn_fts.rowid
        JOIN hymns h ON h.id = t.hymn_id
        WHERE hymn_fts MATCH ?
        ORDER BY rank
        LIMIT 100
        ''',
        variables: [Variable.withString(ftsQuery)],
        readsFrom: {_db.hymns, _db.hymnTexts},
      ).get();
    } catch (_) {
      final clean = '%${SearchNormalizer.normalize(query)}%';
      rows = await _db.customSelect(
        '''
        SELECT t.hymn_id, h.hymn_number, t.language, t.title, t.first_line
        FROM hymn_texts t
        JOIN hymns h ON h.id = t.hymn_id
        WHERE t.sort_title LIKE ? OR t.first_line LIKE ? OR t.lyrics_text LIKE ?
        LIMIT 100
        ''',
        variables: [
          Variable.withString(clean),
          Variable.withString(clean),
          Variable.withString(clean),
        ],
        readsFrom: {_db.hymns, _db.hymnTexts},
      ).get();
    }

    final english = <SearchHit>[];
    final tagalog = <SearchHit>[];

    for (final row in rows) {
      final hit = SearchHit(
        hymnId: row.read<int>('hymn_id'),
        number: row.readNullable<int>('hymn_number'),
        language: row.read<String>('language'),
        title: row.read<String>('title'),
        firstLine: row.read<String>('first_line'),
      );

      if (hit.language == 'EN') {
        if (english.length < 50) english.add(hit);
      } else if (hit.language == 'TL') {
        if (tagalog.length < 50) tagalog.add(hit);
      }
    }

    return GroupedSearchResults(
      english: english,
      tagalog: tagalog,
      englishTotal: english.length,
      tagalogTotal: tagalog.length,
    );
  }

  Future<CatalogStats> getCatalogStats() async {
    try {
      final rows = await _db.customSelect(
        '''
        SELECT
          t.language,
          COUNT(CASE WHEN h.hymn_number IS NOT NULL THEN 1 END) AS numbered_count,
          COUNT(CASE WHEN h.hymn_number IS NULL THEN 1 END) AS unnumbered_count
        FROM hymn_texts t
        JOIN hymns h ON h.id = t.hymn_id
        GROUP BY t.language
        ''',
        readsFrom: {_db.hymns, _db.hymnTexts},
      ).get();

      CatalogCount en = const CatalogCount(numberedCount: 520, unnumberedCount: 0);
      CatalogCount tl = const CatalogCount(numberedCount: 380, unnumberedCount: 0);

      for (final row in rows) {
        final lang = row.read<String>('language');
        final num = row.read<int>('numbered_count');
        final unnum = row.read<int>('unnumbered_count');

        if (lang == 'EN') {
          en = CatalogCount(numberedCount: num, unnumberedCount: unnum);
        } else if (lang == 'TL') {
          tl = CatalogCount(numberedCount: num, unnumberedCount: unnum);
        }
      }

      return CatalogStats(english: en, tagalog: tl);
    } catch (_) {
      return const CatalogStats();
    }
  }
}
