// ignore_for_file: avoid_print

import 'dart:io';

import 'package:sqlite3/sqlite3.dart';
import 'package:presby_hymns/core/chordpro/chordpro_parser.dart';
import 'package:presby_hymns/core/search/search_normalizer.dart';

class ValidationError {
  final String file;
  final int? hymnNumber;
  final int? line;
  final String message;

  const ValidationError({
    required this.file,
    this.hymnNumber,
    this.line,
    required this.message,
  });

  @override
  String toString() {
    final loc = line != null ? '$file:$line' : file;
    final numStr = hymnNumber != null ? ' (Hymn $hymnNumber)' : '';
    return '[$loc]$numStr $message';
  }
}

class ContentReport {
  final DateTime timestamp;
  final int totalHymns;
  final int enCount;
  final int tlCount;
  final int pairedCount;
  final int validatedChordsCount;
  final List<ValidationError> errors;
  final List<String> warnings;

  bool get isPassed => errors.isEmpty;

  const ContentReport({
    required this.timestamp,
    required this.totalHymns,
    required this.enCount,
    required this.tlCount,
    required this.pairedCount,
    required this.validatedChordsCount,
    required this.errors,
    required this.warnings,
  });

  String toMarkdown() {
    final buffer = StringBuffer();
    buffer.writeln('# Content Integrity Report');
    buffer.writeln();
    buffer.writeln('- **Timestamp:** ${timestamp.toIso8601String()}');
    buffer.writeln(
      '- **Validation Status:** ${isPassed ? "**PASS**" : "**FAIL**"}',
    );
    buffer.writeln('- **Total Unique Hymns:** $totalHymns');
    buffer.writeln('- **English Hymn Texts:** $enCount');
    buffer.writeln('- **Tagalog Hymn Texts:** $tlCount');
    buffer.writeln('- **Paired Bilingual Hymns:** $pairedCount');
    buffer.writeln('- **Validated Musical Chords:** $validatedChordsCount');
    buffer.writeln(
      '- **Verse Numbering Anomalies:** ${errors.where((e) => e.message.contains("Verse")).length}',
    );
    buffer.writeln(
      '- **Translation / Key Mismatches:** ${errors.where((e) => e.message.contains("Key") || e.message.contains("translation")).length}',
    );
    buffer.writeln();

    if (errors.isNotEmpty) {
      buffer.writeln('## Validation Errors (${errors.length})');
      buffer.writeln();
      for (final err in errors) {
        buffer.writeln('- ❌ $err');
      }
      buffer.writeln();
    } else {
      buffer.writeln('## Validation Passed');
      buffer.writeln();
      buffer.writeln(
        'All hymn texts passed structural, chord syntax, contiguous verse numbering, and bilingual parity checks.',
      );
      buffer.writeln();
    }

    if (warnings.isNotEmpty) {
      buffer.writeln('## Warnings (${warnings.length})');
      buffer.writeln();
      for (final w in warnings) {
        buffer.writeln('- ⚠️ $w');
      }
      buffer.writeln();
    }

    return buffer.toString();
  }
}

