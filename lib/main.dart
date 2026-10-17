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
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends ConsumerStatefulWidget {
  const MainNavigationShell({super.key});

  @override
  ConsumerState<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends ConsumerState<MainNavigationShell> {
  int _currentIndex = 0;

  void _openReader(int hymnId, String language) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ReaderScreen(
          hymnId: hymnId,
          initialLanguage: language,
        ),
      ),
    );
  }

  void _navigateToCatalog(String language) {
    if (language.toUpperCase() == 'TL') {
      ref.read(indexTabProvider.notifier).state = IndexTab.tagalog;
    } else {
      ref.read(indexTabProvider.notifier).state = IndexTab.english;
    }
    setState(() {
      _currentIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onHymnSelected: (hymnId, number, language) {
              _openReader(hymnId, language);
            },
            onBrowseCatalog: (language) {
              _navigateToCatalog(language);
            },
          ),
          IndexScreen(
            onHymnSelected: (hymnId, language) {
              _openReader(hymnId, language);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Index',
          ),
        ],
      ),
    );
  }
}
