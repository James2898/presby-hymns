import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int kAppDbVersion = 3;
const String kDbVersionPrefKey = 'app_db_content_version';

QueryExecutor openAppDatabaseConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'hymns.db'));

    final prefs = await SharedPreferences.getInstance();
    final storedVersion = prefs.getInt(kDbVersionPrefKey);

    final needsCopy = !await file.exists() ||
        storedVersion == null ||
        storedVersion < kAppDbVersion;

    // Copy from bundled asset if not exists or updating
    if (needsCopy) {
      final blob = await rootBundle.load('assets/db/hymns.db');
      final buffer = blob.buffer;
      await file.writeAsBytes(
        buffer.asUint8List(blob.offsetInBytes, blob.lengthInBytes),
        flush: true,
      );
      await prefs.setInt(kDbVersionPrefKey, kAppDbVersion);
    }
    return NativeDatabase.createInBackground(file);
  });
}
