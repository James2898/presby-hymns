import 'package:flutter/material.dart';
import 'package:presby_hymns/core/music/key_speller.dart';

class ReaderMetadataCard extends StatelessWidget {
  final int? hymnNumber;
  final String title;
  final String soundingKey;
  final int capo;
  final String? meter;
  final String? author;
  final String? translator;
  final String? year;

  const ReaderMetadataCard({
    super.key,
    this.hymnNumber,
    required this.title,
    required this.soundingKey,
    required this.capo,
    this.meter,
    this.author,
    this.translator,
    this.year,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00357F);
    final isMinor = soundingKey.endsWith('m');
    final rootOnly = soundingKey.replaceAll('m', '');
    final shapeKeyRoot = capo > 0
        ? KeySpeller.spellPitch(KeySpeller.pitchOf(rootOnly) - capo, soundingKey)
        : rootOnly;
    final shapeKey = isMinor ? '${shapeKeyRoot}m' : shapeKeyRoot;

    final keyLabel = capo > 0
        ? 'Key of $soundingKey (Capo $capo • Shape $shapeKey)'
        : 'Key of $soundingKey';

    final authorYear = [
      if (author != null && author!.isNotEmpty) author,
      if (translator != null && translator!.isNotEmpty) 'Tr. $translator',
      if (year != null && year!.isNotEmpty) year,
    ].join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF004AAD),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  hymnNumber != null ? 'HYMN #$hymnNumber' : 'SONG',
                  style: const TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: Colors.white,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.music_note, size: 16, color: Color(0xFF735C00)),
                  const SizedBox(width: 4),
                  Text(
                    keyLabel,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF745C00),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: primaryColor,
              height: 1.25,
            ),
          ),
          if (meter != null || authorYear.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  if (meter != null && meter!.isNotEmpty) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.straighten, size: 14, color: Color(0xFF735C00)),
                        const SizedBox(width: 4),
                        Text(
                          'Meter: $meter',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF434653),
                          ),
                        ),
                      ],
                    ),
                    if (authorYear.isNotEmpty)
                      const Text('•', style: TextStyle(color: Color(0xFFC3C6D5))),
                  ],
                  if (authorYear.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.history_edu, size: 14, color: Color(0xFF735C00)),
                        const SizedBox(width: 4),
                        Text(
                          authorYear,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Color(0xFF434653),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}