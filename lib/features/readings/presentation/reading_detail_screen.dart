import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';
import 'package:presby_hymns/data/database/app_database.dart';

import '../providers/readings_providers.dart';

class ReadingDetailScreen extends ConsumerStatefulWidget {
  final int readingId;

  const ReadingDetailScreen({super.key, required this.readingId});

  @override
  ConsumerState<ReadingDetailScreen> createState() =>
      _ReadingDetailScreenState();
}

class _ReadingDetailScreenState extends ConsumerState<ReadingDetailScreen> {
  late int _currentReadingId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentReadingId = widget.readingId;
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToReading(int targetReadingId) {
    if (_currentReadingId == targetReadingId) return;
    setState(() {
      _currentReadingId = targetReadingId;
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(readingDetailProvider(_currentReadingId));
    final fontSize = ref.watch(readingFontSizeProvider);
    final fontSizeNotifier = ref.read(readingFontSizeProvider.notifier);

    return detailAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.canvasTl,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (err, _) => Scaffold(
        backgroundColor: AppColors.canvasTl,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Back',
          ),
          title: const Text(
            'Tugunang Pagbasa',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error loading reading: $err',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
      data: (detail) {
        if (detail == null) {
          return Scaffold(
            backgroundColor: AppColors.canvasTl,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Back',
              ),
              title: const Text(
                'Reading Not Found',
                style: TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'This reading does not exist in the database.',
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, size: 16),
                      label: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final reading = detail.reading;
        final adjacentAsync = ref.watch(
          adjacentReadingsProvider(reading.number),
        );
        final prevReading = adjacentAsync.value?.previous;
        final nextReading = adjacentAsync.value?.next;

        final canDecrease = fontSize > kReadingMinFontSize;
        final canIncrease = fontSize < kReadingMaxFontSize;

        return Scaffold(
          backgroundColor: AppColors.canvasTl,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primary),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Back',
            ),
            titleSpacing: 0,
            title: const Text(
              'Tugunang Pagbasa',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Space Grotesk',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.4,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                color: prevReading != null
                    ? AppColors.primary
                    : AppColors.borderStrong,
                tooltip: prevReading != null
                    ? 'Previous Reading (#${prevReading.number})'
                    : 'No Previous Reading',
                onPressed: prevReading != null
                    ? () => _navigateToReading(prevReading.id)
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                color: nextReading != null
                    ? AppColors.primary
                    : AppColors.borderStrong,
                tooltip: nextReading != null
                    ? 'Next Reading (#${nextReading.number})'
                    : 'No Next Reading',
                onPressed: nextReading != null
                    ? () => _navigateToReading(nextReading.id)
                    : null,
              ),
            ],
          ),
          body: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ReadingHeaderCard(reading: reading),
                const SizedBox(height: 12),
                _TextSizeControlBar(
                  fontSize: fontSize,
                  canDecrease: canDecrease,
                  canIncrease: canIncrease,
                  onDecrease: canDecrease
                      ? () => fontSizeNotifier.decrease()
                      : null,
                  onIncrease: canIncrease
                      ? () => fontSizeNotifier.increase()
                      : null,
                ),
                const SizedBox(height: 12),
                _ReadingBodyCard(
                  lines: detail.lines,
                  fontSize: fontSize,
                  scriptureReference: reading.scriptureReference,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          side: const BorderSide(color: AppColors.borderStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: Icon(
                          Icons.arrow_back,
                          size: 16,
                          color: prevReading != null
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                        label: Text(
                          prevReading != null
                              ? 'Reading #${prevReading.number}'
                              : 'First Reading',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: prevReading != null
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                        onPressed: prevReading != null
                            ? () => _navigateToReading(prevReading.id)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                          side: const BorderSide(color: AppColors.borderStrong),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        iconAlignment: IconAlignment.end,
                        icon: Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: nextReading != null
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                        label: Text(
                          nextReading != null
                              ? 'Reading #${nextReading.number}'
                              : 'Last Reading',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: nextReading != null
                                ? AppColors.primary
                                : AppColors.textMuted,
                          ),
                        ),
                        onPressed: nextReading != null
                            ? () => _navigateToReading(nextReading.id)
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ReadingHeaderCard extends StatelessWidget {
  final ResponsiveReading reading;

  const _ReadingHeaderCard({required this.reading});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 4, color: AppColors.accent),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accent, width: 1),
                  ),
                  child: Text(
                    'Tugunang Pagbasa Bilang ${reading.number}',
                    style: const TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: AppColors.accentText,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  reading.title,
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.canvasTl,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 2),
                        child: Icon(
                          Icons.menu_book_outlined,
                          size: 14,
                          color: AppColors.accentText,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          reading.scriptureReference,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentText,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TextSizeControlBar extends StatelessWidget {
  final double fontSize;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onIncrease;

  const _TextSizeControlBar({
    required this.fontSize,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TEXT SIZE',
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
              color: AppColors.primary,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Tooltip(
                message: 'Decrease text size',
                child: OutlinedButton(
                  onPressed: onDecrease,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(42, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(
                      color: canDecrease
                          ? AppColors.borderStrong
                          : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    foregroundColor: AppColors.textPrimary,
                    disabledForegroundColor: AppColors.borderStrong,
                    backgroundColor: AppColors.canvasTl,
                  ),
                  child: const Text(
                    'A-',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${fontSize.toInt()}px',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Tooltip(
                message: 'Increase text size',
                child: OutlinedButton(
                  onPressed: onIncrease,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(42, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide(
                      color: canIncrease
                          ? AppColors.borderStrong
                          : AppColors.border,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    foregroundColor: AppColors.textPrimary,
                    disabledForegroundColor: AppColors.borderStrong,
                    backgroundColor: AppColors.canvasTl,
                  ),
                  child: const Text(
                    'A+',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadingBodyCard extends StatelessWidget {
  final List<ResponsiveReadingLine> lines;
  final double fontSize;
  final String scriptureReference;

  const _ReadingBodyCard({
    required this.lines,
    required this.fontSize,
    required this.scriptureReference,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < lines.length; i++) ...[
            _ReadingLineItem(line: lines[i], fontSize: fontSize),
            if (i < lines.length - 1) const SizedBox(height: 14),
          ],
          if (scriptureReference.trim().isNotEmpty) ...[
            const SizedBox(height: 18),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            Text(
              scriptureReference,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReadingLineItem extends StatelessWidget {
  final ResponsiveReadingLine line;
  final double fontSize;

  const _ReadingLineItem({required this.line, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    final (
      String fontFamily,
      TextAlign align,
      FontWeight weight,
      FontStyle style,
      Color color,
    ) = switch (line.role) {
      'leader' => (
        'Source Serif 4',
        TextAlign.left,
        FontWeight.bold,
        FontStyle.normal,
        AppColors.textPrimary,
      ),
      'people' => (
        'Inter',
        TextAlign.right,
        FontWeight.normal,
        FontStyle.normal,
        AppColors.accentTextLight,
      ),
      'all' => (
        'Space Grotesk',
        TextAlign.center,
        FontWeight.bold,
        FontStyle.italic,
        AppColors.accentText,
      ),
      _ => (
        'Source Serif 4',
        TextAlign.left,
        FontWeight.normal,
        FontStyle.normal,
        AppColors.textPrimary,
      ),
    };

    return SizedBox(
      width: double.infinity,
      child: Text(
        line.textContent,
        textAlign: align,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          height: 1.5,
          fontWeight: weight,
          fontStyle: style,
          color: color,
        ),
      ),
    );
  }
}
