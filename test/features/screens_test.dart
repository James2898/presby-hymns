import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presby_hymns/data/database/app_database.dart';
import 'package:presby_hymns/features/home/presentation/home_screen.dart';
import 'package:presby_hymns/features/home/presentation/providers/catalog_stats_provider.dart';
import 'package:presby_hymns/features/index/index_screen.dart';
import 'package:presby_hymns/features/index/providers/index_provider.dart';
import 'package:presby_hymns/features/reader/reader_screen.dart';
import 'package:presby_hymns/features/reader/providers/reader_providers.dart' as reader;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());

    // Seed test hymn
    await db.into(db.hymns).insert(
          HymnsCompanion.insert(
            id: const Value(1),
            hymnNumber: const Value(1),
            tuneName: const Value('NICAEA'),
            meter: const Value('11.12.12.10'),
            originalKey: 'D',
          ),
        );

    await db.into(db.hymnTexts).insert(
          HymnTextsCompanion.insert(
            hymnId: 1,
            language: 'EN',
            title: 'Holy, Holy, Holy! Lord God Almighty!',
            sortTitle: 'HOLY HOLY HOLY LORD GOD ALMIGHTY',
            author: const Value('Reginald Heber'),
            year: const Value('1826'),
            verseCount: 4,
            hasChords: 1,
            chordproBody: '{title: Holy, Holy, Holy}\n{key: D}\n[D]Holy, [Bm]Holy, [A]Holy!\n',
            lyricsText: 'Holy, Holy, Holy!\n',
            firstLine: 'Holy, Holy, Holy! Lord God Almighty!',
          ),
        );

    await db.into(db.hymnTexts).insert(
          HymnTextsCompanion.insert(
            hymnId: 1,
            language: 'TL',
            title: 'Banal, Banal, Banal! Makapangyarihan!',
            sortTitle: 'BANAL BANAL BANAL MAKAPANGYARIHAN',
            author: const Value('Reginald Heber'),
            year: const Value('1826'),
            verseCount: 4,
            hasChords: 1,
            chordproBody: '{title: Banal, Banal, Banal}\n{key: D}\n[D]Banal, [Bm]Banal, [A]Banal!\n',
            lyricsText: 'Banal, Banal, Banal!\n',
            firstLine: 'Banal, Banal, Banal! Makapangyarihan!',
          ),
        );

    // Seed unnumbered song (AC-10)
    await db.into(db.hymns).insert(
          HymnsCompanion.insert(
            id: const Value(2),
            hymnNumber: const Value.absent(),
            tuneName: const Value('OLD HUNDREDTH'),
            meter: const Value('L.M.'),
            originalKey: 'G',
          ),
        );

    await db.into(db.hymnTexts).insert(
          HymnTextsCompanion.insert(
            hymnId: 2,
            language: 'EN',
            title: 'Doxology',
            sortTitle: 'DOXOLOGY',
            verseCount: 1,
            hasChords: 1,
            chordproBody: '{title: Doxology}\n{key: G}\n[G]Praise God from whom all blessings flow\n',
            lyricsText: 'Praise God from whom all blessings flow\n',
            firstLine: 'Praise God from whom all blessings flow',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('Home Screen displays Presbyterian hero banner and catalog cards (AC-1, AC-5)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Presbyterian hero banner
    expect(find.text('Presbyterian Hymns'), findsWidgets);
    // Catalog cards
    expect(find.text('English Hymnal'), findsOneWidget);
    expect(find.text('Tagalog Himnaryo'), findsOneWidget);
  });

  testWidgets('Index Screen supports All/English/Tagalog filter tabs and sort toggle (AC-6, AC-7, AC-8, AC-10)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: IndexScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // AC-6 Filter tabs exist
    expect(find.text('All Hymns'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Tagalog'), findsOneWidget);

    // AC-7 Sort toggle exists
    expect(find.text('Number'), findsOneWidget);
    expect(find.text('Title'), findsOneWidget);

    // In Number sort (default), unnumbered section exists (AC-10)
    await tester.pumpAndSettle();
    expect(find.text('UNNUMBERED SONGS'), findsOneWidget);
    expect(find.text('Doxology'), findsOneWidget);
  });

  testWidgets('Hymn Reader Screen displays header, controls toolbar, ChordPro lyrics (AC-11, AC-13, AC-14, AC-15)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reader.databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: ReaderScreen(hymnId: 1, initialLanguage: 'EN'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // AC-11 Language toggle
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Tagalog'), findsOneWidget);

    // AC-13 Synchronized ChordPro layout
    expect(find.text('Holy, Holy, Holy! Lord God Almighty!'), findsOneWidget);
    expect(find.text('D'), findsWidgets);

    // AC-14 Controls summary
    expect(find.textContaining('Capo 0'), findsOneWidget);

    // AC-15 Bottom Pitch Cue
    expect(find.text('♪ D Cue'), findsOneWidget);
  });
}
