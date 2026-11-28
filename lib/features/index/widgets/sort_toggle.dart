import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';
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
            color: AppColors.surfaceSubtle,
            borderRadius: BorderRadius.circular(10),
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
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: isActive ? Colors.white : AppColors.textMuted,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}