class SearchNormalizer {
  static final _chordTokenRegex = RegExp(r'\[[^\]]+\]');
  static final _punctuationRegex = RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()?"’!\\]');
  static final _whitespaceRegex = RegExp(r'\s+');

  /// Normalizes lyrics and queries:
  /// - Strips ChordPro [chord] tokens
  /// - Joins syllable hyphens ("Ho - ly" -> "Holy")
  /// - Strips punctuation and collapses spaces
  /// - Lowercases
  static String normalize(String text) {
    // 1. Remove chord tags
    var result = text.replaceAll(_chordTokenRegex, '');

    // 2. Join hyphenated syllables: ' - ' or '- ' or ' -'
    result = result.replaceAll(RegExp(r'\s*-\s*'), '');

    // 3. Lowercase
    result = result.toLowerCase();

    // 4. Remove diacritics / accents common in Tagalog / English
    result = removeDiacritics(result);

    // 5. Remove punctuation
    result = result.replaceAll(_punctuationRegex, ' ');

    // 6. Collapse spaces
    return result.replaceAll(_whitespaceRegex, ' ').trim();
  }

  static String removeDiacritics(String str) {
    const withDia = 'áàảãạăắằẳẵặâấầẩẫậéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵđ';
    const noDia   = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
    var out = str;
    for (int i = 0; i < withDia.length; i++) {
      out = out.replaceAll(withDia[i], noDia[i]);
    }
    return out;
  }

  /// Builds FTS5 matching query: quotes tokens, trailing wildcard on last token
  static String buildFtsQuery(String rawQuery) {
    final clean = normalize(rawQuery);
    if (clean.isEmpty) return '';

    final tokens = clean.split(' ').where((t) => t.isNotEmpty).toList();
    if (tokens.isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      if (i == tokens.length - 1) {
        buffer.write('"$token"*');
      } else {
        buffer.write('"$token" ');
      }
    }
    return buffer.toString().trim();
  }
}
