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
  final CatalogCount english;
  final CatalogCount tagalog;

  const CatalogStats({
    this.english = const CatalogCount(numberedCount: 520, unnumberedCount: 0),
    this.tagalog = const CatalogCount(numberedCount: 380, unnumberedCount: 0),
  });
}
