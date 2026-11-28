import 'package:flutter/material.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';

class EmptyCounterpartView extends StatelessWidget {
  final String targetLanguage;
  final VoidCallback onReturn;

  const EmptyCounterpartView({
    super.key,
    required this.targetLanguage,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final isTagalog = targetLanguage.toUpperCase() == 'TL';
    final heading = isTagalog ? 'Walang Salin sa Tagalog' : 'No English Translation';
    final message = isTagalog
        ? 'Ang himnong ito ay kasalukuyang walang awtorisadong salin sa Tagalog.'
        : 'This hymn currently has no English translation available.';
    final buttonLabel = isTagalog ? 'Bumalik sa English' : 'Back to Tagalog';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.menu_book_outlined,
                size: 48,
                color: AppColors.borderStrong,
              ),
              const SizedBox(height: 16),
              Text(
                heading,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: onReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                icon: const Icon(Icons.arrow_back, size: 16),
                label: Text(
                  buttonLabel,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}