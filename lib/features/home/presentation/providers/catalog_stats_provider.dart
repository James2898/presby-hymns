import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:presby_hymns/data/database/app_database.dart';
import '../../data/home_repository.dart';
import '../../domain/models/catalog_stats.dart';



final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return HomeRepository(db);
});

final catalogStatsProvider = FutureProvider<CatalogStats>((ref) async {
  final repo = ref.watch(homeRepositoryProvider);
  return repo.getCatalogStats();
});
