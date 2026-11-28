import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presby_hymns/core/search/search_normalizer.dart';
import 'package:presby_hymns/data/database/app_database.dart';

import '../data/readings_repository.dart';
import '../models/reading_models.dart';

const double kReadingDefaultFontSize = 19.0;
const double kReadingMinFontSize = 12.0;
const double kReadingMaxFontSize = 28.0;
const String kReadingFontSizePrefKey = 'settings.fontSize';

final readingsRepositoryProvider = Provider<ReadingsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return ReadingsRepository(db);
});

final readingsListProvider = FutureProvider<List<ResponsiveReading>>((ref) {
  final repo = ref.watch(readingsRepositoryProvider);
  return repo.getReadings(language: 'TL');
});

class ReadingsSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

final readingsSearchQueryProvider =
    NotifierProvider<ReadingsSearchQueryNotifier, String>(
      ReadingsSearchQueryNotifier.new,
    );

final filteredReadingsProvider = Provider<AsyncValue<List<ResponsiveReading>>>((
  ref,
) {
  final readingsAsync = ref.watch(readingsListProvider);
  final rawQuery = ref.watch(readingsSearchQueryProvider);

  return readingsAsync.whenData((readings) {
    final trimmed = rawQuery.trim();
    if (trimmed.isEmpty) return readings;

    final digitsOnly = RegExp(r'^\d+$').hasMatch(trimmed);
    if (digitsOnly) {
      final targetNum = int.tryParse(trimmed);
      if (targetNum == null) return const [];
      return readings.where((r) => r.number == targetNum).toList();
    }

    final normalizedQuery = SearchNormalizer.normalize(trimmed);
    final diacriticStrippedQuery = SearchNormalizer.removeDiacritics(
      trimmed.toLowerCase(),
    );

    return readings.where((reading) {
      if (normalizedQuery.isNotEmpty) {
        final normalizedTitle = SearchNormalizer.normalize(reading.title);
        if (normalizedTitle.contains(normalizedQuery)) return true;
      }
      final plainTitle = SearchNormalizer.removeDiacritics(
        reading.title.toLowerCase(),
      );
      return plainTitle.contains(diacriticStrippedQuery);
    }).toList();
  });
});

final readingDetailProvider =
    FutureProvider.family<ResponsiveReadingDetail?, int>((ref, readingId) {
      final repo = ref.watch(readingsRepositoryProvider);
      return repo.getReadingById(readingId);
    });

final adjacentReadingsProvider = FutureProvider.family<AdjacentReadings, int>((
  ref,
  readingNumber,
) {
  final repo = ref.watch(readingsRepositoryProvider);
  return repo.getAdjacentReadings(readingNumber, language: 'TL');
});

class ReadingFontSizeNotifier extends Notifier<double> {
  bool _userModified = false;

  @override
  double build() {
    var disposed = false;
    ref.onDispose(() => disposed = true);

    Future.microtask(() async {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getDouble(kReadingFontSizePrefKey);
      if (!disposed && !_userModified && saved != null) {
        state = saved.clamp(kReadingMinFontSize, kReadingMaxFontSize);
      }
    });

    return kReadingDefaultFontSize;
  }

  Future<void> adjust(double delta) async {
    _userModified = true;
    final next = (state + delta).clamp(
      kReadingMinFontSize,
      kReadingMaxFontSize,
    );
    state = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(kReadingFontSizePrefKey, next);
  }

  Future<void> increase() => adjust(1.0);

  Future<void> decrease() => adjust(-1.0);
}

final readingFontSizeProvider =
    NotifierProvider<ReadingFontSizeNotifier, double>(
      ReadingFontSizeNotifier.new,
    );
