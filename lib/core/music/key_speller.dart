class KeySpeller {
  static const sharpKeys = {'G', 'D', 'A', 'E', 'B', 'F#', 'C#', 'Em', 'Bm', 'F#m', 'C#m', 'G#m'};
  static const flatKeys = {'F', 'Bb', 'Eb', 'Ab', 'Db', 'Gb', 'Cb', 'Dm', 'Gm', 'Cm', 'Fm', 'Bbm'};

  static const sharpNotes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  static const flatNotes = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'Gb', 'G', 'Ab', 'A', 'Bb', 'B'];

  static int pitchOf(String note) {
    int idx = sharpNotes.indexOf(note);
    if (idx != -1) return idx;
    return flatNotes.indexOf(note);
  }

  static String spellPitch(int pitch, String targetKey) {
    final positivePitch = (pitch % 12 + 12) % 12;
    final useFlats = flatKeys.contains(targetKey);
    return useFlats ? flatNotes[positivePitch] : sharpNotes[positivePitch];
  }
}

class ChordTransposer {
  static final _chordRegex = RegExp(r'^([A-G][b#]?)(.*?)(?:/([A-G][b#]?))?$');

  /// Transposes a chord by semitoneOffset into targetKey
  static String transpose(String chord, int semitoneOffset, String targetKey) {
    final match = _chordRegex.firstMatch(chord);
    if (match == null) return chord;

    final root = match.group(1)!;
    final quality = match.group(2) ?? '';
    final bass = match.group(3);

    final rootPitch = KeySpeller.pitchOf(root);
    if (rootPitch == -1) return chord;

    final newRoot = KeySpeller.spellPitch(rootPitch + semitoneOffset, targetKey);

    if (bass != null) {
      final bassPitch = KeySpeller.pitchOf(bass);
      if (bassPitch != -1) {
        final newBass = KeySpeller.spellPitch(bassPitch + semitoneOffset, targetKey);
        return '$newRoot$quality/$newBass';
      }
    }

    return '$newRoot$quality';
  }
}

class CapoResolver {
  // Shape root offsets in semitones: C=0, A=9, G=7, E=4, D=2
  static const Map<String, int> cagedRoots = {
    'C': 0,
    'A': 9,
    'G': 7,
    'E': 4,
    'D': 2,
  };

  /// Calculates capo fret for a given concert key and desired CAGED shape
  static int? capoFor(String concertKey, String shape) {
    final keyRoot = KeySpeller.pitchOf(concertKey.replaceAll('m', ''));
    final shapeRoot = cagedRoots[shape.toUpperCase()];
    if (keyRoot == -1 || shapeRoot == null) return null;

    final fret = (keyRoot - shapeRoot + 12) % 12;
    return fret <= 7 ? fret : null;
  }

  /// Calculates the fingered shape chord when capo is on physical fret
  static String fingeredChord(String soundingChord, int capoFret, String soundingKey) {
    if (capoFret <= 0) return soundingChord;
    final shapeKey = KeySpeller.spellPitch(KeySpeller.pitchOf(soundingKey.replaceAll('m', '')) - capoFret, soundingKey);
    return ChordTransposer.transpose(soundingChord, -capoFret, shapeKey);
  }
}
