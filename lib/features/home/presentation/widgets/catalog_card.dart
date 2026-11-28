import 'package:flutter/material.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';

class CatalogCard extends StatelessWidget {
  final String title;
  final String description;
  final int? count;
  final String? countLabel;
  final IconData countIcon;
  final String? badgeText;
  final Color primaryColor;
  final Color topBarColor;
  final Color badgeBackgroundColor;
  final Color badgeTextColor;
  final String buttonLabel;
  final VoidCallback? onTap;
  final bool enabled;

  const CatalogCard({
    super.key,
    required this.title,
    required this.description,
    this.count,
    this.countLabel,
    this.countIcon = Icons.library_music,
    this.badgeText,
    required this.primaryColor,
    required this.topBarColor,
    this.badgeBackgroundColor = AppColors.primaryTint,
    this.badgeTextColor = AppColors.primary,
    required this.buttonLabel,
    this.onTap,
    this.enabled = true,
  });

  bool get _isInteractive => enabled && onTap != null;

  @override
  Widget build(BuildContext context) {
    final hasCount =
        count != null && countLabel != null && countLabel!.isNotEmpty;
    final hasBadge = badgeText != null && badgeText!.isNotEmpty;
    final showTopMetaRow = hasCount || hasBadge;

    final effectiveTopBarColor = _isInteractive
        ? topBarColor
        : AppColors.borderStrong;
    final effectiveTitleColor = _isInteractive
        ? primaryColor
        : AppColors.textMuted;
    final effectiveCardColor = _isInteractive
        ? AppColors.surface
        : AppColors.surface;

    return Semantics(
      enabled: _isInteractive,
      container: true,
      child: Container(
        decoration: BoxDecoration(
          color: effectiveCardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isInteractive ? AppColors.border : AppColors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isInteractive ? onTap : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(height: 4, color: effectiveTopBarColor),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showTopMetaRow) ...[
                        Row(
                          mainAxisAlignment: hasCount
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.end,
                          children: [
                            if (hasCount)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    countIcon,
                                    size: 14,
                                    color: effectiveTitleColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$count $countLabel',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            if (hasBadge)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeBackgroundColor,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  badgeText!,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                    color: badgeTextColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: effectiveTitleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          fontStyle: FontStyle.italic,
                          color: AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: AppColors.surfaceSubtle,
                            disabledForegroundColor: AppColors.textMuted,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _isInteractive ? onTap : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                buttonLabel,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (_isInteractive) ...[
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 16,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
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
