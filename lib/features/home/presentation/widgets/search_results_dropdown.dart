import 'package:flutter/material.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';
import '../../domain/models/search_hit.dart';

class SearchResultsDropdown extends StatelessWidget {
  final GroupedSearchResults results;
  final void Function(int hymnId, int? number, String language) onHymnSelected;

  const SearchResultsDropdown({
    super.key,
    required this.results,
    required this.onHymnSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Text(
            'No hymns found matching your query.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (results.english.isNotEmpty) ...[
            _buildSectionHeader(
              title: 'ENGLISH HYMNS',
              count: results.englishTotal,
              headerColor: AppColors.primary,
            ),
            ...results.english.map(
              (hit) => _buildResultRow(
                hit: hit,
                pillColor: AppColors.primaryTint,
                pillTextColor: AppColors.primary,
                chevronColor: AppColors.primary,
              ),
            ),
          ],
          if (results.tagalog.isNotEmpty) ...[
            _buildSectionHeader(
              title: 'TAGALOG HIMNARYO',
              count: results.tagalogTotal,
              headerColor: AppColors.accentText,
            ),
            ...results.tagalog.map(
              (hit) => _buildResultRow(
                hit: hit,
                pillColor: AppColors.accentSoft,
                pillTextColor: AppColors.accentText,
                chevronColor: AppColors.accentText,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required int count,
    required Color headerColor,
  }) {
    return Container(
      color: AppColors.surfaceSubtle,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.auto_stories, size: 15, color: headerColor),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: headerColor,
                ),
              ),
            ],
          ),
          Text(
            '$count ${count == 1 ? "match" : "matches"}',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow({
    required SearchHit hit,
    required Color pillColor,
    required Color pillTextColor,
    required Color chevronColor,
  }) {
    return InkWell(
      onTap: () => onHymnSelected(hit.hymnId, hit.number, hit.language),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          children: [
            if (hit.isNumbered) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: pillColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '#${hit.number}',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: pillTextColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hit.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (hit.firstLine.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      '“${hit.firstLine}”',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 18, color: chevronColor),
          ],
        ),
      ),
    );
  }
}
