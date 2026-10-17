import 'package:flutter/material.dart';
import 'package:presby_hymns/core/chordpro/chordpro_parser.dart';
import 'package:presby_hymns/core/music/key_speller.dart';
import 'package:presby_hymns/features/reader/models/reader_models.dart';

class LyricsCanvas extends StatelessWidget {
  final SongDoc songDoc;
  final String soundingKey;
  final int capo;
  final double fontSize;
  final double lineSpacing;
  final ReaderTextAlign textAlign;
  final bool hideChords;
  final String language;

  const LyricsCanvas({
    super.key,
    required this.songDoc,
    required this.soundingKey,
    required this.capo,
    required this.fontSize,
    this.lineSpacing = 1.5,
    this.textAlign = ReaderTextAlign.left,
    required this.hideChords,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    // Collect chorus sections
    final chorusSection = songDoc.sections.where((s) => s.type == SectionType.chorus).firstOrNull;
    final endingSection = songDoc.sections.where((s) => s.type == SectionType.ending).firstOrNull;
    final verseSections = songDoc.sections.where((s) => s.type == SectionType.verse).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // AC-13 & D22: For each verse, render verse, then chorus (if defined)
        ...verseSections.map((verse) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildVerseBlock(verse),
              if (chorusSection != null) ...[
                const SizedBox(height: 12),
                _buildChorusBlock(chorusSection),
              ],
              const SizedBox(height: 16),
            ],
          );
        }),

        // If song has chorus but no verses (or standalone sections)
        if (verseSections.isEmpty && chorusSection != null) ...[
          _buildChorusBlock(chorusSection),
          const SizedBox(height: 16),
        ],

        // Ending / Amen
        if (endingSection != null) ...[
          _buildEndingBlock(endingSection),
          const SizedBox(height: 24),
        ],
      ],
    );
  }

  Widget _buildVerseBlock(Section verse) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x06000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 30,
                height: 30,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFFED65B),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${verse.number ?? 1}',
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF735C00), // Contrast ratio >= 6:1 (passes AAA-large)
                  ),
                ),
              ),
              Text(
                'Verse ${verse.number ?? 1}',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF434653),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...verse.lines.map((line) => _buildLyricLine(line)),
        ],
      ),
    );
  }

  Widget _buildChorusBlock(Section chorus) {
    final label = language.toUpperCase() == 'TL' ? 'KORO' : 'REFRAIN';

    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border(
          left: BorderSide(
            color: Color(0xFF6E1628), // Crimson left-rule (tertiary)
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.repeat, size: 14, color: Color(0xFF6E1628)),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Space Grotesk',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Color(0xFF6E1628),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...chorus.lines.map((line) => _buildLyricLine(line)),
        ],
      ),
    );
  }

  Widget _buildEndingBlock(Section ending) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEF0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            ...ending.lines.map((line) => _buildLyricLine(line, isEnding: true)),
          ],
        ),
      ),
    );
  }

  Widget _buildLyricLine(List<ChordLyricPair> pairs, {bool isEnding = false}) {
    final spacingRatio = lineSpacing / 1.5;

    // If hiding chords, join all text directly
    if (hideChords) {
      final lineText = pairs.map((p) => p.text).join();
      final flutterAlign = switch (textAlign) {
        ReaderTextAlign.center => TextAlign.center,
        ReaderTextAlign.right => TextAlign.right,
        ReaderTextAlign.justify => TextAlign.justify,
        ReaderTextAlign.left => TextAlign.left,
      };

      return Padding(
        padding: EdgeInsets.only(bottom: 8 * spacingRatio),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            lineText,
            textAlign: flutterAlign,
            style: TextStyle(
              fontFamily: 'Source Serif 4',
              fontSize: fontSize,
              height: lineSpacing,
              color: const Color(0xFF1A1C1E),
            ),
          ),
        ),
      );
    }

    final wrapAlign = switch (textAlign) {
      ReaderTextAlign.center => WrapAlignment.center,
      ReaderTextAlign.right => WrapAlignment.end,
      ReaderTextAlign.justify || ReaderTextAlign.left => WrapAlignment.start,
    };

    // Synchronized Chord-over-syllable layout
    return Padding(
      padding: EdgeInsets.only(bottom: 10 * spacingRatio),
      child: SizedBox(
        width: double.infinity,
        child: Wrap(
          alignment: wrapAlign,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: pairs.map((pair) {
          final displayedChord = pair.chord != null && pair.chord!.isNotEmpty
              ? CapoResolver.fingeredChord(pair.chord!, capo, soundingKey)
              : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Chord Row
              SizedBox(
                height: fontSize * 0.9,
                child: displayedChord != null
                    ? Text(
                        displayedChord,
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: fontSize * 0.72,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00357F),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              // Lyric Syllable
              Text(
                pair.text.isEmpty && displayedChord != null ? ' ' : pair.text,
                style: TextStyle(
                  fontFamily: 'Source Serif 4',
                  fontSize: fontSize,
                  height: 1.3 * spacingRatio,
                  color: isEnding ? const Color(0xFF735C00) : const Color(0xFF1A1C1E),
                ),
              ),
            ],
          );
        }).toList(),
        ),
      ),
    );
  }
}