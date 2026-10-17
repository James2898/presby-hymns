import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test('assets/db/hymns.db integrity: chords retained and file counts in sync', () {
    final dbFile = File('assets/db/hymns.db');
    expect(dbFile.existsSync(), isTrue, reason: 'assets/db/hymns.db must exist');

    final db = sqlite3.open(dbFile.path);

    // 1. Verify meta table
    final metaRows = db.select("SELECT value FROM meta WHERE key = 'content_version';");
    expect(metaRows.isNotEmpty, isTrue, reason: 'content_version meta entry must exist');

    // 2. Count content files
    final enDir = Directory('content/en');
    final tlDir = Directory('content/tl');
    final enCount = enDir.existsSync() ? enDir.listSync().where((f) => f.path.endsWith('.cho')).length : 0;
    final tlCount = tlDir.existsSync() ? tlDir.listSync().where((f) => f.path.endsWith('.cho')).length : 0;

    final dbEnCount = db.select("SELECT COUNT(*) as c FROM hymn_texts WHERE language = 'EN';").first['c'] as int;
    final dbTlCount = db.select("SELECT COUNT(*) as c FROM hymn_texts WHERE language = 'TL';").first['c'] as int;

    expect(dbEnCount, equals(enCount), reason: 'English DB text count must match content/en .cho count');
    expect(dbTlCount, equals(tlCount), reason: 'Tagalog DB text count must match content/tl .cho count');

    // 3. Verify chord retention: all texts with has_chords = 1 MUST contain chord brackets in chordpro_body
    final missingChords = db.select(
      "SELECT hymn_id, language FROM hymn_texts WHERE has_chords = 1 AND instr(chordpro_body, '[') = 0;",
    );
    expect(
      missingChords.isEmpty,
      isTrue,
      reason: 'Hymns marked with has_chords=1 must contain [...] chord tags in chordpro_body (found ${missingChords.length} missing)',
    );

    // 4. AC-3: Verify musical chord tokens regex
    final chordRegex = RegExp(r'^[A-G](?:b|#)?(?:m|maj|min|dim|aug|sus|add)?[0-9]*(?:\/[A-G](?:b|#)?)?$');
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
      reason: 'All chord tokens must match musical regex. Invalid chords found:\n${invalidChords.join('\n')}',
    );

    db.close();
  });
}
