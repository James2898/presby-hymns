import 'package:flutter/foundation.dart';

@immutable
class IndexItem {
  final int hymnId;
  final int? hymnNumber;
  final String title;
  final String sortTitle;
  final String? alternateTitle;
  final String? author;
  final String? year;
  final String? meter;
  final String key;
  final bool hasTagalog;
  final String language; // 'EN' or 'TL'
  final bool isUnnumbered;

  const IndexItem({
    required this.hymnId,
    this.hymnNumber,
    required this.title,
    required this.sortTitle,
    this.alternateTitle,
    this.author,
    this.year,
    this.meter,
    required this.key,
    required this.hasTagalog,
    required this.language,
    required this.isUnnumbered,
  });

  String get metadataLine {
    final parts = <String>[];
    if (author != null && author!.isNotEmpty) {
      if (year != null && year!.isNotEmpty) {
        parts.add('$author ($year)');
      } else {
        parts.add(author!);
      }
    }
    if (meter != null && meter!.isNotEmpty) {
      parts.add(meter!);
    }
    return parts.join(' • ');
  }
}