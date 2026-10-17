import 'package:presby_hymns/core/chordpro/chordpro_parser.dart';
import 'package:presby_hymns/data/database/app_database.dart';

class ReaderHymnData {
  final Hymn hymn;
  final HymnText currentText;
  final SongDoc songDoc;
  final bool hasEnglishCounterpart;
  final bool hasTagalogCounterpart;

  const ReaderHymnData({
    required this.hymn,
    required this.currentText,
    required this.songDoc,
    required this.hasEnglishCounterpart,
    required this.hasTagalogCounterpart,
  });
}

enum ReaderTextAlign {
  left,
  center,
  right,
  justify,
}

class ReaderPreferences {
  final String soundingKey;
  final int capo;
  final double fontSize;
  final double lineSpacing;
  final ReaderTextAlign textAlign;
  final bool hideChords;

  const ReaderPreferences({
    required this.soundingKey,
    this.capo = 0,
    this.fontSize = 19.0,
    this.lineSpacing = 1.5,
    this.textAlign = ReaderTextAlign.left,
    this.hideChords = false,
  });

  ReaderPreferences copyWith({
    String? soundingKey,
    int? capo,
    double? fontSize,
    double? lineSpacing,
    ReaderTextAlign? textAlign,
    bool? hideChords,
  }) {
    return ReaderPreferences(
      soundingKey: soundingKey ?? this.soundingKey,
      capo: capo ?? this.capo,
      fontSize: fontSize ?? this.fontSize,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      textAlign: textAlign ?? this.textAlign,
      hideChords: hideChords ?? this.hideChords,
    );
  }
}