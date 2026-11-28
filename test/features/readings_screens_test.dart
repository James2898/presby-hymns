import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presby_hymns/core/theme/app_colors.dart';
import 'package:presby_hymns/data/database/app_database.dart';
import 'package:presby_hymns/features/readings/presentation/reading_detail_screen.dart';
import 'package:presby_hymns/features/readings/presentation/readings_list_screen.dart';
import 'package:presby_hymns/features/readings/providers/readings_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late int reading1Id;
  late int reading16Id;
  late int reading41Id;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());

    reading1Id = await db
        .into(db.responsiveReadings)
        .insert(
          ResponsiveReadingsCompanion.insert(
            language: 'TL',
            number: 1,
            title: 'Ang Daan Ng Buhay',
            sortTitle: 'ang daan ng buhay',
            scriptureReference: 'Awit 1:1-6',
          ),
        );
    await db
        .into(db.responsiveReadingLines)
        .insert(
          ResponsiveReadingLinesCompanion.insert(
            readingId: reading1Id,
            lineOrder: 1,
            role: 'leader',
            textContent:
                'Mapalad ang tao na hindi lumalakad sa payo ng masama,',
          ),
        );
    await db
        .into(db.responsiveReadingLines)
        .insert(
          ResponsiveReadingLinesCompanion.insert(
            readingId: reading1Id,
            lineOrder: 2,
            role: 'people',
            textContent: 'Ni tumatayo man sa daan ng mga makasalanan.',
          ),
        );
    await db
        .into(db.responsiveReadingLines)
        .insert(
          ResponsiveReadingLinesCompanion.insert(
            readingId: reading1Id,
            lineOrder: 3,
            role: 'all',
            textContent: 'Nguni’t ang lakad ng masama ay mapapahamak.',
          ),
        );
    // Add extra lines so Reading #1 is scrollable for scroll-reset test
    for (int i = 4; i <= 24; i++) {
      await db
          .into(db.responsiveReadingLines)
          .insert(
            ResponsiveReadingLinesCompanion.insert(
              readingId: reading1Id,
              lineOrder: i,
              role: i.isEven ? 'people' : 'leader',
              textContent:
                  'Karagdagang linya bilang $i ng tugunang pagbasa upang masubukan ang pag-scroll pababa.',
            ),
          );
    }

    // Reading #16: zero 'all' lines
    reading16Id = await db
        .into(db.responsiveReadings)
        .insert(
          ResponsiveReadingsCompanion.insert(
            language: 'TL',
            number: 16,
            title: 'Pagpupuri Sa Panginoon Sa Buong Buhay',
            sortTitle: 'pagpupuri sa panginoon sa buong buhay',
            scriptureReference: 'Awit 34:1-9',
          ),
        );
    await db
        .into(db.responsiveReadingLines)
        .insert(
          ResponsiveReadingLinesCompanion.insert(
            readingId: reading16Id,
            lineOrder: 1,
            role: 'leader',
            textContent: 'Aking pupurihin ang Panginoon sa lahat ng panahon.',
          ),
        );
    await db
        .into(db.responsiveReadingLines)
        .insert(
          ResponsiveReadingLinesCompanion.insert(
            readingId: reading16Id,
            lineOrder: 2,
            role: 'people',
            textContent: 'Ang pagpuri sa kaniya ay laging sasa aking bibig.',
          ),
        );

    // Reading #41: long multi-part reference
    reading41Id = await db
        .into(db.responsiveReadings)
        .insert(
          ResponsiveReadingsCompanion.insert(
            language: 'TL',
            number: 41,
            title: 'Mahahalagang Aralin Sa Buhay',
            sortTitle: 'mahahalagang aralin sa buhay',
            scriptureReference: '1 Pedro 1:24-25; Santiago 4:14; Galacia 6:10; Efeso 6:16; Colosas 3:13; Mateo 28:19-20',
          ),
        );
    await db
        .into(db.responsiveReadingLines)
        .insert(
          ResponsiveReadingLinesCompanion.insert(
            readingId: reading41Id,
            lineOrder: 1,
            role: 'leader',
            textContent:
                'Ang salita ng Panginoon ay namamalagi magpakailanman.',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('ReadingsListScreen (AC-17..AC-19, AM-4)', () {
    testWidgets(
      'lists sorted readings, filters by trimmed number/title, clears cleanly, and navigates to detail',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [appDatabaseProvider.overrideWithValue(db)],
            child: const MaterialApp(home: ReadingsListScreen()),
          ),
        );
        await tester.pumpAndSettle();

        // AppBar title and Back button (AC-17)
        expect(find.text('Tugunang Pagbasa'), findsOneWidget);
        expect(find.byTooltip('Back'), findsOneWidget);

        // All seeded readings shown with number, title, and scripture reference (AC-17)
        expect(find.text('NO.'), findsNothing);
        expect(find.byIcon(Icons.menu_book_outlined), findsNothing);
        expect(find.text('1'), findsOneWidget);
        expect(find.text('Ang Daan Ng Buhay'), findsOneWidget);
        expect(find.text('Awit 1:1-6'), findsOneWidget);
        expect(
          find.text('Pagpupuri Sa Panginoon Sa Buong Buhay'),
          findsOneWidget,
        );
        expect(find.text('Awit 34:1-9'), findsOneWidget);
        expect(find.text('Mahahalagang Aralin Sa Buhay'), findsOneWidget);
        expect(
          find.text(
            '1 Pedro 1:24-25; Santiago 4:14; Galacia 6:10; Efeso 6:16; Colosas 3:13; Mateo 28:19-20',
          ),
          findsOneWidget,
        );

        // Clear icon hidden initially
        expect(find.byTooltip('Clear search'), findsNothing);

        // Filter by trimmed number (AC-18)
        await tester.enterText(find.byType(TextField), '  16  ');
        await tester.pumpAndSettle();
        expect(
          find.text('Pagpupuri Sa Panginoon Sa Buong Buhay'),
          findsOneWidget,
        );
        expect(find.text('Ang Daan Ng Buhay'), findsNothing);
        expect(find.byTooltip('Clear search'), findsOneWidget);

        // Clear filter restores full list and hides clear button (AM-4)
        await tester.tap(find.byTooltip('Clear search'));
        await tester.pumpAndSettle();
        expect(find.text('Ang Daan Ng Buhay'), findsOneWidget);
        expect(find.text('Mahahalagang Aralin Sa Buhay'), findsOneWidget);
        expect(find.byTooltip('Clear search'), findsNothing);

        // Case-insensitive title substring filter (AC-18)
        await tester.enterText(find.byType(TextField), 'aralin');
        await tester.pumpAndSettle();
        expect(find.text('Mahahalagang Aralin Sa Buhay'), findsOneWidget);
        expect(find.text('Ang Daan Ng Buhay'), findsNothing);

        // Empty filter result state (AC-18)
        await tester.enterText(find.byType(TextField), 'walang-katulad-xyz');
        await tester.pumpAndSettle();
        expect(
          find.textContaining('No readings found matching'),
          findsOneWidget,
        );

        // Clear and tap Reading #1 to navigate to ReadingDetailScreen (AC-19)
        await tester.tap(find.byTooltip('Clear search'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ang Daan Ng Buhay'));
        await tester.pumpAndSettle();
        expect(find.byType(ReadingDetailScreen), findsOneWidget);
        expect(find.text('Tugunang Pagbasa Bilang 1'), findsOneWidget);
      },
    );

    testWidgets('shows empty state when database has 0 readings (AC-18)', (
      WidgetTester tester,
    ) async {
      await db.delete(db.responsiveReadingLines).go();
      await db.delete(db.responsiveReadings).go();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: const MaterialApp(home: ReadingsListScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('No responsive readings available.'), findsOneWidget);
    });

    testWidgets(
      'shows error feedback without crashing when readingsListProvider errors (AC-18)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              appDatabaseProvider.overrideWithValue(db),
              readingsListProvider.overrideWith(
                (ref) => Future<List<ResponsiveReading>>.error(
                  'Simulated DB failure',
                ),
              ),
            ],
            child: const MaterialApp(home: ReadingsListScreen()),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.textContaining('Failed to load readings'), findsOneWidget);
      },
    );
  });

  group('ReadingDetailScreen (AC-20..AC-25)', () {
    testWidgets(
      'renders Tagalog palette, role alignment/styles, zero music controls, text-size bounds & persistence, prev/next & scroll reset',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [appDatabaseProvider.overrideWithValue(db)],
            child: MaterialApp(
              home: ReadingDetailScreen(readingId: reading1Id),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tagalog palette background (AC-20)
        final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
        expect(scaffold.backgroundColor, equals(AppColors.canvasTl));

        // Header number, title, and reference (shown in header + after last line) (AC-20)
        expect(find.text('Tugunang Pagbasa Bilang 1'), findsOneWidget);
        expect(find.text('Ang Daan Ng Buhay'), findsOneWidget);
        expect(find.text('Awit 1:1-6'), findsNWidgets(2));

        // Role formatting: leader (Source Serif 4 bold, left), people (Inter normal, right, lighter gold), all (Space Grotesk bold+italic, center) (AC-21)
        final leaderText = tester.widget<Text>(
          find.text('Mapalad ang tao na hindi lumalakad sa payo ng masama,'),
        );
        expect(leaderText.textAlign, equals(TextAlign.left));
        expect(leaderText.style?.fontFamily, equals('Source Serif 4'));
        expect(leaderText.style?.fontWeight, equals(FontWeight.bold));
        expect(leaderText.style?.fontStyle, equals(FontStyle.normal));

        final peopleText = tester.widget<Text>(
          find.text('Ni tumatayo man sa daan ng mga makasalanan.'),
        );
        expect(peopleText.textAlign, equals(TextAlign.right));
        expect(peopleText.style?.fontFamily, equals('Inter'));
        expect(peopleText.style?.fontWeight, equals(FontWeight.normal));
        expect(peopleText.style?.fontStyle, equals(FontStyle.normal));
        expect(peopleText.style?.color, equals(AppColors.accentTextLight));

        final allText = tester.widget<Text>(
          find.text('Nguni’t ang lakad ng masama ay mapapahamak.'),
        );
        expect(allText.textAlign, equals(TextAlign.center));
        expect(allText.style?.fontFamily, equals('Space Grotesk'));
        expect(allText.style?.fontWeight, equals(FontWeight.bold));
        expect(allText.style?.fontStyle, equals(FontStyle.italic));

        // Zero music controls rendered (AC-22)
        expect(find.text('SONG CONTROLS'), findsNothing);
        expect(find.text('PITCH PIPE / TONIC CUE'), findsNothing);
        expect(find.text('CAPO'), findsNothing);
        expect(find.text('CAGED'), findsNothing);
        expect(find.text('Hide Chords'), findsNothing);

        // First reading disables Previous (AC-24)
        final prevAppBarBtn = tester.widget<IconButton>(
          find.ancestor(
            of: find.byTooltip('No Previous Reading'),
            matching: find.byType(IconButton),
          ),
        );
        expect(prevAppBarBtn.onPressed, isNull);
        final prevBottomBtn = tester.widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'First Reading'),
        );
        expect(prevBottomBtn.onPressed, isNull);

        // Text-size increase updates body font size (AC-23)
        final initialSize = leaderText.style!.fontSize!;
        await tester.tap(find.widgetWithText(OutlinedButton, 'A+'));
        await tester.pumpAndSettle();
        final enlargedLeader = tester.widget<Text>(
          find.text('Mapalad ang tao na hindi lumalakad sa payo ng masama,'),
        );
        expect(enlargedLeader.style!.fontSize, equals(initialSize + 1.0));

        // Scroll down before navigating to Next reading to test scroll reset (AC-24)
        final scrollableFinder = find.byType(SingleChildScrollView);
        await tester.drag(scrollableFinder, const Offset(0, -400));
        await tester.pumpAndSettle();
        final scrollView = tester.widget<SingleChildScrollView>(
          scrollableFinder,
        );
        expect(scrollView.controller!.offset, greaterThan(0.0));

        // Navigate Next to Reading #16 (no 'all' lines) (AC-21, AC-23, AC-24)
        await tester.tap(find.byTooltip('Next Reading (#16)'));
        await tester.pumpAndSettle();

        // Scroll reset to top (AC-24)
        expect(scrollView.controller!.offset, equals(0.0));

        // Reading #16 loaded cleanly with retained text size (AC-23)
        expect(find.text('Tugunang Pagbasa Bilang 16'), findsOneWidget);
        expect(
          find.text('Pagpupuri Sa Panginoon Sa Buong Buhay'),
          findsOneWidget,
        );
        final r16Leader = tester.widget<Text>(
          find.text('Aking pupurihin ang Panginoon sa lahat ng panahon.'),
        );
        expect(r16Leader.style!.fontSize, equals(initialSize + 1.0));

        // Navigate Next to last reading (#41): Next disabled, long reference renders without overflow (AC-20, AC-24)
        await tester.tap(find.byTooltip('Next Reading (#41)'));
        await tester.pumpAndSettle();
        expect(find.text('Tugunang Pagbasa Bilang 41'), findsOneWidget);
        expect(
          find.text(
            '1 Pedro 1:24-25; Santiago 4:14; Galacia 6:10; Efeso 6:16; Colosas 3:13; Mateo 28:19-20',
          ),
          findsNWidgets(2),
        );
        final nextAppBarBtn = tester.widget<IconButton>(
          find.ancestor(
            of: find.byTooltip('No Next Reading'),
            matching: find.byType(IconButton),
          ),
        );
        expect(nextAppBarBtn.onPressed, isNull);
        final nextBottomBtn = tester.widget<OutlinedButton>(
          find.widgetWithText(OutlinedButton, 'Last Reading'),
        );
        expect(nextBottomBtn.onPressed, isNull);
      },
    );

    testWidgets('disables A- at min size and A+ at max size (AC-23)', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({
        kReadingFontSizePrefKey: kReadingMinFontSize,
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: MaterialApp(home: ReadingDetailScreen(readingId: reading16Id)),
        ),
      );
      await tester.pumpAndSettle();

      final decreaseAtMin = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'A-'),
      );
      final increaseAtMin = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'A+'),
      );
      expect(decreaseAtMin.onPressed, isNull);
      expect(increaseAtMin.onPressed, isNotNull);

      // Jump to max size by tapping A+ (28 - 12 = 16 taps)
      for (int i = 0; i < 16; i++) {
        await tester.tap(find.widgetWithText(OutlinedButton, 'A+'));
        await tester.pump();
      }
      await tester.pumpAndSettle();

      final decreaseAtMax = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'A-'),
      );
      final increaseAtMax = tester.widget<OutlinedButton>(
        find.widgetWithText(OutlinedButton, 'A+'),
      );
      expect(decreaseAtMax.onPressed, isNotNull);
      expect(increaseAtMax.onPressed, isNull);
    });

    testWidgets(
      'displays graceful not-found fallback for missing reading ID (AC-25)',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [appDatabaseProvider.overrideWithValue(db)],
            child: const MaterialApp(
              home: ReadingDetailScreen(readingId: 99999),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Reading Not Found'), findsOneWidget);
        expect(
          find.text('This reading does not exist in the database.'),
          findsOneWidget,
        );
        expect(find.byTooltip('Back'), findsOneWidget);
      },
    );
  });
}
