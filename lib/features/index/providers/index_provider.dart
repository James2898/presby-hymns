import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:presby_hymns/data/database/app_database.dart';
import '../models/index_item.dart';

enum IndexTab {
  all,
  english,
  tagalog,
}

enum IndexSort {
  number,
  title,
}

final databaseProvider = appDatabaseProvider;

final indexTabProvider = StateProvider<IndexTab>((ref) => IndexTab.all);
final indexSortProvider = StateProvider<IndexSort>((ref) => IndexSort.number);
final indexSearchQueryProvider = StateProvider<String>((ref) => '');

final indexListProvider = FutureProvider<List<IndexItem>>((ref) async {
  final db = ref.watch(databaseProvider);
  final activeTab = ref.watch(indexTabProvider);
  final activeSort = ref.watch(indexSortProvider);
  final query = ref.watch(indexSearchQueryProvider).trim().toLowerCase();

  // Query hymns and their texts
  final rows = await (db.select(db.hymns).join([
    innerJoin(db.hymnTexts, db.hymnTexts.hymnId.equalsExp(db.hymns.id)),
  ])).get();

  // Group texts by hymnId
  final Map<int, Hymn> hymnsMap = {};
  final Map<int, List<HymnText>> textsByHymnId = {};

  for (final row in rows) {
    final hymn = row.readTable(db.hymns);
    final text = row.readTable(db.hymnTexts);

    hymnsMap[hymn.id] = hymn;
    textsByHymnId.putIfAbsent(hymn.id, () => []).add(text);
  }

  final items = <IndexItem>[];

  for (final entry in hymnsMap.entries) {
    final hymn = entry.value;
    final texts = textsByHymnId[entry.key] ?? [];

    final enText = texts.cast<HymnText?>().firstWhere(
      (t) => t?.language == 'EN',
      orElse: () => null,
    );
    final tlText = texts.cast<HymnText?>().firstWhere(
      (t) => t?.language == 'TL',
      orElse: () => null,
    );
    final hasTagalog = tlText != null;

    if (activeTab == IndexTab.all) {
      // In All Hymns, preference English as primary title, Tagalog as alternate
      final primary = enText ?? tlText;
      if (primary == null) continue;

      items.add(
        IndexItem(
          hymnId: hymn.id,
          hymnNumber: hymn.hymnNumber,
          title: primary.title,
          sortTitle: primary.sortTitle,
          alternateTitle: hasTagalog && primary != tlText ? tlText.title : null,
          author: primary.author,
          year: primary.year,
          meter: hymn.meter,
          key: hymn.originalKey,
          hasTagalog: hasTagalog,
          language: primary.language,
          isUnnumbered: hymn.hymnNumber == null,
        ),
      );
    } else if (activeTab == IndexTab.english) {
      if (enText == null) continue;
      items.add(
        IndexItem(
          hymnId: hymn.id,
          hymnNumber: hymn.hymnNumber,
          title: enText.title,
          sortTitle: enText.sortTitle,
          alternateTitle: null,
          author: enText.author,
          year: enText.year,
          meter: hymn.meter,
          key: hymn.originalKey,
          hasTagalog: hasTagalog,
          language: 'EN',
          isUnnumbered: hymn.hymnNumber == null,
        ),
      );
    } else if (activeTab == IndexTab.tagalog) {
      if (tlText == null) continue;
      items.add(
        IndexItem(
          hymnId: hymn.id,
          hymnNumber: hymn.hymnNumber,
          title: tlText.title,
          sortTitle: tlText.sortTitle,
          alternateTitle: null,
          author: tlText.author,
          year: tlText.year,
          meter: hymn.meter,
          key: hymn.originalKey,
          hasTagalog: true,
          language: 'TL',
          isUnnumbered: hymn.hymnNumber == null,
        ),
      );
    }
  }

  // Filter by search query if present
  var filtered = items;
  if (query.isNotEmpty) {
    final queryDigitsOnly = RegExp(r'^\d+$').hasMatch(query);
    if (queryDigitsOnly) {
      final num = int.tryParse(query);
      filtered = items.where((item) => item.hymnNumber == num).toList();
    } else {
      filtered = items.where((item) {
        final titleMatch = item.title.toLowerCase().contains(query);
        final altMatch = item.alternateTitle?.toLowerCase().contains(query) ?? false;
        final authorMatch = item.author?.toLowerCase().contains(query) ?? false;
        return titleMatch || altMatch || authorMatch;
      }).toList();
    }
  }

  // Sorting
  if (activeSort == IndexSort.number) {
    // Number sort: numbered ascending (1..520), then unnumbered A->Z
    filtered.sort((a, b) {
      if (!a.isUnnumbered && !b.isUnnumbered) {
        return (a.hymnNumber ?? 0).compareTo(b.hymnNumber ?? 0);
      }
      if (!a.isUnnumbered && b.isUnnumbered) {
        return -1; // numbered first
      }
      if (a.isUnnumbered && !b.isUnnumbered) {
        return 1; // unnumbered after
      }
      return a.sortTitle.compareTo(b.sortTitle);
    });
  } else {
    // Title sort: everything alphabetical
    filtered.sort((a, b) => a.sortTitle.compareTo(b.sortTitle));
  }

  return filtered;
});