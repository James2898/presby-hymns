import 'package:flutter/material.dart';
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E2E5)),
        ),
        child: const Center(
          child: Text(
            'No hymns found matching your query.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF737784),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E2E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (results.english.isNotEmpty) ...[
            _buildSectionHeader(
              title: 'ENGLISH HYMNS',
              count: results.englishTotal,
              headerColor: const Color(0xFF00357F),
            ),
            ...results.english.map(
              (hit) => _buildResultRow(
                hit: hit,
                pillColor: const Color(0xFFD9E2FF),
                pillTextColor: const Color(0xFF001945),
                chevronColor: const Color(0xFF00357F),
              ),
            ),
          ],
          if (results.tagalog.isNotEmpty) ...[
            _buildSectionHeader(
              title: 'TAGALOG HIMNARYO',
              count: results.tagalogTotal,
              headerColor: const Color(0xFF735C00),
            ),
            ...results.tagalog.map(
              (hit) => _buildResultRow(
                hit: hit,
                pillColor: const Color(0xFFFFE088),
                pillTextColor: const Color(0xFF241A00),
                chevronColor: const Color(0xFF735C00),
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
      color: const Color(0xFFF3F3F6),
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
              color: Color(0xFF737784),
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
            bottom: BorderSide(color: Color(0xFFEEEEF0)),
          ),
        ),
        child: Row(
          children: [
            if (hit.isNumbered) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: pillColor,
                  borderRadius: BorderRadius.circular(12),
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
                      color: Color(0xFF1A1C1E),
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
                        color: Color(0xFF434653),
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
