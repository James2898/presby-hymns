import 'package:flutter/material.dart';

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
        color: const Color(0xFFF3F3F6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
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
                color: Color(0xFF737784),
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
                          ? const Color(0xFF00357F)
                          : isAvailable
                              ? const Color(0xFFD9E2FF)
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
                                ? const Color(0xFF00357F)
                                : const Color(0xFFC3C6D5),
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