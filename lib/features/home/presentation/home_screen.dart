import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/catalog_stats_provider.dart';
import 'providers/home_search_provider.dart';
import 'widgets/catalog_card.dart';
import 'widgets/hero_banner.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_results_dropdown.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final void Function(int hymnId, int? hymnNumber, String language)? onHymnSelected;
  final void Function(String language)? onBrowseCatalog;

  const HomeScreen({
    super.key,
    this.onHymnSelected,
    this.onBrowseCatalog,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(homeSearchProvider);
    final statsAsync = ref.watch(catalogStatsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F9FC),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFD9E2FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.church_rounded,
                size: 20,
                color: Color(0xFF00357F),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Presbyterian Hymns',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: Color(0xFF00357F),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book_rounded, color: Color(0xFF00357F)),
            tooltip: 'Hymn Index',
            onPressed: () {
              if (widget.onBrowseCatalog != null) {
                widget.onBrowseCatalog!('ALL');
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HeroBanner(),
            const SizedBox(height: 16),
            SearchBarWidget(
              controller: _searchController,
              isLoading: searchState.isLoading,
              onChanged: (val) {
                ref.read(homeSearchProvider.notifier).onQueryChanged(val);
              },
              onClear: () {
                _searchController.clear();
                ref.read(homeSearchProvider.notifier).clearQuery();
              },
            ),
            if (searchState.query.trim().isNotEmpty) ...[
               const SizedBox(height: 8),
              SearchResultsDropdown(
                results: searchState.results,
                onHymnSelected: (hymnId, number, language) {
                  if (widget.onHymnSelected != null) {
                    widget.onHymnSelected!(hymnId, number, language);
                  }
                },
              ),
            ],
            const SizedBox(height: 20),
            statsAsync.when(
              data: (stats) => Column(
                children: [
                  CatalogCard(
                    title: 'English Hymnal',
                    description:
                        'Liturgical psalmody & carols with lyrics and chords where available.',
                    count: stats.english.total,
                    countLabel: 'Hymns',
                    primaryColor: const Color(0xFF00357F),
                    topBarColor: const Color(0xFF004AAD),
                    buttonLabel: 'Browse English Hymns',
                    onTap: () {
                      if (widget.onBrowseCatalog != null) {
                        widget.onBrowseCatalog!('EN');
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  CatalogCard(
                    title: 'Tagalog Himnaryo',
                    description:
                        'Banal na awitin at pagsambang may akmang tono ng gitara at titik sa Tagalog.',
                    count: stats.tagalog.total,
                    countLabel: 'Hymns',
                    primaryColor: const Color(0xFF735C00),
                    topBarColor: const Color(0xFFFED65B),
                    buttonLabel: 'Tingnan sa Tagalog',
                    onTap: () {
                      if (widget.onBrowseCatalog != null) {
                        widget.onBrowseCatalog!('TL');
                      }
                    },
                  ),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
