import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
    final keyRoot = _effectiveCueKey.replaceAll('m', '');
    // Sanitize key name for asset (e.g. Eb -> Eb4, F# -> F#4)
    final assetPath = 'audio/cue/${keyRoot}4.ogg';

    setState(() => _isPlaying = true);
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // In development or if audio asset not yet packaged, simulate 2s playback
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _isPlaying = false);
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
          content: Text('Cue in $newKey while chords are in ${widget.soundingKey}?'),
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
    final keys = ['C', 'Db', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'Ab', 'A', 'Bb', 'B'];

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
                    color: Color(0xFF00357F),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: keys.map((k) {
                    final isSelected = k == _effectiveCueKey.replaceAll('m', '');
                    return ChoiceChip(
                      label: Text(k),
                      selected: isSelected,
                      selectedColor: const Color(0xFFFED65B),
                      labelStyle: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        color: isSelected ? const Color(0xFF745C00) : const Color(0xFF1A1C1E),
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
    const primaryColor = Color(0xFF00357F);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFC3C6D5), width: 1),
        ),
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
                        color: const Color(0xFFC3C6D5),
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
                              _isExpanded ? Icons.expand_more : Icons.expand_less,
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
                            color: Color(0xFF434653),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (_isExpanded) ...[
              const Divider(height: 1, thickness: 1, color: Color(0xFFE8E8EA)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            color: _isPlaying ? const Color(0xFF735C00) : const Color(0xFFC3C6D5),
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
                                color: Color(0xFF1A1C1E),
                              ),
                            ),
                            Text(
                              '2-second acoustic tone',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: Color(0xFF434653),
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
                              color: const Color(0xFFF3F3F6),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFC3C6D5)),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'KEY: ',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF434653),
                                  ),
                                ),
                                Text(
                                  _effectiveCueKey,
                                  style: const TextStyle(
                                    fontFamily: 'Space Grotesk',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF00357F),
                                  ),
                                ),
                                const Icon(Icons.arrow_drop_down, size: 16, color: Color(0xFF434653)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _isPlaying ? null : _playTonicCue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFED65B),
                            foregroundColor: const Color(0xFF745C00),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
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