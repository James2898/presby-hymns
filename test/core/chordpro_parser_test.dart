import 'package:test/test.dart';
import 'package:presby_hymns/core/chordpro/chordpro_parser.dart';

void main() {
  group('ChordProParser', () {
    test('parses metadata directives and verse sections correctly', () {
      const input = '''
{number: 1}
{title: Doxology}
{key: G}

{start_of_verse: 1}
[G] Praise God,
From whom all blessings flow
[C][D] All creatures here below
{end_of_verse}
''';

      final doc = ChordProParser.parse(input);
      expect(doc.number, equals(1));
      expect(doc.title, equals('Doxology'));
      expect(doc.key, equals('G'));
      expect(doc.sections.length, equals(1));
      expect(doc.sections.first.type, equals(SectionType.verse));
      expect(doc.sections.first.number, equals(1));

      final lines = doc.sections.first.lines;
      expect(lines.length, equals(3));
      expect(lines[0][0].chord, equals('G'));
      expect(lines[0][0].text, equals(' Praise God,'));
      expect(doc.firstLineSnippet, equals('Praise God,'));
    });
  });
}