void main() {
  final enDir = Directory('content/en');
  final tlDir = Directory('content/tl');
  final dbDir = Directory('assets/db');
  final buildDir = Directory('build');

  if (!dbDir.existsSync()) {
    dbDir.createSync(recursive: true);
  }
  if (!buildDir.existsSync()) {
    buildDir.createSync(recursive: true);
  }

  // 1. Collect all files
  final enFiles = enDir.existsSync()
      ? enDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.cho'))
            .toList()
      : <File>[];
  final tlFiles = tlDir.existsSync()
      ? tlDir
            .listSync()
            .whereType<File>()
            .where((f) => f.path.endsWith('.cho'))
            .toList()
      : <File>[];

  enFiles.sort((a, b) => a.path.compareTo(b.path));
  tlFiles.sort((a, b) => a.path.compareTo(b.path));

  final Map<int, ({SongDoc doc, String raw, File file})> enDocs = {};
  final Map<int, ({SongDoc doc, String raw, File file})> tlDocs = {};

  final errors = <ValidationError>[];
  final warnings = <String>[];
  int validatedChordsCount = 0;

  final chordRegex = RegExp(
    r'^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$',
  );
  final bracketRegex = RegExp(r'\[([^\]]+)\]');
  final structuralTagRegex = RegExp(
    r'^(?:verse|chorus|refrain|ending|bridge|koro|intro|outro)(?:\s*\d+)?$',
    caseSensitive: false,
  );
  final sovDirectiveRegex = RegExp(
    r'\{(?:start_of_verse|sov)(?::\s*(\d+))?\}',
    caseSensitive: false,
  );
  final keyRegex = RegExp(r'^[A-G](?:b|#)?m?$');

  print('Executing strict content validation pass...');

  // Parse and validate EN files
  for (final f in enFiles) {
    final raw = f.readAsStringSync();
    final doc = ChordProParser.parse(raw);
    if (doc.number == null) {
      errors.add(
        ValidationError(
          file: f.path,
          message: 'Missing or unparseable {number} directive.',
        ),
      );
      continue;
    }
    enDocs[doc.number!] = (doc: doc, raw: raw, file: f);
  }

  // Parse and validate TL files
  for (final f in tlFiles) {
    final raw = f.readAsStringSync();
    final doc = ChordProParser.parse(raw);
    if (doc.number == null) {
      errors.add(
        ValidationError(
          file: f.path,
          message: 'Missing or unparseable {number} directive.',
        ),
      );
      continue;
    }
    tlDocs[doc.number!] = (doc: doc, raw: raw, file: f);
  }

  final allNumbers = {...enDocs.keys, ...tlDocs.keys}.toList()..sort();

  // Validate each hymn entry
  for (final num in allNumbers) {
    final enEntry = enDocs[num];
    final tlEntry = tlDocs[num];

    // Check Bilingual Key Matching (AC 18)
    if (enEntry != null && tlEntry != null) {
      final enKey = enEntry.doc.key.trim();
      final tlKey = tlEntry.doc.key.trim();
      if (!keyRegex.hasMatch(enKey)) {
        errors.add(
          ValidationError(
            file: enEntry.file.path,
            hymnNumber: num,
            message: 'Invalid musical key syntax in EN: "$enKey"',
          ),
        );
      }
      if (!keyRegex.hasMatch(tlKey)) {
        errors.add(
          ValidationError(
            file: tlEntry.file.path,
            hymnNumber: num,
            message: 'Invalid musical key syntax in TL: "$tlKey"',
          ),
        );
      }
      if (enKey != tlKey) {
        errors.add(
          ValidationError(
            file: tlEntry.file.path,
            hymnNumber: num,
            message:
                'Bilingual key mismatch: EN key "$enKey" != TL key "$tlKey"',
          ),
        );
      }
    }

    // Validate entries (EN and TL)
    for (final entry in [enEntry, tlEntry]) {
      if (entry == null) continue;
      final file = entry.file;
      final lines = entry.raw.split('\n');

      // Validate Chord Token Syntax (AC 16, BUG-008)
      for (int i = 0; i < lines.length; i++) {
        final lineStr = lines[i].trim();
        if (lineStr.startsWith('{')) continue;

        for (final match in bracketRegex.allMatches(lineStr)) {
          final token = match.group(1)!.trim();
          if (structuralTagRegex.hasMatch(token)) {
            // Excluded structural tag per BUG-008
            continue;
          }
          if (chordRegex.hasMatch(token)) {
            validatedChordsCount++;
          } else {
            errors.add(
              ValidationError(
                file: file.path,
                hymnNumber: num,
                line: i + 1,
                message:
                    'Invalid chord syntax token: "[$token]" (violates BUG-008)',
              ),
            );
          }
        }
      }

      // Validate Contiguous Verse Numbering (AC 17)
      final verseNumbers = <int>[];
      final verseLines = <int>[];
      for (int i = 0; i < lines.length; i++) {
        final match = sovDirectiveRegex.firstMatch(lines[i].trim());
        if (match != null) {
          final val = match.group(1);
          final verseNum = val != null
              ? int.tryParse(val)
              : (verseNumbers.length + 1);
          if (verseNum != null) {
            verseNumbers.add(verseNum);
            verseLines.add(i + 1);
          }
        }
      }

      if (verseNumbers.isNotEmpty) {
        for (int v = 0; v < verseNumbers.length; v++) {
          final expectedNum = v + 1;
          final actualNum = verseNumbers[v];
          if (actualNum != expectedNum) {
            errors.add(
              ValidationError(
                file: file.path,
                hymnNumber: num,
                line: verseLines[v],
                message:
                    'Verse numbering discontinuity: expected verse $expectedNum, but found $actualNum (violates AC 17)',
              ),
            );
          }
        }
      }

      // Validate ChordPro Body Preservation (AC 19, BUG-005)
      final hasBrackets = entry.raw.contains('[');
      if (hasBrackets &&
          !entry.doc.sections.any(
            (s) => s.lines.any((l) => l.any((p) => p.chord != null)),
          )) {
        warnings.add(
          'Hymn $num (${file.path}): contains bracket tags but no chords parsed into AST.',
        );
      }
      final cleanPlain = SearchNormalizer.normalize(entry.doc.plainText);
      if (cleanPlain.isEmpty) {
        errors.add(
          ValidationError(
            file: file.path,
            hymnNumber: num,
            message: 'Normalized search lyrics_text is empty.',
          ),
        );
      }
    }
  }

  // Count paired hymns
  final pairedCount = allNumbers
      .where((n) => enDocs.containsKey(n) && tlDocs.containsKey(n))
      .length;

  final report = ContentReport(
    timestamp: DateTime.now(),
    totalHymns: allNumbers.length,
    enCount: enDocs.length,
    tlCount: tlDocs.length,
    pairedCount: pairedCount,
    validatedChordsCount: validatedChordsCount,
    errors: errors,
    warnings: warnings,
  );

  final reportFile = File('build/content-report.md');
  reportFile.writeAsStringSync(report.toMarkdown());
  print('Generated validation report at ${reportFile.path}');

  if (!report.isPassed) {
    stderr.writeln('\n❌ FATAL CONTENT VALIDATION ERRORS (${errors.length}):');
    for (final err in errors) {
      stderr.writeln('  $err');
    }
    exit(1);
  }

  print('✓ All content validation checks PASSED.');

  // 2. Open SQLite database & compile schema
  final dbFile = File('assets/db/hymns.db');
  if (dbFile.existsSync()) {
    dbFile.deleteSync();
  }

  print('Compiling SQLite database at ${dbFile.path}...');
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
  db.execute("INSERT INTO meta(key, value) VALUES('content_version', ?);", [
    now,
  ]);
  db.execute("INSERT INTO meta(key, value) VALUES('schema_version', '1');");

  int hymnsCount = 0;
  int enCount = 0;
  int tlCount = 0;
  int chordsCount = 0;

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
      final hasChords = enDoc.sections.any(
        (s) => s.lines.any((l) => l.any((p) => p.chord != null)),
      );
      if (hasChords) chordsCount++;

      // BUG-005: Raw ChordPro preserved in chordpro_body; stripped clean in lyrics_text
      db.execute(
        '''
        INSERT INTO hymn_texts(hymn_id, language, title, sort_title, author, year, verse_count, has_chords, chordpro_body, lyrics_text, first_line)
        VALUES(?, 'EN', ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
        [
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
        ],
      );
      enCount++;
    }

    // Insert TL
    if (tlDoc != null) {
      final plain = tlDoc.plainText;
      final cleanPlain = SearchNormalizer.normalize(plain);
      final hasChords = tlDoc.sections.any(
        (s) => s.lines.any((l) => l.any((p) => p.chord != null)),
      );
      if (hasChords && enDoc == null) chordsCount++;

      // BUG-005: Raw ChordPro preserved in chordpro_body; stripped clean in lyrics_text
      db.execute(
        '''
        INSERT INTO hymn_texts(hymn_id, language, title, sort_title, author, year, verse_count, has_chords, chordpro_body, lyrics_text, first_line)
        VALUES(?, 'TL', ?, ?, ?, ?, ?, ?, ?, ?, ?);
      ''',
        [
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
        ],
      );
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
  print(
    '  Database size: ${(dbFile.lengthSync() / 1024).toStringAsFixed(1)} KB',
  );

  // Verification query
  final testSearch = db.select(
    "SELECT * FROM hymn_fts WHERE hymn_fts MATCH '\"banal\"*' LIMIT 3;",
  );
  print('Verification FTS match on "banal": found ${testSearch.length} rows.');

  db.close();
}
