import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqlite3/wasm.dart';

QueryExecutor openAppDatabaseConnection() {
  return LazyDatabase(() async {
    final sqlite3 = await WasmSqlite3.loadFromUrl(Uri.parse('sqlite3.wasm'));
    final vfs = InMemoryFileSystem();
    final blob = await rootBundle.load('assets/db/hymns.db');
    final bytes = blob.buffer.asUint8List(
      blob.offsetInBytes,
      blob.lengthInBytes,
    );

    final opened = vfs.xOpen(
      Sqlite3Filename('/hymns.db'),
      SqlFlag.SQLITE_OPEN_READWRITE | SqlFlag.SQLITE_OPEN_CREATE,
    );
    opened.file.xWrite(bytes, 0);
    opened.file.xClose();

    sqlite3.registerVirtualFileSystem(vfs, makeDefault: true);
    return WasmDatabase(
      sqlite3: sqlite3,
      path: '/hymns.db',
      enableMigrations: false,
    );
  });
}
