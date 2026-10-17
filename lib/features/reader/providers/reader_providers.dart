import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:presby_hymns/core/chordpro/chordpro_parser.dart';
import 'package:presby_hymns/core/music/key_speller.dart';
import 'package:presby_hymns/data/database/app_database.dart';
import 'package:presby_hymns/features/reader/models/reader_models.dart';

/// App Database Provider
final databaseProvider = appDatabaseProvider;

/// Shared Preferences Provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Hymn Reader Data Provider (Family: hymnId, language)
final readerDataProvider = FutureProvider.family<ReaderHymnData?, ({int hymnId, String lang})>((ref, arg) async {
  final db = ref.watch(databaseProvider);

  final hymn = await (db.select(db.hymns)..where((tbl) => tbl.id.equals(arg.hymnId))).getSingleOrNull();
  if (hymn == null) return null;

  final allTexts = await (db.select(db.hymnTexts)..where((tbl) => tbl.hymnId.equals(arg.hymnId))).get();
  final currentText = allTexts.where((t) => t.language.toUpperCase() == arg.lang.toUpperCase()).firstOrNull;

  final hasEn = allTexts.any((t) => t.language.toUpperCase() == 'EN');
  final hasTl = allTexts.any((t) => t.language.toUpperCase() == 'TL');

  if (currentText == null) {
    return ReaderHymnData(
      hymn: hymn,
      currentText: HymnText(
        id: -1,
        hymnId: hymn.id,
        language: arg.lang,
        title: 'Untitled',
        sortTitle: '',
        verseCount: 0,
        hasChords: 0,
        chordproBody: '',
        lyricsText: '',
        firstLine: '',
      ),
      songDoc: const SongDoc(title: '', key: 'C', sections: []),
      hasEnglishCounterpart: hasEn,
      hasTagalogCounterpart: hasTl,
    );
  }

  final doc = ChordProParser.parse(currentText.chordproBody);

  return ReaderHymnData(
    hymn: hymn,
    currentText: currentText,
    songDoc: doc,
    hasEnglishCounterpart: hasEn,
    hasTagalogCounterpart: hasTl,
  );
});

/// Per-hymn & global preferences provider
class ReaderPreferencesNotifier extends StateNotifier<ReaderPreferences> {
  final int hymnId;
  final String originalKey;
  final SharedPreferences? _prefs;

  ReaderPreferencesNotifier({
    required this.hymnId,
    required this.originalKey,
    SharedPreferences? prefs,
  })  : _prefs = prefs,
        super(ReaderPreferences(
          soundingKey: prefs?.getString('hymn.$hymnId.key') ?? originalKey,
          capo: prefs?.getInt('hymn.$hymnId.capo') ?? 0,
          fontSize: prefs?.getDouble('settings.fontSize') ?? 19.0,
          lineSpacing: prefs?.getDouble('settings.lineSpacing') ?? 1.5,
          textAlign: _parseAlign(prefs?.getString('settings.textAlign')),
          hideChords: prefs?.getBool('settings.hideChords') ?? false,
        ));

  static ReaderTextAlign _parseAlign(String? name) {
    return ReaderTextAlign.values.firstWhere(
      (e) => e.name == name,
      orElse: () => ReaderTextAlign.left,
    );
  }

  Future<void> setSoundingKey(String key) async {
    state = state.copyWith(soundingKey: key);
    await _prefs?.setString('hymn.$hymnId.key', key);
  }

  Future<void> transpose(int semitoneStep) async {
    final isMinor = state.soundingKey.endsWith('m');
    final rootOnly = state.soundingKey.replaceAll('m', '');
    final currentPitch = KeySpeller.pitchOf(rootOnly);
    if (currentPitch == -1) return;

    final newPitch = (currentPitch + semitoneStep + 12) % 12;
    final newKeyName = KeySpeller.spellPitch(newPitch, state.soundingKey);
    final fullNewKey = isMinor ? '${newKeyName}m' : newKeyName;

    await setSoundingKey(fullNewKey);
  }

  Future<void> setCapo(int capo) async {
    final clamped = capo.clamp(0, 7);
    state = state.copyWith(capo: clamped);
    await _prefs?.setInt('hymn.$hymnId.capo', clamped);
  }

  Future<void> setCagedShape(String shape) async {
    final fret = CapoResolver.capoFor(state.soundingKey, shape);
    if (fret != null && fret <= 7) {
      await setCapo(fret);
    }
  }

  Future<void> resetKeyAndCapo() async {
    state = state.copyWith(soundingKey: originalKey, capo: 0);
    await _prefs?.setString('hymn.$hymnId.key', originalKey);
    await _prefs?.setInt('hymn.$hymnId.capo', 0);
  }

  Future<void> adjustFontSize(double delta) async {
    final newSize = (state.fontSize + delta).clamp(12.0, 28.0);
    state = state.copyWith(fontSize: newSize);
    await _prefs?.setDouble('settings.fontSize', newSize);
  }

  Future<void> adjustLineSpacing(double delta) async {
    final newSpacing = ((state.lineSpacing + delta) * 10).round() / 10;
    final clamped = newSpacing.clamp(1.0, 2.5);
    state = state.copyWith(lineSpacing: clamped);
    await _prefs?.setDouble('settings.lineSpacing', clamped);
  }

  Future<void> setTextAlign(ReaderTextAlign align) async {
    state = state.copyWith(textAlign: align);
    await _prefs?.setString('settings.textAlign', align.name);
  }

  Future<void> toggleHideChords() async {
    final newVal = !state.hideChords;
    state = state.copyWith(hideChords: newVal);
    await _prefs?.setBool('settings.hideChords', newVal);
  }
}

typedef AdjacentHymns = ({Hymn? previous, Hymn? next});

/// Adjacent Numbered Hymns Provider
final adjacentHymnsProvider = FutureProvider.family<AdjacentHymns, int?>((ref, hymnNumber) async {
  if (hymnNumber == null) {
    return (previous: null, next: null);
  }
  final db = ref.watch(databaseProvider);

  // Previous hymn with hymn_number < current, ordered desc limit 1
  final prev = await (db.select(db.hymns)
        ..where((tbl) => tbl.hymnNumber.isNotNull() & tbl.hymnNumber.isSmallerThan(Variable(hymnNumber)))
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.hymnNumber, mode: OrderingMode.desc)])
        ..limit(1))
      .getSingleOrNull();

  // Next hymn with hymn_number > current, ordered asc limit 1
  final next = await (db.select(db.hymns)
        ..where((tbl) => tbl.hymnNumber.isNotNull() & tbl.hymnNumber.isBiggerThan(Variable(hymnNumber)))
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.hymnNumber, mode: OrderingMode.asc)])
        ..limit(1))
      .getSingleOrNull();

  return (previous: prev, next: next);
});

final readerPreferencesProvider = StateNotifierProvider.family<ReaderPreferencesNotifier, ReaderPreferences, ({int hymnId, String originalKey})>((ref, arg) {
  final prefsAsync = ref.watch(sharedPreferencesProvider);
  final prefs = prefsAsync.value;
  return ReaderPreferencesNotifier(
    hymnId: arg.hymnId,
    originalKey: arg.originalKey,
    prefs: prefs,
  );
});

/// Ephemeral Cue Key Provider (Auto-disposed with reader)
class CueKeyNotifier extends StateNotifier<String?> {
  CueKeyNotifier() : super(null);

  void setCueKey(String key) => state = key;
  void reset() => state = null;
}

final cueKeyProvider = StateNotifierProvider.autoDispose<CueKeyNotifier, String?>((ref) {
  return CueKeyNotifier();
});