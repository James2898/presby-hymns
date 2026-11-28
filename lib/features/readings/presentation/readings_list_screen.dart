import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';
import 'package:presby_hymns/data/database/app_database.dart';

import '../providers/readings_providers.dart';
import 'reading_detail_screen.dart';

class ReadingsListScreen extends ConsumerStatefulWidget {
  final ValueChanged<int>? onReadingSelected;

  const ReadingsListScreen({super.key, this.onReadingSelected});

  @override
  ConsumerState<ReadingsListScreen> createState() => _ReadingsListScreenState();
}

class _ReadingsListScreenState extends ConsumerState<ReadingsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _searchController.clear();
        ref.read(readingsSearchQueryProvider.notifier).clear();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openReading(int readingId) {
    if (widget.onReadingSelected != null) {
      widget.onReadingSelected!(readingId);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReadingDetailScreen(readingId: readingId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(readingsSearchQueryProvider);
    final filteredAsync = ref.watch(filteredReadingsProvider);

    return Scaffold(
      backgroundColor: AppColors.canvasTl,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        titleSpacing: 0,
        title: const Row(
          children: [
            Icon(Icons.menu_book_rounded, color: Colors.white, size: 22),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Tugunang Pagbasa',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.canvasTl,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  ref.read(readingsSearchQueryProvider.notifier).setQuery(val);
                },
                decoration: InputDecoration(
                  hintText: 'Search by number or title...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textMuted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.accentText,
                    size: 20,
                  ),
                  suffixIcon: query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          tooltip: 'Clear search',
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(readingsSearchQueryProvider.notifier)
                                .clear();
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
          ),
          Expanded(
            child: filteredAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Failed to load readings: $err',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (readings) {
                if (readings.isEmpty) {
                  final trimmed = query.trim();
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        trimmed.isEmpty
                            ? 'No responsive readings available.'
                            : 'No readings found matching "$trimmed".',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: readings.length,
                  itemBuilder: (context, index) {
                    final reading = readings[index];
                    return _ReadingListCard(
                      reading: reading,
                      onTap: () => _openReading(reading.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadingListCard extends StatelessWidget {
  final ResponsiveReading reading;
  final VoidCallback onTap;

  const _ReadingListCard({required this.reading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 44,
                  height: 48,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${reading.number}',
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentText,
                          height: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reading.title,
                        style: const TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reading.scriptureReference,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accentText,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
