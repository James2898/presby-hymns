class ParsedReadingLine {
  final int lineOrder;
  final String role;
  final String text;

  const ParsedReadingLine({
    required this.lineOrder,
    required this.role,
    required this.text,
  });
}

class ParsedResponsiveReading {
  final String language;
  final int number;
  final String title;
  final String scriptureReference;
  final List<ParsedReadingLine> lines;

  const ParsedResponsiveReading({
    required this.language,
    required this.number,
    required this.title,
    required this.scriptureReference,
    required this.lines,
  });
}

class ReadingValidationIssue {
  final int? readingNumber;
  final String message;

  const ReadingValidationIssue({this.readingNumber, required this.message});

  @override
  String toString() {
    final prefix = readingNumber != null ? 'Reading #$readingNumber: ' : '';
    return '$prefix$message';
  }
}

class ResponsiveReadingParser {
  ResponsiveReadingParser._();

  static final RegExp _headerRegex = RegExp(
    r'^\*\*\s*T[au]guna?n?g?\s+Pagbasa\s+Bilang\s+(\d+)\s*:?\s*\*\*$',
    caseSensitive: false,
  );
  static final RegExp _allLineRegex = RegExp(r'^\*\*\*(.+?)\*\*\*$');
  static final RegExp _leaderLineRegex = RegExp(r'^\*\*(.+?)\*\*([.,;:?!]*)$');
  static final RegExp _trimEdgeRegex = RegExp(r'^[ \t\u2003]+|[ \t\u2003]+$');
  static final RegExp _internalSpaceRegex = RegExp(r'[ \t\u2003]+');

  /// Normalizes a single line: trims ASCII spaces, tabs, and em-spaces,
  /// collapses internal space/tab runs to a single space, and unescapes `\!`.
  static String normalizeLine(String rawLine) {
    var line = rawLine.replaceAll(_trimEdgeRegex, '').trim();
    if (line.isEmpty) return '';
    line = line.replaceAll(_internalSpaceRegex, ' ');
    line = line.replaceAll(r'\!', '!');
    return line;
  }

  /// Parses raw Markdown containing Tagalog Responsive Readings line-by-line.
  static List<ParsedResponsiveReading> parse(
    String rawContent, {
    String language = 'TL',
  }) {
    var normalized = rawContent;
    if (normalized.startsWith('\uFEFF')) {
      normalized = normalized.substring(1);
    }
    normalized = normalized.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final cleanedLines = <String>[];
    for (final rawLine in normalized.split('\n')) {
      final cleaned = normalizeLine(rawLine);
      if (cleaned.isNotEmpty) {
        cleanedLines.add(cleaned);
      }
    }

    final sections = <({int number, List<String> lines})>[];
    int? currentNumber;
    List<String>? currentLines;

    for (final line in cleanedLines) {
      final headerMatch = _headerRegex.firstMatch(line);
      if (headerMatch != null) {
        if (currentNumber != null && currentLines != null) {
          sections.add((number: currentNumber, lines: currentLines));
        }
        currentNumber = int.parse(headerMatch.group(1)!);
        currentLines = <String>[];
      } else if (currentLines != null) {
        currentLines.add(line);
      }
    }

    if (currentNumber != null && currentLines != null) {
      sections.add((number: currentNumber, lines: currentLines));
    }

    final readings = <ParsedResponsiveReading>[];
    for (final section in sections) {
      final sectionLines = section.lines;
      if (sectionLines.isEmpty) {
        readings.add(
          ParsedResponsiveReading(
            language: language,
            number: section.number,
            title: '',
            scriptureReference: '',
            lines: const [],
          ),
        );
        continue;
      }

      final title = _parseTitle(sectionLines.first);
      final remaining = sectionLines.sublist(1);

      int lastFormattedIndex = -1;
      for (int i = 0; i < remaining.length; i++) {
        final candidate = remaining[i];
        if (_allLineRegex.hasMatch(candidate) ||
            _leaderLineRegex.hasMatch(candidate)) {
          lastFormattedIndex = i;
        }
      }

      final bodyRawLines = lastFormattedIndex >= 0
          ? remaining.sublist(0, lastFormattedIndex + 1)
          : const <String>[];
      final referenceRawLines = lastFormattedIndex >= 0
          ? remaining.sublist(lastFormattedIndex + 1)
          : remaining;

      final scriptureReference = referenceRawLines.join(' ').trim();
      final parsedBody = <ParsedReadingLine>[];

      for (int i = 0; i < bodyRawLines.length; i++) {
        final rawBodyLine = bodyRawLines[i];
        final allMatch = _allLineRegex.firstMatch(rawBodyLine);
        if (allMatch != null) {
          parsedBody.add(
            ParsedReadingLine(
              lineOrder: i + 1,
              role: 'all',
              text: allMatch.group(1)!.trim(),
            ),
          );
          continue;
        }

        final leaderMatch = _leaderLineRegex.firstMatch(rawBodyLine);
        if (leaderMatch != null) {
          final text = '${leaderMatch.group(1)!.trim()}${leaderMatch.group(2)!}'
              .trim();
          parsedBody.add(
            ParsedReadingLine(lineOrder: i + 1, role: 'leader', text: text),
          );
          continue;
        }

        parsedBody.add(
          ParsedReadingLine(
            lineOrder: i + 1,
            role: 'people',
            text: rawBodyLine,
          ),
        );
      }

      readings.add(
        ParsedResponsiveReading(
          language: language,
          number: section.number,
          title: title,
          scriptureReference: scriptureReference,
          lines: parsedBody,
        ),
      );
    }

    return readings;
  }

