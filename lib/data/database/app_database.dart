import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart' show rootBundle;

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
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'hymns.db'));

      // Copy from bundled asset if not exists or updating
      if (!await file.exists()) {
        final blob = await rootBundle.load('assets/db/hymns.db');
        final buffer = blob.buffer;
        await file.writeAsBytes(
          buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
          flush: true,
        );
      }
      return NativeDatabase.createInBackground(file);
    });
  }
}
