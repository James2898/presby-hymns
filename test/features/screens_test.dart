import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presby_hymns/data/database/app_database.dart';
import 'package:presby_hymns/features/home/presentation/home_screen.dart';
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

    // Seed Hymn #2 (for next/prev navigation testing)
    await db.into(db.hymns).insert(
          HymnsCompanion.insert(
            id: const Value(3),
            hymnNumber: const Value(2),
            tuneName: const Value('ST ANNE'),
            meter: const Value('C.M.'),
            originalKey: 'C',
          ),
        );

    await db.into(db.hymnTexts).insert(
          HymnTextsCompanion.insert(
            hymnId: 3,
            language: 'EN',
            title: 'O God, Our Help in Ages Past',
            sortTitle: 'O GOD OUR HELP IN AGES PAST',
            verseCount: 2,
            hasChords: 1,
            chordproBody: '{title: O God Our Help}\n{key: C}\n[C]O God, our help in ages past\n',
            lyricsText: 'O God, our help in ages past\n',
            firstLine: 'O God, our help in ages past',
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
    // Badges removed per user feedback (Item 6)
    expect(find.text('Chords & Capo'), findsNothing);
    expect(find.text('May Chords & Liriko'), findsNothing);
  });

  testWidgets('Index Screen supports All/English/Tagalog filter tabs and sort toggle without sort label (AC-6, AC-7, AC-8, AC-10)',
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

    // "Sorted by ..." label removed per user feedback (Item 5)
    expect(find.textContaining('Sorted by'), findsNothing);

    // Leading back button exists on IndexScreen (Item 1)
    expect(find.byTooltip('Back'), findsOneWidget);

    // ENG | TGL badge removed per user feedback (Item 4)
    expect(find.text('ENG | TGL'), findsNothing);

    // In Number sort (default), unnumbered section exists (AC-10)
    await tester.pumpAndSettle();
    expect(find.text('UNNUMBERED SONGS'), findsOneWidget);
    expect(find.text('Doxology'), findsOneWidget);
  });

  testWidgets('Hymn Reader Screen displays header, controls toolbar, ChordPro lyrics, and adjacent navigation (AC-11, AC-13, AC-14, AC-15)',
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

    // AC-11 Language toggle (without icons)
    expect(find.text('English'), findsOneWidget);
    expect(find.text('Tagalog'), findsOneWidget);
    expect(find.byIcon(Icons.menu_book), findsNothing);
    expect(find.byIcon(Icons.translate), findsNothing);

    // AC-13 Synchronized ChordPro layout
    expect(find.text('Holy, Holy, Holy! Lord God Almighty!'), findsOneWidget);
    expect(find.text('D'), findsWidgets);

    // AC-14 Controls summary
    expect(find.textContaining('Capo 0'), findsOneWidget);

    // AC-15 Bottom Pitch Cue Drawer (collapsed/hidden by default, non-floating)
    expect(find.text('PITCH PIPE / TONIC CUE'), findsOneWidget);
    expect(find.text('Key D • 2s tone'), findsOneWidget);
    expect(find.text('♪ D Cue'), findsNothing);

    // Expand the Pitch Pipe / Tonic Cue drawer and verify body appears
    await tester.tap(find.text('PITCH PIPE / TONIC CUE'));
    await tester.pumpAndSettle();
    expect(find.text('♪ D Cue'), findsOneWidget);

    // Collapse the Pitch Pipe / Tonic Cue drawer again
    await tester.tap(find.text('PITCH PIPE / TONIC CUE'));
    await tester.pumpAndSettle();
    expect(find.text('♪ D Cue'), findsNothing);

    // Previous and Next Hymn Navigation (Item 2)
    await tester.pumpAndSettle();
    expect(find.text('Hymn #2'), findsWidgets);

    // Tap Next Hymn button to navigate to Hymn #2
    final nextBtn = find.widgetWithText(OutlinedButton, 'Hymn #2');
    expect(nextBtn, findsOneWidget);
    await tester.ensureVisible(nextBtn);
    await tester.pumpAndSettle();
    await tester.tap(nextBtn);
    await tester.pumpAndSettle();

    // Now reader displays Hymn #2
    expect(find.text('O God, Our Help in Ages Past'), findsOneWidget);
    expect(find.text('Hymn #1'), findsWidgets); // Can navigate back to Hymn #1

    // Expand SONG CONTROLS to reveal advanced formatting buttons
    await tester.tap(find.text('SONG CONTROLS'));
    await tester.pumpAndSettle();

    // Text Alignment controls in SongControlsToolbar
    expect(find.byIcon(Icons.format_align_left), findsOneWidget);
    expect(find.byIcon(Icons.format_align_center), findsOneWidget);
    expect(find.byIcon(Icons.format_align_right), findsOneWidget);
    expect(find.byIcon(Icons.format_align_justify), findsOneWidget);
  });

  testWidgets('Reader Screen allows key transposition and shows key indicator for hymns without chords',
      (WidgetTester tester) async {
    // Seed Hymn #4: Lyrics-only Tagalog hymn without chords (hasChords = 0)
    await db.into(db.hymns).insert(
          HymnsCompanion.insert(
            id: const Value(4),
            hymnNumber: const Value(4),
            tuneName: const Value('AMAZING GRACE'),
            meter: const Value('C.M.'),
            originalKey: 'G',
          ),
        );

    await db.into(db.hymnTexts).insert(
          HymnTextsCompanion.insert(
            hymnId: 4,
            language: 'TL',
            title: 'Dakilang Biyaya',
            sortTitle: 'DAKILANG BIYAYA',
            verseCount: 3,
            hasChords: 0,
            chordproBody: '{title: Dakilang Biyaya}\n{key: G}\nDakilang biyaya, kay tamis ng tunog\n',
            lyricsText: 'Dakilang biyaya, kay tamis ng tunog\n',
            firstLine: 'Dakilang biyaya, kay tamis ng tunog',
          ),
        );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reader.databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: ReaderScreen(hymnId: 4, initialLanguage: 'TL'),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Summary displays Key and Text Size without Capo
    expect(find.textContaining('Key G • Text Size'), findsOneWidget);
    expect(find.textContaining('Capo'), findsNothing);

    // Bottom pitch cue drawer is collapsed by default and shows summary key
    expect(find.text('Key G • 2s tone'), findsOneWidget);
    expect(find.text('♪ G Cue'), findsNothing);

    // Expand bottom pitch cue drawer to see cue button
    await tester.tap(find.text('PITCH PIPE / TONIC CUE'));
    await tester.pumpAndSettle();
    expect(find.text('♪ G Cue'), findsOneWidget);

    // Expand SONG CONTROLS
    await tester.tap(find.text('SONG CONTROLS'));
    await tester.pumpAndSettle();

    // Universal KEY row is visible even though hasChords == 0
    expect(find.text('KEY'), findsOneWidget);
    expect(find.text('-1'), findsOneWidget);
    expect(find.text('+1'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);

    // Capo, CAGED, and Hide Chords are NOT visible
    expect(find.text('CAPO'), findsNothing);
    expect(find.text('CAGED'), findsNothing);
    expect(find.text('Hide Chords'), findsNothing);

    // Tap '+1' to transpose from G to G# (sharpKey)
    await tester.tap(find.text('+1'));
    await tester.pumpAndSettle();

    // Key indicator in toolbar updates to G#
    expect(find.text('G#'), findsWidgets);
    // Bottom pitch cue updates to G# Cue
    expect(find.text('♪ G# Cue'), findsOneWidget);
  });
}
