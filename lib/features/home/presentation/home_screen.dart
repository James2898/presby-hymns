import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';

import 'providers/catalog_stats_provider.dart';
import 'providers/home_search_provider.dart';
import 'widgets/catalog_card.dart';
import 'widgets/hero_banner.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/search_results_dropdown.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final void Function(int hymnId, int? hymnNumber, String language)?
  onHymnSelected;
  final void Function(String language)? onBrowseCatalog;
  final VoidCallback? onBrowseReadings;

  const HomeScreen({
    super.key,
    this.onHymnSelected,
    this.onBrowseCatalog,
    this.onBrowseReadings,
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
    final totalHymns = statsAsync.whenOrNull(data: (stats) => stats.totalHymns);

    return Scaffold(
      backgroundColor: AppColors.canvasEn,
      appBar: AppBar(
        backgroundColor: AppColors.canvasEn,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryTint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.church_rounded,
                size: 20,
                color: AppColors.primary,
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
                color: AppColors.primary,
              ),
            ),
          ],
        ),
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
            CatalogCard(
              title: 'Hymns',
              description: 'English and Tagalog liturgical hymns with lyrics and chords where available.',
              count: totalHymns,
              countLabel: 'Hymns',
              primaryColor: AppColors.primary,
              topBarColor: AppColors.primary,
              buttonLabel: 'Browse Hymns',
              onTap: () {
                widget.onBrowseCatalog?.call('ALL');
              },
            ),
            const SizedBox(height: 16),
            CatalogCard(
              title: 'Tugunang Pagbasa',
              description: 'Mga tugunang pagbasa mula sa Banal na Kasulatan para sa pagsamba.',
              primaryColor: AppColors.accentText,
              topBarColor: AppColors.accent,
              buttonLabel: 'Tingnan ang mga Pagbasa',
              onTap: () {
                widget.onBrowseReadings?.call();
              },
            ),
            const SizedBox(height: 16),
            const CatalogCard(
              title: 'Westminster Shorter Catechism',
              description: 'Foundational Reformed questions and answers on Christian faith and duty.',
              badgeText: 'Coming soon',
              badgeBackgroundColor: AppColors.accentSoft,
              badgeTextColor: AppColors.accentText,
              primaryColor: AppColors.textMuted,
              topBarColor: AppColors.borderStrong,
              buttonLabel: 'Browse Catechism',
              enabled: false,
              onTap: null,
            ),
          ],
        ),
      ),
    );
  }
}
