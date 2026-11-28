import 'package:drift/drift.dart';
import 'package:presby_hymns/data/database/app_database.dart';

import '../models/reading_models.dart';

class ReadingsRepository {
  final AppDatabase _db;

  ReadingsRepository(this._db);

  Future<List<ResponsiveReading>> getReadings({String language = 'TL'}) {
    return (_db.select(_db.responsiveReadings)
          ..where((tbl) => tbl.language.equals(language))
          ..orderBy([
            (tbl) =>
                OrderingTerm(expression: tbl.number, mode: OrderingMode.asc),
          ]))
        .get();
  }

  Future<ResponsiveReadingDetail?> getReadingById(int readingId) async {
    final reading = await (_db.select(
      _db.responsiveReadings,
    )..where((tbl) => tbl.id.equals(readingId))).getSingleOrNull();
    if (reading == null) return null;

    final lines =
        await (_db.select(_db.responsiveReadingLines)
              ..where((tbl) => tbl.readingId.equals(reading.id))
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.lineOrder,
                  mode: OrderingMode.asc,
                ),
              ]))
            .get();

    return ResponsiveReadingDetail(reading: reading, lines: lines);
  }

  Future<AdjacentReadings> getAdjacentReadings(
    int currentNumber, {
    String language = 'TL',
  }) async {
    final prev =
        await (_db.select(_db.responsiveReadings)
              ..where(
                (tbl) =>
                    tbl.language.equals(language) &
                    tbl.number.isSmallerThan(Variable(currentNumber)),
              )
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.number,
                  mode: OrderingMode.desc,
                ),
              ])
              ..limit(1))
            .getSingleOrNull();

    final next =
        await (_db.select(_db.responsiveReadings)
              ..where(
                (tbl) =>
                    tbl.language.equals(language) &
                    tbl.number.isBiggerThan(Variable(currentNumber)),
              )
              ..orderBy([
                (tbl) => OrderingTerm(
                  expression: tbl.number,
                  mode: OrderingMode.asc,
                ),
              ])
              ..limit(1))
            .getSingleOrNull();

    return (previous: prev, next: next);
  }
}
