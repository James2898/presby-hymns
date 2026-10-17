import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReaderHeader extends StatelessWidget implements PreferredSizeWidget {
  final String currentLang;
  final bool isUnnumbered;
  final ValueChanged<String> onLanguageChanged;
  final int? hymnNumber;
  final String hymnTitle;
  final String soundingKey;
  final String originalKey;
  final int capo;
  final VoidCallback? onPreviousHymn;
  final VoidCallback? onNextHymn;
  final int? prevHymnNumber;
  final int? nextHymnNumber;

  const ReaderHeader({
    super.key,
    required this.currentLang,
    required this.isUnnumbered,
    required this.onLanguageChanged,
    this.hymnNumber,
    required this.hymnTitle,
    required this.soundingKey,
    required this.originalKey,
    required this.capo,
    this.onPreviousHymn,
    this.onNextHymn,
    this.prevHymnNumber,
    this.nextHymnNumber,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  Future<void> _handleReport(BuildContext context) async {
    const reportEmail = String.fromEnvironment('REPORT_EMAIL', defaultValue: 'maintainer@presbyhymns.local');
    PackageInfo packageInfo;
    try {
      packageInfo = await PackageInfo.fromPlatform();
    } catch (_) {
      packageInfo = PackageInfo(appName: 'Presby Hymns', packageName: '', version: '1.0.0', buildNumber: '1');
    }

    final subject = '[Hymns] $currentLang #${hymnNumber ?? "Unnumbered"} – $hymnTitle';
    final body = '''Hymn: $currentLang #${hymnNumber ?? "Unnumbered"} – $hymnTitle
Key: $soundingKey (original $originalKey) · Capo: $capo
App: ${packageInfo.version}+${packageInfo.buildNumber}
---
Describe the problem:
''';

    final mailUri = Uri(
      scheme: 'mailto',
      path: reportEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    try {
      final launched = await launchUrl(mailUri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await Clipboard.setData(ClipboardData(text: '$reportEmail\n\n$subject\n\n$body'));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Copied report to clipboard ($reportEmail)'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (_) {
      await Clipboard.setData(ClipboardData(text: '$reportEmail\n\n$subject\n\n$body'));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied report to clipboard ($reportEmail)'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00357F);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: primaryColor),
        onPressed: () => Navigator.of(context).maybePop(),
        tooltip: 'Back',
      ),
      titleSpacing: 0,
      title: isUnnumbered
          ? const Text(
              'Presbyterian Hymns',
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: primaryColor,
                letterSpacing: 0.5,
              ),
            )
          : Container(
              height: 38,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _LangButton(
                    label: 'English',
                    icon: Icons.menu_book,
                    isSelected: currentLang.toUpperCase() == 'EN',
                    onTap: () => onLanguageChanged('EN'),
                  ),
                  _LangButton(
                    label: 'Tagalog',
                    icon: Icons.translate,
                    isSelected: currentLang.toUpperCase() == 'TL',
                    onTap: () => onLanguageChanged('TL'),
                  ),
                ],
              ),
            ),
      actions: [
        if (hymnNumber != null) ...[
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 16),
            color: onPreviousHymn != null ? primaryColor : const Color(0xFFC3C6D5),
            tooltip: onPreviousHymn != null ? 'Previous Hymn (#$prevHymnNumber)' : 'No Previous Hymn',
            onPressed: onPreviousHymn,
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            color: onNextHymn != null ? primaryColor : const Color(0xFFC3C6D5),
            tooltip: onNextHymn != null ? 'Next Hymn (#$nextHymnNumber)' : 'No Next Hymn',
            onPressed: onNextHymn,
          ),
        ],
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: primaryColor),
          onSelected: (value) {
            if (value == 'report') {
              _handleReport(context);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'report',
              child: Row(
                children: [
                  Icon(Icons.flag_outlined, size: 18, color: primaryColor),
                  SizedBox(width: 8),
                  Text('Report a problem', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LangButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _LangButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF004AAD) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isSelected
              ? [const BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : const Color(0xFF434653),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF434653),
              ),
            ),
          ],
        ),
      ),
    );
  }
}