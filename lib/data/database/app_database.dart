import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connection/connection_native.dart'
    if (dart.library.js_interop) 'connection/connection_web.dart';

part 'app_database.g.dart';

class Hymns extends Table {
  IntColumn get id => integer()();
  IntColumn get hymnNumber => integer().nullable().unique()();
  TextColumn get tuneName => text().nullable()();
  TextColumn get meter => text().nullable()();
  TextColumn get originalKey => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class HymnTexts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get hymnId => integer().references(Hymns, #id)();
  TextColumn get language => text()();
  TextColumn get title => text()();
  TextColumn get sortTitle => text()();
  TextColumn get author => text().nullable()();
  TextColumn get translator => text().nullable()();
  TextColumn get year => text().nullable()();
  IntColumn get verseCount => integer()();
  IntColumn get hasChords => integer()();
  TextColumn get chordproBody => text()();
  TextColumn get lyricsText => text()();
  TextColumn get firstLine => text()();
}

class ResponsiveReadings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get language => text()();
  IntColumn get number => integer()();
  TextColumn get title => text()();
  TextColumn get sortTitle => text()();
  TextColumn get scriptureReference => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {language, number},
  ];
}

class ResponsiveReadingLines extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get readingId => integer().references(ResponsiveReadings, #id)();
  IntColumn get lineOrder => integer()();
  TextColumn get role => text()();
  TextColumn get textContent => text().named('text')();

  @override
  List<Set<Column>> get uniqueKeys => [
    {readingId, lineOrder},
  ];
}

@DriftDatabase(
  tables: [Hymns, HymnTexts, ResponsiveReadings, ResponsiveReadingLines],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? openAppDatabaseConnection());

  @override
  int get schemaVersion => 2;
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
