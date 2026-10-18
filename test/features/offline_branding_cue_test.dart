import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:presby_hymns/features/home/presentation/widgets/hero_banner.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Offline Branding, Fonts & Cue Tones Verification', () {
    test(
      'Launcher icons are generated across all mipmap densities (AC-2, AC-3)',
      () {
        final densities = ['mdpi', 'hdpi', 'xhdpi', 'xxhdpi', 'xxxhdpi'];
        for (final density in densities) {
          final squareIcon = File(
            'android/app/src/main/res/mipmap-$density/ic_launcher.png',
          );
          final roundIcon = File(
            'android/app/src/main/res/mipmap-$density/ic_launcher_round.png',
          );
          expect(
            squareIcon.existsSync(),
            isTrue,
            reason: 'mipmap-$density/ic_launcher.png must exist',
          );
          expect(
            roundIcon.existsSync(),
            isTrue,
            reason: 'mipmap-$density/ic_launcher_round.png must exist',
          );
          expect(squareIcon.lengthSync(), greaterThan(0));
          expect(roundIcon.lengthSync(), greaterThan(0));
        }

        // Adaptive icon XMLs
        expect(
          File('android/app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml')
              .existsSync(),
          isTrue,
        );
        expect(
          File(
            'android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml',
          ).existsSync(),
          isTrue,
        );
        expect(
          File('android/app/src/main/res/drawable/ic_launcher_foreground.xml')
              .existsSync(),
          isTrue,
        );
        expect(
          File('android/app/src/main/res/values/colors.xml').existsSync(),
          isTrue,
        );
      },
    );

    test(
      'Offline TTF fonts are physically present in assets/fonts/ (AC-5)',
      () {
        final requiredFonts = [
          'SpaceGrotesk-Regular.ttf',
          'SpaceGrotesk-Medium.ttf',
          'SpaceGrotesk-Bold.ttf',
          'SourceSerif4-Regular.ttf',
          'SourceSerif4-Italic.ttf',
          'SourceSerif4-Medium.ttf',
          'SourceSerif4-Bold.ttf',
          'Inter-Regular.ttf',
          'Inter-Italic.ttf',
          'Inter-Medium.ttf',
          'Inter-Bold.ttf',
        ];

        for (final fontName in requiredFonts) {
          final fontFile = File('assets/fonts/$fontName');
          expect(
            fontFile.existsSync(),
            isTrue,
            reason: 'Font $fontName must be present',
          );
          expect(
            fontFile.lengthSync(),
            greaterThan(50000),
            reason: 'Font $fontName must be a valid font binary',
          );
        }
      },
    );

    test('12 chromatic equal-temperament OGG cue tones exist in assets/audio/cue/ (AC-10, AC-11)', () {
      final pitches = [
        'C4',
        'Db4',
        'D4',
        'Eb4',
        'E4',
        'F4',
        'F#4',
        'G4',
        'Ab4',
        'A4',
        'Bb4',
        'B4',
      ];
      for (final pitch in pitches) {
        final cueFile = File('assets/audio/cue/$pitch.ogg');
        expect(
          cueFile.existsSync(),
          isTrue,
          reason: 'Cue audio file for $pitch must exist',
        );
        expect(
          cueFile.lengthSync(),
          greaterThan(1000),
          reason: 'Cue file $pitch must have audio content',
        );
      }
    });

    test('build/content-report.md records PASS validation status (AC-20)', () {
      final reportFile = File('build/content-report.md');
      if (!reportFile.existsSync()) {
        final res = Process.runSync(Platform.resolvedExecutable, [
          'run',
          'tool/build_content.dart',
        ]);
        expect(res.exitCode, equals(0), reason: 'build_content.dart must succeed: ${res.stderr}');
      }
      expect(
        reportFile.existsSync(),
        isTrue,
        reason: 'build/content-report.md must exist',
      );
      final content = reportFile.readAsStringSync();
      expect(content.contains('Validation Status:** **PASS**'), isTrue);
      expect(content.contains('Total Unique Hymns:** 173'), isTrue);
    });

    testWidgets('HeroBanner renders Draft 1 branding logo asset (AC-4)', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: HeroBanner())),
      );
      await tester.pump();

      expect(find.text('PRESBYTERIAN HYMNS'), findsOneWidget);
      expect(find.text('BILINGUAL HYMNAL & CHORDS'), findsOneWidget);
      // HeroBanner contains Image widget loading the app_logo asset
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final Image imageWidget = tester.widget(imageFinder);
      expect(
        (imageWidget.image as AssetImage).assetName,
        equals('assets/images/app_logo.png'),
      );
    });
  });
}
