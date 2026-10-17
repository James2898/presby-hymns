class ChordLyricPair {
  final String? chord;
  final String text;

  const ChordLyricPair({this.chord, required this.text});

  @override
  String toString() => chord != null ? '[$chord]$text' : text;
}

enum SectionType { verse, chorus, ending }

class Section {
  final SectionType type;
  final int? number;
  final List<List<ChordLyricPair>> lines;

  const Section({required this.type, this.number, required this.lines});
}

class SongDoc {
  final int? number;
  final String title;
  final String key;
  final String? author;
  final String? year;
  final String? tune;
  final String? meter;
  final List<Section> sections;

  const SongDoc({
    this.number,
    required this.title,
    required this.key,
    this.author,
    this.year,
    this.tune,
    this.meter,
    required this.sections,
  });

  /// Extracts clean text suitable for search indexing and reading
  String get plainText {
    final buffer = StringBuffer();
    for (final sec in sections) {
      for (final line in sec.lines) {
        final lineStr = line.map((p) => p.text).join();
        if (lineStr.trim().isNotEmpty) {
          buffer.writeln(lineStr.trim());
        }
      }
    }
    return buffer.toString().trim();
  }

  /// First line preview
  String get firstLineSnippet {
    for (final sec in sections) {
      for (final line in sec.lines) {
        final lineStr = line.map((p) => p.text).join().trim();
        if (lineStr.isNotEmpty) {
          return lineStr;
        }
      }
    }
    return '';
  }
}

class ChordProParser {
  static final _metaDirectiveRegex = RegExp(r'^\{([a-zA-Z_]+)(?::\s*(.*))?\}$');
  static final _bracketRegex = RegExp(r'\[([^\]]+)\]');

  static SongDoc parse(String chordpro) {
    int? number;
    String title = '';
    String key = 'C';
    String? author;
    String? year;
    String? tune;
    String? meter;

    final sections = <Section>[];
    SectionType currentSectionType = SectionType.verse;
    int? currentVerseNum;
    List<List<ChordLyricPair>> currentLines = [];
    bool inSection = false;

    void closeCurrentSection() {
      if (inSection && currentLines.isNotEmpty) {
        sections.add(Section(
          type: currentSectionType,
          number: currentVerseNum,
          lines: List.from(currentLines),
        ));
        currentLines.clear();
      }
      inSection = false;
    }

    final rawLines = chordpro.split('\n');

    for (var rawLine in rawLines) {
      final line = rawLine.trim();
      if (line.isEmpty) continue;

      final metaMatch = _metaDirectiveRegex.firstMatch(line);
      if (metaMatch != null) {
        final directive = metaMatch.group(1)!.toLowerCase();
        final value = (metaMatch.group(2) ?? '').trim();

        switch (directive) {
          case 'number':
            number = int.tryParse(value);
            break;
          case 'title':
            title = value;
            break;
          case 'key':
            key = value;
            break;
          case 'author':
            author = value;
            break;
          case 'year':
            year = value;
            break;
          case 'tune':
            tune = value;
            break;
          case 'meter':
            meter = value;
            break;
          case 'start_of_verse':
          case 'sov':
            closeCurrentSection();
            currentSectionType = SectionType.verse;
            currentVerseNum = int.tryParse(value) ?? (sections.where((s) => s.type == SectionType.verse).length + 1);
            inSection = true;
            break;
          case 'end_of_verse':
          case 'eov':
            closeCurrentSection();
            break;
          case 'start_of_chorus':
          case 'soc':
            closeCurrentSection();
            currentSectionType = SectionType.chorus;
            currentVerseNum = null;
            inSection = true;
            break;
          case 'end_of_chorus':
          case 'eoc':
            closeCurrentSection();
            break;
          case 'start_of_ending':
            closeCurrentSection();
            currentSectionType = SectionType.ending;
            currentVerseNum = null;
            inSection = true;
            break;
          case 'end_of_ending':
            closeCurrentSection();
            break;
        }
        continue;
      }

      // If text exists without explicit {sov}, open default verse 1
      if (!inSection) {
        currentSectionType = SectionType.verse;
        currentVerseNum = 1;
        inSection = true;
      }

      // Parse chords inside line
      currentLines.add(_parseLinePairs(line));
    }

    closeCurrentSection();

    return SongDoc(
      number: number,
      title: title,
      key: key,
      author: author,
      year: year,
      tune: tune,
      meter: meter,
      sections: sections,
    );
  }

  static List<ChordLyricPair> _parseLinePairs(String line) {
    final pairs = <ChordLyricPair>[];
    int cursor = 0;
    String? pendingChord;

    final matches = _bracketRegex.allMatches(line);

    for (final match in matches) {
      if (match.start > cursor) {
        final text = line.substring(cursor, match.start);
        pairs.add(ChordLyricPair(chord: pendingChord, text: text));
        pendingChord = null;
      }
      pendingChord = match.group(1);
      cursor = match.end;
    }

    if (cursor < line.length) {
      pairs.add(ChordLyricPair(chord: pendingChord, text: line.substring(cursor)));
    } else if (pendingChord != null) {
      pairs.add(ChordLyricPair(chord: pendingChord, text: ''));
    }

    if (pairs.isEmpty) {
      pairs.add(ChordLyricPair(chord: null, text: line));
    }

    return pairs;
  }
}