  static String _parseTitle(String rawTitle) {
    final leaderMatch = _leaderLineRegex.firstMatch(rawTitle);
    if (leaderMatch != null) {
      return '${leaderMatch.group(1)!.trim()}${leaderMatch.group(2)!}'.trim();
    }
    var trimmed = rawTitle.trim();
    if (trimmed.startsWith('**') &&
        trimmed.endsWith('**') &&
        trimmed.length >= 4) {
      trimmed = trimmed.substring(2, trimmed.length - 2).trim();
    }
    return trimmed;
  }

  /// Validates parsed readings against structural, uniqueness, and fixture rules.
  static List<ReadingValidationIssue> validate(
    List<ParsedResponsiveReading> readings, {
    int? expectedCount,
    bool verifyReading1Fixture = false,
  }) {
    final issues = <ReadingValidationIssue>[];

    if (readings.isEmpty) {
      issues.add(
        const ReadingValidationIssue(message: 'Parsed 0 responsive readings.'),
      );
      return issues;
    }

    if (expectedCount != null && readings.length != expectedCount) {
      issues.add(
        ReadingValidationIssue(
          message:
              'Expected $expectedCount responsive readings, found ${readings.length}.',
        ),
      );
    }

    final seenKeys = <String>{};
    const validRoles = {'leader', 'people', 'all'};

    for (final reading in readings) {
      final key = '${reading.language}:${reading.number}';
      if (!seenKeys.add(key)) {
        issues.add(
          ReadingValidationIssue(
            readingNumber: reading.number,
            message: 'Duplicate (language, number) entry: ($key).',
          ),
        );
      }

      if (reading.title.isEmpty) {
        issues.add(
          ReadingValidationIssue(
            readingNumber: reading.number,
            message: 'Title is empty.',
          ),
        );
      } else if (reading.title.contains('**')) {
        issues.add(
          ReadingValidationIssue(
            readingNumber: reading.number,
            message: 'Title contains residual "**" marker: "${reading.title}".',
          ),
        );
      }

      if (reading.scriptureReference.isEmpty) {
        issues.add(
          ReadingValidationIssue(
            readingNumber: reading.number,
            message: 'Scripture reference is empty.',
          ),
        );
      } else if (reading.scriptureReference.contains('**')) {
        issues.add(
          ReadingValidationIssue(
            readingNumber: reading.number,
            message:
                'Scripture reference contains residual "**" marker: "${reading.scriptureReference}".',
          ),
        );
      }

      if (reading.lines.isEmpty) {
        issues.add(
          ReadingValidationIssue(
            readingNumber: reading.number,
            message: 'Reading has 0 body lines.',
          ),
        );
      }

      for (final line in reading.lines) {
        if (!validRoles.contains(line.role)) {
          issues.add(
            ReadingValidationIssue(
              readingNumber: reading.number,
              message:
                  'Line ${line.lineOrder} has invalid role "${line.role}".',
            ),
          );
        }
        if (line.text.isEmpty) {
          issues.add(
            ReadingValidationIssue(
              readingNumber: reading.number,
              message: 'Line ${line.lineOrder} has empty text.',
            ),
          );
        }
        if (line.text.contains('**')) {
          issues.add(
            ReadingValidationIssue(
              readingNumber: reading.number,
              message:
                  'Line ${line.lineOrder} contains residual "**" marker: "${line.text}".',
            ),
          );
        }
      }
    }

    if (expectedCount != null) {
      final sortedNumbers = readings.map((r) => r.number).toList()..sort();
      final expectedNumbers = List.generate(expectedCount, (i) => i + 1);
      if (sortedNumbers.length == expectedNumbers.length) {
        for (int i = 0; i < expectedNumbers.length; i++) {
          if (sortedNumbers[i] != expectedNumbers[i]) {
            issues.add(
              ReadingValidationIssue(
                message:
                    'Reading numbers are not consecutive 1..$expectedCount (found ${sortedNumbers[i]} at position ${i + 1}).',
              ),
            );
            break;
          }
        }
      }
    }

    if (verifyReading1Fixture) {
      final reading1 = readings.where((r) => r.number == 1).firstOrNull;
      if (reading1 == null) {
        issues.add(
          const ReadingValidationIssue(
            readingNumber: 1,
            message: 'Missing Reading #1 fixture.',
          ),
        );
      } else {
        final leaderCount = reading1.lines
            .where((l) => l.role == 'leader')
            .length;
        final peopleCount = reading1.lines
            .where((l) => l.role == 'people')
            .length;
        final allCount = reading1.lines.where((l) => l.role == 'all').length;

        if (reading1.title != 'Ang Daan Ng Buhay') {
          issues.add(
            ReadingValidationIssue(
              readingNumber: 1,
              message:
                  'Reading #1 fixture title mismatch: expected "Ang Daan Ng Buhay", got "${reading1.title}".',
            ),
          );
        }
        if (reading1.scriptureReference != 'Awit 1:1-6') {
          issues.add(
            ReadingValidationIssue(
              readingNumber: 1,
              message:
                  'Reading #1 fixture reference mismatch: expected "Awit 1:1-6", got "${reading1.scriptureReference}".',
            ),
          );
        }
        if (reading1.lines.length != 12 ||
            leaderCount != 6 ||
            peopleCount != 5 ||
            allCount != 1) {
          issues.add(
            ReadingValidationIssue(
              readingNumber: 1,
              message:
                  'Reading #1 fixture line count mismatch: expected 12 (6 leader, 5 people, 1 all), got ${reading1.lines.length} ($leaderCount leader, $peopleCount people, $allCount all).',
            ),
          );
        }
      }
    }

    return issues;
  }
}
