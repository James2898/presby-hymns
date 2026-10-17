import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:presby_hymns/features/reader/providers/reader_providers.dart';
import 'package:presby_hymns/features/reader/widgets/cue_bar.dart';
import 'package:presby_hymns/features/reader/widgets/empty_counterpart_view.dart';
import 'package:presby_hymns/features/reader/widgets/lyrics_canvas.dart';
import 'package:presby_hymns/features/reader/widgets/reader_header.dart';
import 'package:presby_hymns/features/reader/widgets/reader_metadata_card.dart';
import 'package:presby_hymns/features/reader/widgets/song_controls_toolbar.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int hymnId;
  final String initialLanguage;

  const ReaderScreen({
    super.key,
    required this.hymnId,
    this.initialLanguage = 'EN',
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  late String _currentLanguage;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _currentLanguage = widget.initialLanguage;

    // AC-16: Screen wake lock active during reading
    WakelockPlus.enable();
  }

  @override
  void dispose() {
    // Release wake lock when exiting reader
    WakelockPlus.disable();
    _scrollController.dispose();
    super.dispose();
  }

  void _switchLanguage(String newLang) {
    if (_currentLanguage == newLang) return;
    setState(() {
      _currentLanguage = newLang;
    });
    // D22 & spec: Language switch resets scroll to top
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final readerAsync = ref.watch(readerDataProvider((hymnId: widget.hymnId, lang: _currentLanguage)));

    // AC-11 & AC-12: Canvas tinting (EN: #FBF9F5, TG: #F5EFE6)
    final canvasBackgroundColor = _currentLanguage.toUpperCase() == 'TL'
        ? const Color(0xFFF5EFE6)
        : const Color(0xFFFBF9F5);

    return readerAsync.when(
      loading: () => Scaffold(
        backgroundColor: canvasBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: canvasBackgroundColor,
        body: Center(child: Text('Error loading hymn: $err')),
      ),
      data: (data) {
        if (data == null) {
          return Scaffold(
            backgroundColor: canvasBackgroundColor,
            appBar: AppBar(title: const Text('Hymn Not Found')),
            body: const Center(child: Text('This hymn does not exist in the database.')),
          );
        }

        final isUnnumbered = data.hymn.hymnNumber == null;
        final originalKey = data.hymn.originalKey;
        final prefsKey = (hymnId: widget.hymnId, originalKey: originalKey);
        final prefs = ref.watch(readerPreferencesProvider(prefsKey));
        final prefsNotifier = ref.read(readerPreferencesProvider(prefsKey).notifier);
        final cueKey = ref.watch(cueKeyProvider);

        // AC-17: Empty state fallback for untranslated songs
        final isMissingCounterpart = data.currentText.id == -1 || data.currentText.verseCount == 0;

        return Scaffold(
          backgroundColor: canvasBackgroundColor,
          appBar: ReaderHeader(
            currentLang: _currentLanguage,
            isUnnumbered: isUnnumbered,
            onLanguageChanged: _switchLanguage,
            hymnNumber: data.hymn.hymnNumber,
            hymnTitle: isMissingCounterpart ? 'Hymn #${data.hymn.hymnNumber}' : data.currentText.title,
            soundingKey: prefs.soundingKey,
            originalKey: originalKey,
            capo: prefs.capo,
          ),
          bottomNavigationBar: isMissingCounterpart
              ? null
              : CueBar(
                  soundingKey: prefs.soundingKey,
                  cueKey: cueKey,
                  onCueKeyChanged: (newKey) => ref.read(cueKeyProvider.notifier).setCueKey(newKey),
                ),
          body: isMissingCounterpart
              ? EmptyCounterpartView(
                  targetLanguage: _currentLanguage,
                  onReturn: () => _switchLanguage(_currentLanguage == 'TL' ? 'EN' : 'TL'),
                )
              : SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header & Metadata
                      ReaderMetadataCard(
                        hymnNumber: data.hymn.hymnNumber,
                        title: data.currentText.title,
                        soundingKey: prefs.soundingKey,
                        capo: prefs.capo,
                        meter: data.hymn.meter,
                        author: data.currentText.author,
                        translator: data.currentText.translator,
                        year: data.currentText.year,
                      ),

                      // AC-14: Collapsible Song Controls toolbar
                      SongControlsToolbar(
                        hasChords: data.currentText.hasChords == 1,
                        soundingKey: prefs.soundingKey,
                        originalKey: originalKey,
                        capo: prefs.capo,
                        fontSize: prefs.fontSize,
                        hideChords: prefs.hideChords,
                        onTransposeStep: (step) => prefsNotifier.transpose(step),
                        onSelectKey: (k) => prefsNotifier.setSoundingKey(k),
                        onReset: () => prefsNotifier.resetKeyAndCapo(),
                        onSelectCapo: (c) => prefsNotifier.setCapo(c),
                        onSelectCaged: (shape) => prefsNotifier.setCagedShape(shape),
                        onAdjustFontSize: (delta) => prefsNotifier.adjustFontSize(delta),
                        onToggleHideChords: () => prefsNotifier.toggleHideChords(),
                      ),

                      // AC-13: Synchronized ChordPro layout
                      LyricsCanvas(
                        songDoc: data.songDoc,
                        soundingKey: prefs.soundingKey,
                        capo: prefs.capo,
                        fontSize: prefs.fontSize,
                        hideChords: prefs.hideChords,
                        language: _currentLanguage,
                      ),

                      // Bottom spacing for docked Cue Bar
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        );
      },
    );
  }
}