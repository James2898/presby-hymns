class CatalogCount {
  final int numberedCount;
  final int unnumberedCount;

  const CatalogCount({
    required this.numberedCount,
    required this.unnumberedCount,
  });

  int get total => numberedCount + unnumberedCount;
}

class CatalogStats {
  final int totalHymns;
  final CatalogCount english;
  final CatalogCount tagalog;

  const CatalogStats({
    this.totalHymns = 0,
    this.english = const CatalogCount(numberedCount: 0, unnumberedCount: 0),
    this.tagalog = const CatalogCount(numberedCount: 0, unnumberedCount: 0),
  });
}
