import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';

class CueBar extends StatefulWidget {
  final String soundingKey;
  final String? cueKey;
  final ValueChanged<String> onCueKeyChanged;

  const CueBar({
    super.key,
    required this.soundingKey,
    this.cueKey,
    required this.onCueKeyChanged,
  });

  @override
  State<CueBar> createState() => _CueBarState();
}

class _CueBarState extends State<CueBar> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription? _playerSub;
  bool _isPlaying = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _player.setReleaseMode(ReleaseMode.stop);
    _playerSub = _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _playerSub?.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  String get _effectiveCueKey => widget.cueKey ?? widget.soundingKey;

  Future<void> _playTonicCue() async {
    final keyRoot = _effectiveCueKey.replaceAll('m', '').trim();
    // Sanitize key name for asset (e.g. Eb -> Eb4, F# -> F#4)
    final assetPath = 'audio/cue/${keyRoot}4.ogg';

    setState(() => _isPlaying = true);
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      if (mounted) {
        setState(() => _isPlaying = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pitch cue unavailable on this device'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showCueKeyDialog(String newKey) {
    if (newKey == widget.soundingKey) {
      widget.onCueKeyChanged(newKey);
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Cue Key?'),
          content: Text(
            'Cue in $newKey while chords are in ${widget.soundingKey}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onCueKeyChanged(newKey);
              },
              child: Text('Use $newKey'),
            ),
          ],
        );
      },
    );
  }

  void _showKeyPicker() {
    final keys = [
      'C',
      'Db',
      'D',
      'Eb',
      'E',
      'F',
      'F#',
      'G',
      'Ab',
      'A',
      'Bb',
      'B',
    ];

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
                  'Select Tonic Cue Key',
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: keys.map((k) {
                    final isSelected =
                        k == _effectiveCueKey.replaceAll('m', '');
                    return ChoiceChip(
                      label: Text(k),
                      selected: isSelected,
                      selectedColor: AppColors.accentSoft,
                      side: BorderSide(
                        color: isSelected ? AppColors.accent : AppColors.borderStrong,
                      ),
                      labelStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppColors.accentText
                            : AppColors.textPrimary,
                      ),
                      onSelected: (val) {
                        Navigator.pop(context);
                        if (val) _showCueKeyDialog(k);
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
    const primaryColor = AppColors.primary;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Collapsible Drawer Handle + Header
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 3,
                      decoration: BoxDecoration(
                        color: AppColors.borderStrong,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _isExpanded
                                  ? Icons.expand_more
                                  : Icons.expand_less,
                              size: 18,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'PITCH PIPE / TONIC CUE',
                              style: TextStyle(
                                fontFamily: 'Space Grotesk',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.8,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'Key $_effectiveCueKey • 2s tone',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (_isExpanded) ...[
              const Divider(height: 1, thickness: 1, color: AppColors.border),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left: Cue descriptor
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _isPlaying
                                ? AppColors.accent
                                : AppColors.borderStrong,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Pitch Pipe / Tonic Cue',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '2-second acoustic tone',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Right: Key selector & Cue button
                    Row(
                      children: [
                        InkWell(
                          onTap: _showKeyPicker,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColors.canvasEn,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.borderStrong,
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'KEY: ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                                Text(
                                  _effectiveCueKey,
                                  style: const TextStyle(
                                    fontFamily: 'Space Grotesk',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  size: 16,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _isPlaying ? null : _playTonicCue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accentSoft,
                            foregroundColor: AppColors.accentText,
                            side: const BorderSide(color: AppColors.accent),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 0,
                            ),
                            minimumSize: const Size(80, 34),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(Icons.music_note, size: 16),
                          label: Text(
                            '♪ $_effectiveCueKey Cue',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
      ),
    );
  }
}
