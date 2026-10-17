import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/index/index_screen.dart';
import 'features/index/providers/index_provider.dart';
import 'features/reader/reader_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: PresbyHymnsApp()));
}

class PresbyHymnsApp extends StatelessWidget {
  const PresbyHymnsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presbyterian Hymns',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF004AAD),
          primary: const Color(0xFF004AAD),
          surface: const Color(0xFFF9F9FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00357F),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const HomeNavigationHost(),
    );
  }
}

class HomeNavigationHost extends ConsumerWidget {
  const HomeNavigationHost({super.key});

  void _openReader(BuildContext context, int hymnId, String language) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          hymnId: hymnId,
          initialLanguage: language,
        ),
      ),
    );
  }

  void _openIndex(BuildContext context, WidgetRef ref, String language) {
    if (language.toUpperCase() == 'TL') {
      ref.read(indexTabProvider.notifier).state = IndexTab.tagalog;
    } else if (language.toUpperCase() == 'EN') {
      ref.read(indexTabProvider.notifier).state = IndexTab.english;
    } else {
      ref.read(indexTabProvider.notifier).state = IndexTab.all;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IndexScreen(
          onHymnSelected: (hymnId, lang) {
            _openReader(context, hymnId, lang);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeScreen(
      onHymnSelected: (hymnId, number, language) {
        _openReader(context, hymnId, language);
      },
      onBrowseCatalog: (language) {
        _openIndex(context, ref, language);
      },
    );
  }
}
