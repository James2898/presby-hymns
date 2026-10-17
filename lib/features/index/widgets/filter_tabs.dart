import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/index_provider.dart';

class FilterTabs extends ConsumerWidget {
  const FilterTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTab = ref.watch(indexTabProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEFF0),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: [
          _buildTab(
            context: context,
            ref: ref,
            tab: IndexTab.all,
            label: 'All Hymns',
            icon: Icons.menu_book,
            isActive: currentTab == IndexTab.all,
          ),
          _buildTab(
            context: context,
            ref: ref,
            tab: IndexTab.english,
            label: 'English',
            dotColor: Colors.white,
            isActive: currentTab == IndexTab.english,
          ),
          _buildTab(
            context: context,
            ref: ref,
            tab: IndexTab.tagalog,
            label: 'Tagalog',
            dotColor: const Color(0xFFFED65B),
            isActive: currentTab == IndexTab.tagalog,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required WidgetRef ref,
    required IndexTab tab,
    required String label,
    IconData? icon,
    Color? dotColor,
    required bool isActive,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => ref.read(indexTabProvider.notifier).state = tab,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF00357F) : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isActive ? Colors.white : const Color(0xFF434653),
                ),
                const SizedBox(width: 6),
              ] else if (dotColor != null) ...[
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black.withOpacity(0.12),
                      width: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive ? Colors.white : const Color(0xFF434653),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}