import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/index_item.dart';
import 'providers/index_provider.dart';
import 'widgets/az_rail.dart';
import 'widgets/filter_tabs.dart';
import 'widgets/song_card.dart';
import 'widgets/sort_toggle.dart';
import 'widgets/unnumbered_section_header.dart';

class IndexScreen extends ConsumerStatefulWidget {
  final void Function(int hymnId, String language)? onHymnSelected;

  const IndexScreen({
    super.key,
    this.onHymnSelected,
  });

  @override
  ConsumerState<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends ConsumerState<IndexScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;
  String? _activeLetter;

  @override
  void initState() {
    super.initState();
    // Item 8: Reset search field and state whenever entering IndexScreen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchController.clear();
        ref.read(indexSearchQueryProvider.notifier).state = '';
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollToLetter(String letter, List<IndexItem> items) {
    final index = items.indexWhere((item) {
      final firstLetter = item.sortTitle.isNotEmpty
          ? item.sortTitle[0].toUpperCase()
          : '';
      return firstLetter == letter;
    });

    if (index != -1 && _scrollController.hasClients) {
      setState(() => _activeLetter = letter);
      // Average height per card ~120px + headers
      final targetOffset = (index * 115.0).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(indexListProvider);
    final activeSort = ref.watch(indexSortProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00357F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        titleSpacing: 0,
        title: const Row(
          children: [
            Icon(Icons.church, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Text(
              'Presbyterian Hymns',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Sticky Top Controls Section
          Container(
            color: const Color(0xFFF9F9FC),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                // Search Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      _debounceTimer?.cancel();
                      _debounceTimer = Timer(const Duration(milliseconds: 150), () {
                        if (mounted) {
                          ref.read(indexSearchQueryProvider.notifier).state = val;
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search #, title, or lyrics...',
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF737784),
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color(0xFF00357F),
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _debounceTimer?.cancel();
                                _searchController.clear();
                                ref.read(indexSearchQueryProvider.notifier).state = '';
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const FilterTabs(),
                const SizedBox(height: 10),
                const SortToggle(),
              ],
            ),
          ),

          // Main List View & Sticky A-Z Rail
          Expanded(
            child: listAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF00357F)),
              ),
              error: (err, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Failed to load hymns: $err',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hymns found matching criteria.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFF737784),
                      ),
                    ),
                  );
                }

                final availableLetters = items
                    .map((item) => item.sortTitle.isNotEmpty
                        ? item.sortTitle[0].toUpperCase()
                        : '')
                    .where((l) => l.isNotEmpty && RegExp(r'[A-Z]').hasMatch(l))
                    .toSet();

                final numberedItems = items.where((i) => !i.isUnnumbered).toList();
                final unnumberedItems = items.where((i) => i.isUnnumbered).toList();

                return Column(
                  children: [
                    // Sticky A-Z Rail (visible ONLY in Title sort mode, AC-8)
                    if (activeSort == IndexSort.title)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: AzRail(
                          availableLetters: availableLetters,
                          activeLetter: _activeLetter,
                          onLetterSelected: (letter) => _scrollToLetter(letter, items),
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        itemCount: activeSort == IndexSort.number
                            ? numberedItems.length + (unnumberedItems.isNotEmpty ? unnumberedItems.length + 1 : 0)
                            : items.length,
                        itemBuilder: (context, index) {
                          if (activeSort == IndexSort.number) {
                            if (index < numberedItems.length) {
                              final item = numberedItems[index];
                              return SongCard(
                                item: item,
                                onTap: () => widget.onHymnSelected?.call(item.hymnId, item.language),
                              );
                            } else if (index == numberedItems.length) {
                              return const UnnumberedSectionHeader();
                            } else {
                              final unnumberedIndex = index - numberedItems.length - 1;
                              final item = unnumberedItems[unnumberedIndex];
                              return SongCard(
                                item: item,
                                onTap: () => widget.onHymnSelected?.call(item.hymnId, item.language),
                              );
                            }
                          } else {
                            final item = items[index];
                            return SongCard(
                              item: item,
                              onTap: () => widget.onHymnSelected?.call(item.hymnId, item.language),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}