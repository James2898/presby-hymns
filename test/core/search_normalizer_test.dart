import 'package:test/test.dart';
import 'package:presby_hymns/core/search/search_normalizer.dart';

void main() {
  group('SearchNormalizer', () {
    test('joins syllable hyphens and ignores chord markers', () {
      const input = '[Eb]Ho - ly, [Cm]ho - ly, [Ab]ho - [Eb]ly! Lord God Al - [Bb]migh - ty!';
      final normalized = SearchNormalizer.normalize(input);
      expect(normalized, equals('holy holy holy lord god almighty'));
    });

    test('normalizes Tagalog diacritics and accents', () {
      expect(SearchNormalizer.normalize('Diyós na Dakilà'), equals('diyos na dakila'));
    });

    test('builds valid FTS5 query with prefix search on last token', () {
      expect(SearchNormalizer.buildFtsQuery('holy lord'), equals('"holy" "lord"*'));
      expect(SearchNormalizer.buildFtsQuery('banal'), equals('"banal"*'));
    });
  });
}
