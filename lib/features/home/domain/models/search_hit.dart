class SearchHit {
  final int hymnId;
  final int? number;
  final String language; // 'EN' or 'TL'
  final String title;
  final String firstLine;

  const SearchHit({
    required this.hymnId,
    this.number,
    required this.language,
    required this.title,
    required this.firstLine,
  });

  bool get isNumbered => number != null;
}

class GroupedSearchResults {
  final List<SearchHit> english;
  final List<SearchHit> tagalog;
  final int englishTotal;
  final int tagalogTotal;

  const GroupedSearchResults({
    this.english = const [],
    this.tagalog = const [],
    this.englishTotal = 0,
    this.tagalogTotal = 0,
  });

  bool get isEmpty => english.isEmpty && tagalog.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
