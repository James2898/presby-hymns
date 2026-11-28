import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('assets/db/hymns.db integrity: chords retained and file counts in sync', () {
    final dbFile = File('assets/db/hymns.db');
    expect(
      dbFile.existsSync(),
      isTrue,
      reason: 'assets/db/hymns.db must exist',
    );

    final db = sqlite3.open(dbFile.path);

    // 1. Verify meta table
    final metaRows = db.select(
      "SELECT value FROM meta WHERE key = 'content_version';",
    );
    expect(
      metaRows.isNotEmpty,
      isTrue,
      reason: 'content_version meta entry must exist',
    );

    // 2. Count content files
    final enDir = Directory('content/en');
    final tlDir = Directory('content/tl');
    final enCount = enDir.existsSync()
        ? enDir.listSync().where((f) => f.path.endsWith('.cho')).length
        : 0;
    final tlCount = tlDir.existsSync()
        ? tlDir.listSync().where((f) => f.path.endsWith('.cho')).length
        : 0;

    final dbEnCount =
        db
                .select(
                  "SELECT COUNT(*) as c FROM hymn_texts WHERE language = 'EN';",
                )
                .first['c']
            as int;
    final dbTlCount =
        db
                .select(
                  "SELECT COUNT(*) as c FROM hymn_texts WHERE language = 'TL';",
                )
                .first['c']
            as int;

    expect(
      dbEnCount,
      equals(enCount),
      reason: 'English DB text count must match content/en .cho count',
    );
    expect(
      dbTlCount,
      equals(tlCount),
      reason: 'Tagalog DB text count must match content/tl .cho count',
    );

    // 3. Verify chord retention: all texts with has_chords = 1 MUST contain chord brackets in chordpro_body
    final missingChords = db.select(
      "SELECT hymn_id, language FROM hymn_texts WHERE has_chords = 1 AND instr(chordpro_body, '[') = 0;",
    );
    expect(
      missingChords.isEmpty,
      isTrue,
      reason:
          'Hymns marked with has_chords=1 must contain [...] chord tags in chordpro_body (found ${missingChords.length} missing)',
    );

    // 4. AC-3: Verify musical chord tokens regex
    final chordRegex = RegExp(
      r'^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$',
    );
    final bracketRegex = RegExp(r'\[([^\]]+)\]');

    final chordRows = db.select(
      "SELECT hymn_id, language, chordpro_body FROM hymn_texts WHERE has_chords = 1 OR instr(chordpro_body, '[') > 0;",
    );

    final invalidChords = <String>[];
    for (final row in chordRows) {
      final hymnId = row['hymn_id'] as int;
      final language = row['language'] as String;
      final body = row['chordpro_body'] as String;

      for (final match in bracketRegex.allMatches(body)) {
        final token = match.group(1)!.trim();
        if (!chordRegex.hasMatch(token)) {
          invalidChords.add('Hymn $hymnId ($language): "$token"');
        }
      }
    }

    expect(
      invalidChords.isEmpty,
      isTrue,
      reason:
          'All chord tokens must match musical regex. Invalid chords found:\n${invalidChords.join('\n')}',
    );

    // 5. Verify PRAGMA user_version and meta schema_version match Drift v2 (AM-2)
    final userVersion =
        db.select('PRAGMA user_version;').first.values.first as int;
    expect(
      userVersion,
      equals(2),
      reason: 'PRAGMA user_version must match Drift schemaVersion (2)',
    );
    final schemaVersionMeta =
        db
                .select("SELECT value FROM meta WHERE key = 'schema_version';")
                .first['value']
            as String;
    expect(schemaVersionMeta, equals('2'));

    // 6. Verify Tagalog Responsive Readings table & lines (AC-8..AC-15)
    final readings = db.select(
      "SELECT id, language, number, title, sort_title, scripture_reference FROM responsive_readings WHERE language = 'TL' ORDER BY number ASC;",
    );
    expect(
      readings.length,
      equals(57),
      reason: 'Must contain all 57 Tagalog responsive readings',
    );

    for (int i = 0; i < readings.length; i++) {
      final row = readings[i];
      final expectedNum = i + 1;
      final readingId = row['id'] as int;
      final num = row['number'] as int;
      final title = row['title'] as String;
      final sortTitle = row['sort_title'] as String;
      final ref = row['scripture_reference'] as String;

      expect(
        num,
        equals(expectedNum),
        reason: 'Readings must be numbered consecutively 1..57',
      );
      expect(
        title.trim().isNotEmpty,
        isTrue,
        reason: 'Reading #$num must have non-empty title',
      );
      expect(
        sortTitle.trim().isNotEmpty,
        isTrue,
        reason: 'Reading #$num must have non-empty sort_title',
      );
      expect(
        ref.trim().isNotEmpty,
        isTrue,
        reason: 'Reading #$num must have non-empty scripture_reference',
      );
      expect(
        title.contains('**'),
        isFalse,
        reason: 'Reading #$num title has residual "**"',
      );
      expect(
        ref.contains('**'),
        isFalse,
        reason: 'Reading #$num reference has residual "**"',
      );

      final lines = db.select(
        'SELECT line_order, role, text FROM responsive_reading_lines WHERE reading_id = ? ORDER BY line_order ASC;',
        [readingId],
      );
      expect(
        lines.isNotEmpty,
        isTrue,
        reason: 'Reading #$num must have at least 1 body line',
      );
      for (int j = 0; j < lines.length; j++) {
        final line = lines[j];
        expect(line['line_order'], equals(j + 1));
        expect(
          const {'leader', 'people', 'all'}.contains(line['role']),
          isTrue,
          reason:
              'Reading #$num line ${j + 1} has invalid role ${line['role']}',
        );
        final lineText = line['text'] as String;
        expect(lineText.trim().isNotEmpty, isTrue);
        expect(
          lineText.contains('**'),
          isFalse,
          reason: 'Reading #$num line ${j + 1} has residual "**"',
        );
      }
    }

    // 7. Verify Reading #1 fixture (AC-15)
    final r1 = readings.first;
    expect(r1['number'], equals(1));
    expect(r1['title'], equals('Ang Daan Ng Buhay'));
    expect(r1['scripture_reference'], equals('Awit 1:1-6'));
    final r1Lines = db.select(
      'SELECT role FROM responsive_reading_lines WHERE reading_id = ? ORDER BY line_order ASC;',
      [r1['id']],
    );
    expect(r1Lines.length, equals(12));
    expect(r1Lines.where((l) => l['role'] == 'leader').length, equals(6));
    expect(r1Lines.where((l) => l['role'] == 'people').length, equals(5));
    expect(r1Lines.where((l) => l['role'] == 'all').length, equals(1));

    // 8. Verify key edge-case readings in compiled DB (#16/#44/#50 no 'all', #41 multi-line ref)
    for (final noAllNum in [16, 44, 50]) {
      final r = readings[noAllNum - 1];
      final allLines =
          db.select(
                "SELECT COUNT(*) as c FROM responsive_reading_lines WHERE reading_id = ? AND role = 'all';",
                [r['id']],
              ).first['c']
              as int;
      expect(
        allLines,
        equals(0),
        reason: 'Reading #$noAllNum should have 0 unison ("all") lines',
      );
    }
    expect(
      readings[40]['scripture_reference'],
      equals(
        '1 Pedro 1:24-25; Santiago 4:14; Galacia 6:10; Efeso 6:16; Colosas 3:13; Mateo 28:19-20',
      ),
    );

    db.close();
  });
}
