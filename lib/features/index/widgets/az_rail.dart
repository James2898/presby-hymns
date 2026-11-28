import 'package:flutter/material.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';

class AzRail extends StatelessWidget {
  final Set<String> availableLetters;
  final String? activeLetter;
  final ValueChanged<String> onLetterSelected;

  const AzRail({
    super.key,
    required this.availableLetters,
    this.activeLetter,
    required this.onLetterSelected,
  });

  static const List<String> letters = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J',
    'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
    'U', 'V', 'W', 'X', 'Y', 'Z',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'A-Z',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const VerticalDivider(width: 12, indent: 6, endIndent: 6),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: letters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 3),
              itemBuilder: (context, index) {
                final letter = letters[index];
                final isAvailable = availableLetters.contains(letter);
                final isSelected = activeLetter == letter;

                return GestureDetector(
                  onTap: isAvailable ? () => onLetterSelected(letter) : null,
                  child: Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : isAvailable
                              ? AppColors.primaryTint
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected || isAvailable
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : isAvailable
                                ? AppColors.primary
                                : AppColors.borderStrong,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}