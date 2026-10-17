import 'package:flutter/material.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key});

  static const Color presbyterianBlue = Color(0xFF004AAD);
  static const Color subtitleGold = Color(0xFFFFE088);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: presbyterianBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: subtitleGold.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.church_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'PRESBYTERIAN HYMNS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Space Grotesk',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'BILINGUAL HYMNAL & CHORDS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0,
              color: subtitleGold,
            ),
          ),
        ],
      ),
    );
  }
}
