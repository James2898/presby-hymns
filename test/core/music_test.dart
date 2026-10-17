import 'package:test/test.dart';
import 'package:presby_hymns/core/music/key_speller.dart';

void main() {
  group('ChordTransposer & KeySpeller', () {
    test('transposes standard chords and slash chords correctly', () {
      expect(ChordTransposer.transpose('D', 1, 'Eb'), equals('Eb'));
      expect(ChordTransposer.transpose('G', 2, 'A'), equals('A'));
      expect(ChordTransposer.transpose('D/F#', 1, 'Eb'), equals('Eb/G'));
      expect(ChordTransposer.transpose('Am7', 2, 'B'), equals('Bm7'));
    });

    test('round trip 12 semitones produces identical chord', () {
      expect(ChordTransposer.transpose('C', 12, 'C'), equals('C'));
      expect(ChordTransposer.transpose('F#m7', -12, 'D'), equals('F#m7'));
    });
  });

  group('CapoResolver', () {
    test('calculates correct CAGED capo positions', () {
      // Key C with A shape: C (0) - A (9) = -9 = 3 frets
      expect(CapoResolver.capoFor('C', 'A'), equals(3));
      // Key G with G shape = 0
      expect(CapoResolver.capoFor('G', 'G'), equals(0));
      // Key Eb with D shape: Eb (3) - D (2) = 1 fret
      expect(CapoResolver.capoFor('Eb', 'D'), equals(1));
    });

    test('disables CAGED shapes requiring fret > 7', () {
      // Key G with C shape: G (7) - C (0) = 7 (allowed)
      expect(CapoResolver.capoFor('G', 'C'), equals(7));
      // Key Ab with C shape: Ab (8) - C (0) = 8 (disabled)
      expect(CapoResolver.capoFor('Ab', 'C'), isNull);
    });

    test('computes correct fingered chord when capo is set', () {
      // In Key of C, with Capo 3, a C chord fingers as A shape
      expect(CapoResolver.fingeredChord('C', 3, 'C'), equals('A'));
      // In Key of D, with Capo 2, a D chord fingers as C shape
      expect(CapoResolver.fingeredChord('D', 2, 'D'), equals('C'));
    });
  });
}
