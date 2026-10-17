import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presby_hymns/data/database/app_database.dart';
import 'package:presby_hymns/features/home/presentation/providers/catalog_stats_provider.dart';
import 'package:presby_hymns/features/index/providers/index_provider.dart';
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

  testWidgets('App root launches and displays navigation shell and Presbyterian Hymns',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
        ],
        child: const PresbyHymnsApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Presbyterian Hymns'), findsWidgets);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Index'), findsOneWidget);
  });
}
