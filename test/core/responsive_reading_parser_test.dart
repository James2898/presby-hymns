import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:presby_hymns/core/readings/responsive_reading_parser.dart';

void main() {
  group('ResponsiveReadingParser — Full Source File (57 Readings)', () {
    late List<ParsedResponsiveReading> readings;

    setUpAll(() {
      final rawFile = File('raw_content/Tagalog Responsive Readings.md');
      expect(rawFile.existsSync(), isTrue);
      readings = ResponsiveReadingParser.parse(
        rawFile.readAsStringSync(),
        language: 'TL',
      );
    });

    test('parses all 57 consecutive readings and passes strict validation (AC-9, AC-15)', () {
      expect(readings.length, equals(57));
      expect(
        readings.map((r) => r.number).toList(),
        equals(List.generate(57, (i) => i + 1)),
      );

      final issues = ResponsiveReadingParser.validate(
        readings,
        expectedCount: 57,
        verifyReading1Fixture: true,
      );
      expect(issues, isEmpty, reason: 'Unexpected validation issues: $issues');
    });

    test('Reading #1 matches exact sample fixture (AC-15)', () {
      final r1 = readings[0];
      expect(r1.language, equals('TL'));
      expect(r1.number, equals(1));
      expect(r1.title, equals('Ang Daan Ng Buhay'));
      expect(r1.scriptureReference, equals('Awit 1:1-6'));
      expect(r1.lines.length, equals(12));
      expect(r1.lines.where((l) => l.role == 'leader').length, equals(6));
      expect(r1.lines.where((l) => l.role == 'people').length, equals(5));
      expect(r1.lines.where((l) => l.role == 'all').length, equals(1));
      expect(r1.lines.first.role, equals('leader'));
      expect(r1.lines.last.role, equals('all'));
    });

    test('handles all documented edge cases (#8, #9, #10, #16, #22, #33, #36/#37, #41, #43, #44, #45, #50, #55)', () {
      // #8: trailing colon in header + trailing period in title
      final r8 = readings[7];
      expect(r8.number, equals(8));
      expect(
        r8.title,
        equals('Pagpupuri Sa Dios Dahil Sa Kanyang Mga Pagpapala.'),
      );
      expect(r8.scriptureReference, equals('Awit 18'));

      // #9 & #10: "Tagunang" typo in header; #9 has consecutive people lines
      final r9 = readings[8];
      expect(r9.number, equals(9));
      expect(r9.title, equals('Ang Hari Ng Kaluwalhatian'));
      final hasConsecutivePeople = List.generate(
        r9.lines.length - 1,
        (i) => r9.lines[i].role == 'people' && r9.lines[i + 1].role == 'people',
      ).any((matched) => matched);
      expect(hasConsecutivePeople, isTrue);

      final r10 = readings[9];
      expect(r10.number, equals(10));
      expect(r10.title, equals('Hanapin Ninyo Ang Panginoon'));

      // #16, #44, #50: zero 'all' lines
      for (final num in [16, 44, 50]) {
        final r = readings[num - 1];
        expect(
          r.lines.where((l) => l.role == 'all'),
          isEmpty,
          reason: 'Reading #$num has no unison line',
        );
        expect(r.lines.isNotEmpty, isTrue);
      }

      // #22 & #33: leader lines with trailing period outside **...**.
      for (final num in [22, 33]) {
        final r = readings[num - 1];
        expect(
          r.lines.any((l) => l.role == 'leader' && l.text.endsWith('.')),
          isTrue,
          reason:
              'Reading #$num must preserve trailing outside period on leader line',
        );
        expect(r.lines.any((l) => l.text.contains('**')), isFalse);
      }

      // #36 & #37: split accurately despite single-newline breaks and no blank separator line
      final r36 = readings[35];
      final r37 = readings[36];
      expect(r36.number, equals(36));
      expect(r36.title, equals('Mga Kayamanang Pang-Langit'));
      expect(r36.scriptureReference, equals('Mateo 6:19-29'));
      expect(r37.number, equals(37));
      expect(r37.title, equals('Payo Ng Magulang Sa Mga Anak'));
      expect(r37.scriptureReference, equals('Kawikaan 4:1-11'));

      // #41: multi-line trailing scripture reference joined with single space
      final r41 = readings[40];
      expect(
        r41.scriptureReference,
        equals(
          '1 Pedro 1:24-25; Santiago 4:14; Galacia 6:10; Efeso 6:16; Colosas 3:13; Mateo 28:19-20',
        ),
      );

      // #43: title leading/trailing tabs stripped
      final r43 = readings[42];
      expect(r43.title, equals('Ang Tunay Na Pag-Ibig'));

      // #45: double space in header
      final r45 = readings[44];
      expect(r45.number, equals(45));
      expect(r45.title, equals('Pagpupuri Sa Panginoon'));

      // #50: consecutive leader lines preserved as distinct ordered records
      final r50 = readings[49];
      final hasConsecutiveLeader = List.generate(
        r50.lines.length - 1,
        (i) =>
            r50.lines[i].role == 'leader' && r50.lines[i + 1].role == 'leader',
      ).any((matched) => matched);
      expect(hasConsecutiveLeader, isTrue);

      // #55: "Tugunag" typo header
      final r55 = readings[54];
      expect(r55.number, equals(55));
      expect(r55.title, equals('Pagtatalaga ng Buhay Kristiano'));
    });

    test('unescapes \\! to ! and preserves verbatim source citations', () {
      for (final reading in readings) {
        expect(reading.title.contains(r'\!'), isFalse);
        expect(reading.scriptureReference.contains(r'\!'), isFalse);
        for (final line in reading.lines) {
          expect(line.text.contains(r'\!'), isFalse);
        }
      }
      expect(readings.any((r) => r.scriptureReference == 'Awit 23'), isTrue);
      expect(
        readings.any((r) => r.scriptureReference == 'Awit 37:513'),
        isTrue,
      );
      expect(
        readings.any((r) => r.scriptureReference == 'Kaw. 10:1-11'),
        isTrue,
      );
    });
  });

  group('ResponsiveReadingParser — Synthetic Normalization & Validation Failure Cases', () {
    test('normalizes CRLF, BOM, em-spaces, tabs, and \\! escapes', () {
      const sample =
          '\uFEFF\u2003**Tugunag  Pagbasa Bilang 2:**\t\r\n'
          '\t**Pamagat\t  ng Pagbasa.**\u2003\r\n'
          '**Unang   linya\\!**.  \r\n'
          'Ikalawang\tlinya\\!\r\n'
          '***Lahat  ay  sumagot\\!***\r\n'
          'Awit 23:1-3\r\n'
          'Awit 23:4-6\r\n';

      final parsed = ResponsiveReadingParser.parse(sample);
      expect(parsed.length, equals(1));
      final r = parsed.first;
      expect(r.number, equals(2));
      expect(r.title, equals('Pamagat ng Pagbasa.'));
      expect(r.scriptureReference, equals('Awit 23:1-3 Awit 23:4-6'));
      expect(r.lines.length, equals(3));
      expect(r.lines[0].role, equals('leader'));
      expect(r.lines[0].text, equals('Unang linya!.'));
      expect(r.lines[1].role, equals('people'));
      expect(r.lines[1].text, equals('Ikalawang linya!'));
      expect(r.lines[2].role, equals('all'));
      expect(r.lines[2].text, equals('Lahat ay sumagot!'));
    });

    test('validate flags empty list, duplicate numbers, missing ref, empty body, and residual **', () {
      expect(ResponsiveReadingParser.validate(const []), isNotEmpty);

      final malformed = [
        const ParsedResponsiveReading(
          language: 'TL',
          number: 1,
          title: 'Bad **Title',
          scriptureReference: '',
          lines: [],
        ),
        const ParsedResponsiveReading(
          language: 'TL',
          number: 1,
          title: 'Dup',
          scriptureReference: 'Awit 1',
          lines: [
            ParsedReadingLine(
              lineOrder: 1,
              role: 'leader',
              text: 'Has ** residual',
            ),
          ],
        ),
      ];

      final issues = ResponsiveReadingParser.validate(
        malformed,
        expectedCount: 57,
        verifyReading1Fixture: true,
      );
      expect(issues.any((i) => i.message.contains('Expected 57')), isTrue);
      expect(issues.any((i) => i.message.contains('Duplicate')), isTrue);
      expect(
        issues.any((i) => i.message.contains('Scripture reference is empty')),
        isTrue,
      );
      expect(issues.any((i) => i.message.contains('0 body lines')), isTrue);
      expect(issues.any((i) => i.message.contains('residual "**"')), isTrue);
    });
  });
}
