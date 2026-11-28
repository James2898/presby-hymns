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

@DriftDatabase(tables: [Hymns, HymnTexts])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? openAppDatabaseConnection());

  @override
  int get schemaVersion => 1;
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
