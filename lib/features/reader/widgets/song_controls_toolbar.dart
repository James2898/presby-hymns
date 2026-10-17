import 'package:flutter/material.dart';
import 'package:presby_hymns/core/music/key_speller.dart';

class SongControlsToolbar extends StatefulWidget {
  final bool hasChords;
  final String soundingKey;
  final String originalKey;
  final int capo;
  final double fontSize;
  final double lineSpacing;
  final bool hideChords;
  final ValueChanged<int> onTransposeStep;
  final ValueChanged<String> onSelectKey;
  final VoidCallback onReset;
  final ValueChanged<int> onSelectCapo;
  final ValueChanged<String> onSelectCaged;
  final ValueChanged<double> onAdjustFontSize;
  final ValueChanged<double> onAdjustLineSpacing;
  final VoidCallback onToggleHideChords;

  const SongControlsToolbar({
    super.key,
    required this.hasChords,
    required this.soundingKey,
    required this.originalKey,
    required this.capo,
    required this.fontSize,
    required this.lineSpacing,
    required this.hideChords,
    required this.onTransposeStep,
    required this.onSelectKey,
    required this.onReset,
    required this.onSelectCapo,
    required this.onSelectCaged,
    required this.onAdjustFontSize,
    required this.onAdjustLineSpacing,
    required this.onToggleHideChords,
  });

  @override
  State<SongControlsToolbar> createState() => _SongControlsToolbarState();
}

class _SongControlsToolbarState extends State<SongControlsToolbar> {
  bool _isExpanded = false;

  void _showKeyPicker(BuildContext context) {
    final isMinor = widget.soundingKey.endsWith('m');
    final keys = isMinor
        ? ['Am', 'Bbm', 'Bm', 'Cm', 'C#m', 'Dm', 'Ebm', 'Em', 'Fm', 'F#m', 'Gm', 'G#m']
        : ['C', 'Db', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab', 'A', 'Bb', 'B'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Select Key',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF00357F),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: keys.map((k) {
                    final isSelected = k == widget.soundingKey;
                    return ChoiceChip(
                      label: Text(k),
                      selected: isSelected,
                      selectedColor: const Color(0xFF004AAD),
                      labelStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
                      ),
                      onSelected: (val) {
                        Navigator.pop(context);
                        if (val) widget.onSelectKey(k);
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00357F);
    final summaryText = widget.hasChords
        ? 'Capo ${widget.capo} • Key ${widget.soundingKey}'
        : 'Text Size ${widget.fontSize.toInt()}px';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC3C6D5).withValues(alpha: 0.5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header / Summary toggle
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: primaryColor,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'SONG CONTROLS',
                        style: TextStyle(
                          fontFamily: 'Space Grotesk',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    summaryText,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: Color(0xFF434653),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8EA)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AC-14: If no chords, show only Size row!
                  if (widget.hasChords) ...[
                    // Key Transposition Row
                    Row(
                      children: [
                        const SizedBox(
                          width: 44,
                          child: Text(
                            'KEY',
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        _SmallBtn(
                          label: '-1',
                          onTap: () => widget.onTransposeStep(-1),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: () => _showKeyPicker(context),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF004AAD),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  widget.soundingKey,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down, size: 16, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        _SmallBtn(
                          label: '+1',
                          onTap: () => widget.onTransposeStep(1),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: widget.onReset,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(40, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Reset', style: TextStyle(fontSize: 11, color: primaryColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Capo Row (0 to 7)
                    Row(
                      children: [
                        const SizedBox(
                          width: 44,
                          child: Text(
                            'CAPO',
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: List.generate(8, (i) {
                                final isSelected = widget.capo == i;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: InkWell(
                                    onTap: () => widget.onSelectCapo(i),
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      width: 28,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected ? const Color(0xFF004AAD) : const Color(0xFFF3F3F6),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF004AAD) : const Color(0xFFC3C6D5),
                                        ),
                                      ),
                                      child: Text(
                                        '$i',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 11,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                          color: isSelected ? Colors.white : const Color(0xFF1A1C1E),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // CAGED Row
                    Row(
                      children: [
                        const SizedBox(
                          width: 44,
                          child: Text(
                            'CAGED',
                            style: TextStyle(
                              fontFamily: 'Space Grotesk',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Row(
                          children: ['C', 'A', 'G', 'E', 'D'].map((shape) {
                            final fret = CapoResolver.capoFor(widget.soundingKey, shape);
                            final isEnabled = fret != null && fret <= 7;
                            final isActive = isEnabled && widget.capo == fret;

                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: InkWell(
                                onTap: isEnabled ? () => widget.onSelectCaged(shape) : null,
                                borderRadius: BorderRadius.circular(6),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF004AAD)
                                        : (isEnabled ? const Color(0xFFF3F3F6) : const Color(0xFFE8E8EA)),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: isActive
                                          ? const Color(0xFF004AAD)
                                          : (isEnabled ? const Color(0xFFC3C6D5) : Colors.transparent),
                                    ),
                                  ),
                                  child: Text(
                                    shape,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isActive
                                          ? Colors.white
                                          : (isEnabled ? const Color(0xFF1A1C1E) : const Color(0xFF737784)),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Size & Hide Chords Row
                  Row(
                    children: [
                      const SizedBox(
                        width: 44,
                        child: Text(
                          'SIZE',
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _SmallBtn(
                        label: 'A-',
                        onTap: () => widget.onAdjustFontSize(-1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${widget.fontSize.toInt()}px',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _SmallBtn(
                        label: 'A+',
                        onTap: () => widget.onAdjustFontSize(1),
                      ),
                      if (widget.hasChords) ...[
                        const Spacer(),
                        InkWell(
                          onTap: widget.onToggleHideChords,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: widget.hideChords ? const Color(0xFF004AAD) : Colors.transparent,
                              border: Border.all(color: const Color(0xFF004AAD)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  widget.hideChords ? Icons.visibility_off : Icons.visibility,
                                  size: 14,
                                  color: widget.hideChords ? Colors.white : const Color(0xFF00357F),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.hideChords ? 'Show Chords' : 'Hide Chords',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: widget.hideChords ? Colors.white : const Color(0xFF00357F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Line Spacing Row
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(
                        width: 44,
                        child: Text(
                          'LINES',
                          style: TextStyle(
                            fontFamily: 'Space Grotesk',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: primaryColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      _SmallBtn(
                        label: '―',
                        onTap: () => widget.onAdjustLineSpacing(-0.2),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '${widget.lineSpacing.toStringAsFixed(1)}x',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _SmallBtn(
                        label: '＋',
                        onTap: () => widget.onAdjustLineSpacing(0.2),
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

class _SmallBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SmallBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F3F6),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFC3C6D5)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1C1E),
          ),
        ),
      ),
    );
  }
}