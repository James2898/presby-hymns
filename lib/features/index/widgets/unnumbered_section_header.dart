import 'package:flutter/material.dart';

class UnnumberedSectionHeader extends StatelessWidget {
  const UnnumberedSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      margin: const EdgeInsets.only(top: 8, bottom: 6),
      child: const Row(
        children: [
          Expanded(child: Divider(color: Color(0xFFC3C6D5), thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Icon(
                  Icons.queue_music,
                  size: 16,
                  color: Color(0xFF737784),
                ),
                SizedBox(width: 6),
                Text(
                  'UNNUMBERED SONGS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                    color: Color(0xFF737784),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: Divider(color: Color(0xFFC3C6D5), thickness: 1)),
        ],
      ),
    );
  }
}