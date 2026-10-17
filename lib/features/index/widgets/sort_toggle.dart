import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/index_provider.dart';

class SortToggle extends ConsumerWidget {
  const SortToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeSort = ref.watch(indexSortProvider);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8EA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildButton(
                ref: ref,
                sort: IndexSort.number,
                label: 'Number',
                icon: Icons.tag,
                isActive: activeSort == IndexSort.number,
              ),
              const SizedBox(width: 4),
              _buildButton(
                ref: ref,
                sort: IndexSort.title,
                label: 'Title',
                icon: Icons.sort_by_alpha,
                isActive: activeSort == IndexSort.title,
              ),
            ],
          ),
        ),
        const Spacer(),
        Text(
          activeSort == IndexSort.number
              ? 'Sorted by Hymnal Number'
              : 'Sorted Alphabetically',
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF737784),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required WidgetRef ref,
    required IndexSort sort,
    required String label,
    required IconData icon,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => ref.read(indexSortProvider.notifier).state = sort,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF004AAD) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive ? Colors.white : const Color(0xFF434653),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF434653),
              ),
            ),
          ],
        ),
      ),
    );
  }
}