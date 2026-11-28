import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presby_hymns/data/database/app_database.dart';
import 'package:presby_hymns/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets(
    'App root launches and displays HomeScreen with redesigned catalog cards',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [appDatabaseProvider.overrideWithValue(db)],
          child: const PresbyHymnsApp(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Presbyterian Hymns'), findsWidgets);
      expect(find.byTooltip('Hymn Index'), findsNothing);
      expect(find.text('Hymns'), findsOneWidget);
      expect(find.text('Tugunang Pagbasa'), findsOneWidget);
      expect(find.text('Tingnan ang mga Pagbasa'), findsOneWidget);
      expect(find.text('Westminster Shorter Catechism'), findsOneWidget);
      expect(find.text('Coming soon'), findsOneWidget);
      expect(find.text('English Hymnal'), findsNothing);
      expect(find.text('Tagalog Himnaryo'), findsNothing);
    },
  );
}
