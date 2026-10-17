import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:presby_hymns/core/chordpro/chordpro_parser.dart';
import 'package:presby_hymns/core/search/search_normalizer.dart';

void main() {
  final enDir = Directory('content/en');
  final tlDir = Directory('content/tl');
  final dbDir = Directory('assets/db');

  if (!dbDir.existsSync()) {
    dbDir.createSync(recursive: true);
  }

  final dbFile = File('assets/db/hymns.db');
  if (dbFile.existsSync()) {
    dbFile.deleteSync();
  }

  print('Opening SQLite database at ${dbFile.path}...');
  final db = sqlite3.open(dbFile.path);

  // Initialize schema
  db.execute('''
    CREATE TABLE meta (
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL
    );

    CREATE TABLE hymns (
      id INTEGER PRIMARY KEY,
      hymn_number INTEGER UNIQUE,
      tune_name TEXT,
      meter TEXT,
      original_key TEXT NOT NULL
    );

    CREATE TABLE hymn_texts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      hymn_id INTEGER NOT NULL REFERENCES hymns(id),
      language TEXT NOT NULL CHECK (language IN ('EN', 'TL')),
      title TEXT NOT NULL,
      sort_title TEXT NOT NULL,
      author TEXT,
      translator TEXT,
      year TEXT,
      verse_count INTEGER NOT NULL,
      has_chords INTEGER NOT NULL,
      chordpro_body TEXT NOT NULL,
      lyrics_text TEXT NOT NULL,
      first_line TEXT NOT NULL,
      UNIQUE (hymn_id, language)
    );

    CREATE INDEX idx_texts_lang_sort ON hymn_texts(language, sort_title);

    CREATE VIRTUAL TABLE hymn_fts USING fts5(
      title,
      first_line,
      lyrics_text,
      content='hymn_texts',
      content_rowid='id',
      tokenize="unicode61 remove_diacritics 2"
    );
  ''');

  final now = DateTime.now().toIso8601String();
  db.execute("INSERT INTO meta(key, value) VALUES('content_version', ?);", [now]);
  db.execute("INSERT INTO meta(key, value) VALUES('schema_version', '1');");

  // Read English hymns
  final enFiles = enDir.existsSync() ? enDir.listSync().whereType<File>().toList() : <File>[];
  final tlFiles = tlDir.existsSync() ? tlDir.listSync().whereType<File>().toList() : <File>[];

  enFiles.sort((a, b) => a.path.compareTo(b.path));
  tlFiles.sort((a, b) => a.path.compareTo(b.path));

  int hymnsCount = 0;
  int enCount = 0;
  int tlCount = 0;
  int chordsCount = 0;

  final Map<int, ({SongDoc doc, String raw})> enDocs = {};
  for (final f in enFiles) {
    if (!f.path.endsWith('.cho')) continue;
    final raw = f.readAsStringSync();
    final doc = ChordProParser.parse(raw);
    if (doc.number != null) {
      enDocs[doc.number!] = (doc: doc, raw: raw);
    }
  }

  final Map<int, ({SongDoc doc, String raw})> tlDocs = {};
  for (final f in tlFiles) {
    if (!f.path.endsWith('.cho')) continue;
    final raw = f.readAsStringSync();
    final doc = ChordProParser.parse(raw);
    if (doc.number != null) {
      tlDocs[doc.number!] = (doc: doc, raw: raw);
    }
  }

  // Combine unique hymn numbers
  final allNumbers = {...enDocs.keys, ...tlDocs.keys}.toList()..sort();

  for (final num in allNumbers) {
    final enEntry = enDocs[num];
    final tlEntry = tlDocs[num];
    final enDoc = enEntry?.doc;
    final tlDoc = tlEntry?.doc;
    final key = enDoc?.key ?? tlDoc?.key ?? 'C';

    // Insert into hymns
    db.execute(
      'INSERT INTO hymns(id, hymn_number, tune_name, meter, original_key) VALUES(?, ?, ?, ?, ?);',
      [num, num, enDoc?.tune, enDoc?.meter, key],
    );
    hymnsCount++;

    // Insert EN
    if (enDoc != null) {
      final plain = enDoc.plainText;
      final cleanPlain = SearchNormalizer.normalize(plain);
      final hasChords = enDoc.sections.any((s) => s.lines.any((l) => l.any((p) => p.chord != null)));
      if (hasChords) chordsCount++;

      db.execute('''
        INSERT INTO hymn_texts(hymn_id, language, title, sort_title, author, year, verse_count, has_chords, chordpro_body, lyrics_text, first_line)
        VALUES(?, 'EN', ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''', [
        num,
        enDoc.title,
        SearchNormalizer.normalize(enDoc.title),
        enDoc.author,
        enDoc.year,
        enDoc.sections.where((s) => s.type == SectionType.verse).length,
        hasChords ? 1 : 0,
        enEntry!.raw,
        cleanPlain,
        enDoc.firstLineSnippet,
      ]);
      enCount++;
    }

    // Insert TL
    if (tlDoc != null) {
      final plain = tlDoc.plainText;
      final cleanPlain = SearchNormalizer.normalize(plain);
      final hasChords = tlDoc.sections.any((s) => s.lines.any((l) => l.any((p) => p.chord != null)));
      if (hasChords && enDoc == null) chordsCount++;

      db.execute('''
        INSERT INTO hymn_texts(hymn_id, language, title, sort_title, author, year, verse_count, has_chords, chordpro_body, lyrics_text, first_line)
        VALUES(?, 'TL', ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''', [
        num,
        tlDoc.title,
        SearchNormalizer.normalize(tlDoc.title),
        tlDoc.author,
        tlDoc.year,
        tlDoc.sections.where((s) => s.type == SectionType.verse).length,
        hasChords ? 1 : 0,
        tlEntry!.raw,
        cleanPlain,
        tlDoc.firstLineSnippet,
      ]);
      tlCount++;
    }
  }

  // Populate FTS table
  db.execute("INSERT INTO hymn_fts(hymn_fts) VALUES('rebuild');");

  // Summary
  print('Successfully compiled database:');
  print('  Unique Hymns: $hymnsCount');
  print('  English Texts: $enCount');
  print('  Tagalog Texts: $tlCount');
  print('  Hymns with transcribed chords: $chordsCount');
  print('  Database size: ${(dbFile.lengthSync() / 1024).toStringAsFixed(1)} KB');

  // Verification query
  final testSearch = db.select("SELECT * FROM hymn_fts WHERE hymn_fts MATCH '\"banal\"*' LIMIT 3;");
  print('Verification FTS match on "banal": found ${testSearch.length} rows.');

  db.close();
}
