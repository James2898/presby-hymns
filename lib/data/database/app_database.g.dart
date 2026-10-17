// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HymnsTable extends Hymns with TableInfo<$HymnsTable, Hymn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HymnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hymnNumberMeta = const VerificationMeta(
    'hymnNumber',
  );
  @override
  late final GeneratedColumn<int> hymnNumber = GeneratedColumn<int>(
    'hymn_number',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _tuneNameMeta = const VerificationMeta(
    'tuneName',
  );
  @override
  late final GeneratedColumn<String> tuneName = GeneratedColumn<String>(
    'tune_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meterMeta = const VerificationMeta('meter');
  @override
  late final GeneratedColumn<String> meter = GeneratedColumn<String>(
    'meter',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _originalKeyMeta = const VerificationMeta(
    'originalKey',
  );
  @override
  late final GeneratedColumn<String> originalKey = GeneratedColumn<String>(
    'original_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hymnNumber,
    tuneName,
    meter,
    originalKey,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hymns';
  @override
  VerificationContext validateIntegrity(
    Insertable<Hymn> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hymn_number')) {
      context.handle(
        _hymnNumberMeta,
        hymnNumber.isAcceptableOrUnknown(data['hymn_number']!, _hymnNumberMeta),
      );
    }
    if (data.containsKey('tune_name')) {
      context.handle(
        _tuneNameMeta,
        tuneName.isAcceptableOrUnknown(data['tune_name']!, _tuneNameMeta),
      );
    }
    if (data.containsKey('meter')) {
      context.handle(
        _meterMeta,
        meter.isAcceptableOrUnknown(data['meter']!, _meterMeta),
      );
    }
    if (data.containsKey('original_key')) {
      context.handle(
        _originalKeyMeta,
        originalKey.isAcceptableOrUnknown(
          data['original_key']!,
          _originalKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hymn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hymn(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hymnNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hymn_number'],
      ),
      tuneName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tune_name'],
      ),
      meter: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meter'],
      ),
      originalKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_key'],
      )!,
    );
  }

  @override
  $HymnsTable createAlias(String alias) {
    return $HymnsTable(attachedDatabase, alias);
  }
}

class Hymn extends DataClass implements Insertable<Hymn> {
  final int id;
  final int? hymnNumber;
  final String? tuneName;
  final String? meter;
  final String originalKey;
  const Hymn({
    required this.id,
    this.hymnNumber,
    this.tuneName,
    this.meter,
    required this.originalKey,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || hymnNumber != null) {
      map['hymn_number'] = Variable<int>(hymnNumber);
    }
    if (!nullToAbsent || tuneName != null) {
      map['tune_name'] = Variable<String>(tuneName);
    }
    if (!nullToAbsent || meter != null) {
      map['meter'] = Variable<String>(meter);
    }
    map['original_key'] = Variable<String>(originalKey);
    return map;
  }

  HymnsCompanion toCompanion(bool nullToAbsent) {
    return HymnsCompanion(
      id: Value(id),
      hymnNumber: hymnNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(hymnNumber),
      tuneName: tuneName == null && nullToAbsent
          ? const Value.absent()
          : Value(tuneName),
      meter: meter == null && nullToAbsent
          ? const Value.absent()
          : Value(meter),
      originalKey: Value(originalKey),
    );
  }

  factory Hymn.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hymn(
      id: serializer.fromJson<int>(json['id']),
      hymnNumber: serializer.fromJson<int?>(json['hymnNumber']),
      tuneName: serializer.fromJson<String?>(json['tuneName']),
      meter: serializer.fromJson<String?>(json['meter']),
      originalKey: serializer.fromJson<String>(json['originalKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hymnNumber': serializer.toJson<int?>(hymnNumber),
      'tuneName': serializer.toJson<String?>(tuneName),
      'meter': serializer.toJson<String?>(meter),
      'originalKey': serializer.toJson<String>(originalKey),
    };
  }

  Hymn copyWith({
    int? id,
    Value<int?> hymnNumber = const Value.absent(),
    Value<String?> tuneName = const Value.absent(),
    Value<String?> meter = const Value.absent(),
    String? originalKey,
  }) => Hymn(
    id: id ?? this.id,
    hymnNumber: hymnNumber.present ? hymnNumber.value : this.hymnNumber,
    tuneName: tuneName.present ? tuneName.value : this.tuneName,
    meter: meter.present ? meter.value : this.meter,
    originalKey: originalKey ?? this.originalKey,
  );
  Hymn copyWithCompanion(HymnsCompanion data) {
    return Hymn(
      id: data.id.present ? data.id.value : this.id,
      hymnNumber: data.hymnNumber.present
          ? data.hymnNumber.value
          : this.hymnNumber,
      tuneName: data.tuneName.present ? data.tuneName.value : this.tuneName,
      meter: data.meter.present ? data.meter.value : this.meter,
      originalKey: data.originalKey.present
          ? data.originalKey.value
          : this.originalKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hymn(')
          ..write('id: $id, ')
          ..write('hymnNumber: $hymnNumber, ')
          ..write('tuneName: $tuneName, ')
          ..write('meter: $meter, ')
          ..write('originalKey: $originalKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, hymnNumber, tuneName, meter, originalKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hymn &&
          other.id == this.id &&
          other.hymnNumber == this.hymnNumber &&
          other.tuneName == this.tuneName &&
          other.meter == this.meter &&
          other.originalKey == this.originalKey);
}

class HymnsCompanion extends UpdateCompanion<Hymn> {
  final Value<int> id;
  final Value<int?> hymnNumber;
  final Value<String?> tuneName;
  final Value<String?> meter;
  final Value<String> originalKey;
  const HymnsCompanion({
    this.id = const Value.absent(),
    this.hymnNumber = const Value.absent(),
    this.tuneName = const Value.absent(),
    this.meter = const Value.absent(),
    this.originalKey = const Value.absent(),
  });
  HymnsCompanion.insert({
    this.id = const Value.absent(),
    this.hymnNumber = const Value.absent(),
    this.tuneName = const Value.absent(),
    this.meter = const Value.absent(),
    required String originalKey,
  }) : originalKey = Value(originalKey);
  static Insertable<Hymn> custom({
    Expression<int>? id,
    Expression<int>? hymnNumber,
    Expression<String>? tuneName,
    Expression<String>? meter,
    Expression<String>? originalKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hymnNumber != null) 'hymn_number': hymnNumber,
      if (tuneName != null) 'tune_name': tuneName,
      if (meter != null) 'meter': meter,
      if (originalKey != null) 'original_key': originalKey,
    });
  }

  HymnsCompanion copyWith({
    Value<int>? id,
    Value<int?>? hymnNumber,
    Value<String?>? tuneName,
    Value<String?>? meter,
    Value<String>? originalKey,
  }) {
    return HymnsCompanion(
      id: id ?? this.id,
      hymnNumber: hymnNumber ?? this.hymnNumber,
      tuneName: tuneName ?? this.tuneName,
      meter: meter ?? this.meter,
      originalKey: originalKey ?? this.originalKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hymnNumber.present) {
      map['hymn_number'] = Variable<int>(hymnNumber.value);
    }
    if (tuneName.present) {
      map['tune_name'] = Variable<String>(tuneName.value);
    }
    if (meter.present) {
      map['meter'] = Variable<String>(meter.value);
    }
    if (originalKey.present) {
      map['original_key'] = Variable<String>(originalKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HymnsCompanion(')
          ..write('id: $id, ')
          ..write('hymnNumber: $hymnNumber, ')
          ..write('tuneName: $tuneName, ')
          ..write('meter: $meter, ')
          ..write('originalKey: $originalKey')
          ..write(')'))
        .toString();
  }
}

class $HymnTextsTable extends HymnTexts
    with TableInfo<$HymnTextsTable, HymnText> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HymnTextsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _hymnIdMeta = const VerificationMeta('hymnId');
  @override
  late final GeneratedColumn<int> hymnId = GeneratedColumn<int>(
    'hymn_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES hymns (id)',
    ),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortTitleMeta = const VerificationMeta(
    'sortTitle',
  );
  @override
  late final GeneratedColumn<String> sortTitle = GeneratedColumn<String>(
    'sort_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _translatorMeta = const VerificationMeta(
    'translator',
  );
  @override
  late final GeneratedColumn<String> translator = GeneratedColumn<String>(
    'translator',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<String> year = GeneratedColumn<String>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _verseCountMeta = const VerificationMeta(
    'verseCount',
  );
  @override
  late final GeneratedColumn<int> verseCount = GeneratedColumn<int>(
    'verse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hasChordsMeta = const VerificationMeta(
    'hasChords',
  );
  @override
  late final GeneratedColumn<int> hasChords = GeneratedColumn<int>(
    'has_chords',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chordproBodyMeta = const VerificationMeta(
    'chordproBody',
  );
  @override
  late final GeneratedColumn<String> chordproBody = GeneratedColumn<String>(
    'chordpro_body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lyricsTextMeta = const VerificationMeta(
    'lyricsText',
  );
  @override
  late final GeneratedColumn<String> lyricsText = GeneratedColumn<String>(
    'lyrics_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstLineMeta = const VerificationMeta(
    'firstLine',
  );
  @override
  late final GeneratedColumn<String> firstLine = GeneratedColumn<String>(
    'first_line',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    hymnId,
    language,
    title,
    sortTitle,
    author,
    translator,
    year,
    verseCount,
    hasChords,
    chordproBody,
    lyricsText,
    firstLine,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hymn_texts';
  @override
  VerificationContext validateIntegrity(
    Insertable<HymnText> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('hymn_id')) {
      context.handle(
        _hymnIdMeta,
        hymnId.isAcceptableOrUnknown(data['hymn_id']!, _hymnIdMeta),
      );
    } else if (isInserting) {
      context.missing(_hymnIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_title')) {
      context.handle(
        _sortTitleMeta,
        sortTitle.isAcceptableOrUnknown(data['sort_title']!, _sortTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_sortTitleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('translator')) {
      context.handle(
        _translatorMeta,
        translator.isAcceptableOrUnknown(data['translator']!, _translatorMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('verse_count')) {
      context.handle(
        _verseCountMeta,
        verseCount.isAcceptableOrUnknown(data['verse_count']!, _verseCountMeta),
      );
    } else if (isInserting) {
      context.missing(_verseCountMeta);
    }
    if (data.containsKey('has_chords')) {
      context.handle(
        _hasChordsMeta,
        hasChords.isAcceptableOrUnknown(data['has_chords']!, _hasChordsMeta),
      );
    } else if (isInserting) {
      context.missing(_hasChordsMeta);
    }
    if (data.containsKey('chordpro_body')) {
      context.handle(
        _chordproBodyMeta,
        chordproBody.isAcceptableOrUnknown(
          data['chordpro_body']!,
          _chordproBodyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_chordproBodyMeta);
    }
    if (data.containsKey('lyrics_text')) {
      context.handle(
        _lyricsTextMeta,
        lyricsText.isAcceptableOrUnknown(data['lyrics_text']!, _lyricsTextMeta),
      );
    } else if (isInserting) {
      context.missing(_lyricsTextMeta);
    }
    if (data.containsKey('first_line')) {
      context.handle(
        _firstLineMeta,
        firstLine.isAcceptableOrUnknown(data['first_line']!, _firstLineMeta),
      );
    } else if (isInserting) {
      context.missing(_firstLineMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HymnText map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HymnText(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      hymnId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hymn_id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      sortTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sort_title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      translator: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translator'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}year'],
      ),
      verseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verse_count'],
      )!,
      hasChords: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}has_chords'],
      )!,
      chordproBody: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chordpro_body'],
      )!,
      lyricsText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lyrics_text'],
      )!,
      firstLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_line'],
      )!,
    );
  }

  @override
  $HymnTextsTable createAlias(String alias) {
    return $HymnTextsTable(attachedDatabase, alias);
  }
}

class HymnText extends DataClass implements Insertable<HymnText> {
  final int id;
  final int hymnId;
  final String language;
  final String title;
  final String sortTitle;
  final String? author;
  final String? translator;
  final String? year;
  final int verseCount;
  final int hasChords;
  final String chordproBody;
  final String lyricsText;
  final String firstLine;
  const HymnText({
    required this.id,
    required this.hymnId,
    required this.language,
    required this.title,
    required this.sortTitle,
    this.author,
    this.translator,
    this.year,
    required this.verseCount,
    required this.hasChords,
    required this.chordproBody,
    required this.lyricsText,
    required this.firstLine,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['hymn_id'] = Variable<int>(hymnId);
    map['language'] = Variable<String>(language);
    map['title'] = Variable<String>(title);
    map['sort_title'] = Variable<String>(sortTitle);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    if (!nullToAbsent || translator != null) {
      map['translator'] = Variable<String>(translator);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<String>(year);
    }
    map['verse_count'] = Variable<int>(verseCount);
    map['has_chords'] = Variable<int>(hasChords);
    map['chordpro_body'] = Variable<String>(chordproBody);
    map['lyrics_text'] = Variable<String>(lyricsText);
    map['first_line'] = Variable<String>(firstLine);
    return map;
  }

  HymnTextsCompanion toCompanion(bool nullToAbsent) {
    return HymnTextsCompanion(
      id: Value(id),
      hymnId: Value(hymnId),
      language: Value(language),
      title: Value(title),
      sortTitle: Value(sortTitle),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      translator: translator == null && nullToAbsent
          ? const Value.absent()
          : Value(translator),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      verseCount: Value(verseCount),
      hasChords: Value(hasChords),
      chordproBody: Value(chordproBody),
      lyricsText: Value(lyricsText),
      firstLine: Value(firstLine),
    );
  }

  factory HymnText.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HymnText(
      id: serializer.fromJson<int>(json['id']),
      hymnId: serializer.fromJson<int>(json['hymnId']),
      language: serializer.fromJson<String>(json['language']),
      title: serializer.fromJson<String>(json['title']),
      sortTitle: serializer.fromJson<String>(json['sortTitle']),
      author: serializer.fromJson<String?>(json['author']),
      translator: serializer.fromJson<String?>(json['translator']),
      year: serializer.fromJson<String?>(json['year']),
      verseCount: serializer.fromJson<int>(json['verseCount']),
      hasChords: serializer.fromJson<int>(json['hasChords']),
      chordproBody: serializer.fromJson<String>(json['chordproBody']),
      lyricsText: serializer.fromJson<String>(json['lyricsText']),
      firstLine: serializer.fromJson<String>(json['firstLine']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'hymnId': serializer.toJson<int>(hymnId),
      'language': serializer.toJson<String>(language),
      'title': serializer.toJson<String>(title),
      'sortTitle': serializer.toJson<String>(sortTitle),
      'author': serializer.toJson<String?>(author),
      'translator': serializer.toJson<String?>(translator),
      'year': serializer.toJson<String?>(year),
      'verseCount': serializer.toJson<int>(verseCount),
      'hasChords': serializer.toJson<int>(hasChords),
      'chordproBody': serializer.toJson<String>(chordproBody),
      'lyricsText': serializer.toJson<String>(lyricsText),
      'firstLine': serializer.toJson<String>(firstLine),
    };
  }

  HymnText copyWith({
    int? id,
    int? hymnId,
    String? language,
    String? title,
    String? sortTitle,
    Value<String?> author = const Value.absent(),
    Value<String?> translator = const Value.absent(),
    Value<String?> year = const Value.absent(),
    int? verseCount,
    int? hasChords,
    String? chordproBody,
    String? lyricsText,
    String? firstLine,
  }) => HymnText(
    id: id ?? this.id,
    hymnId: hymnId ?? this.hymnId,
    language: language ?? this.language,
    title: title ?? this.title,
    sortTitle: sortTitle ?? this.sortTitle,
    author: author.present ? author.value : this.author,
    translator: translator.present ? translator.value : this.translator,
    year: year.present ? year.value : this.year,
    verseCount: verseCount ?? this.verseCount,
    hasChords: hasChords ?? this.hasChords,
    chordproBody: chordproBody ?? this.chordproBody,
    lyricsText: lyricsText ?? this.lyricsText,
    firstLine: firstLine ?? this.firstLine,
  );
  HymnText copyWithCompanion(HymnTextsCompanion data) {
    return HymnText(
      id: data.id.present ? data.id.value : this.id,
      hymnId: data.hymnId.present ? data.hymnId.value : this.hymnId,
      language: data.language.present ? data.language.value : this.language,
      title: data.title.present ? data.title.value : this.title,
      sortTitle: data.sortTitle.present ? data.sortTitle.value : this.sortTitle,
      author: data.author.present ? data.author.value : this.author,
      translator: data.translator.present
          ? data.translator.value
          : this.translator,
      year: data.year.present ? data.year.value : this.year,
      verseCount: data.verseCount.present
          ? data.verseCount.value
          : this.verseCount,
      hasChords: data.hasChords.present ? data.hasChords.value : this.hasChords,
      chordproBody: data.chordproBody.present
          ? data.chordproBody.value
          : this.chordproBody,
      lyricsText: data.lyricsText.present
          ? data.lyricsText.value
          : this.lyricsText,
      firstLine: data.firstLine.present ? data.firstLine.value : this.firstLine,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HymnText(')
          ..write('id: $id, ')
          ..write('hymnId: $hymnId, ')
          ..write('language: $language, ')
          ..write('title: $title, ')
          ..write('sortTitle: $sortTitle, ')
          ..write('author: $author, ')
          ..write('translator: $translator, ')
          ..write('year: $year, ')
          ..write('verseCount: $verseCount, ')
          ..write('hasChords: $hasChords, ')
          ..write('chordproBody: $chordproBody, ')
          ..write('lyricsText: $lyricsText, ')
          ..write('firstLine: $firstLine')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    hymnId,
    language,
    title,
    sortTitle,
    author,
    translator,
    year,
    verseCount,
    hasChords,
    chordproBody,
    lyricsText,
    firstLine,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HymnText &&
          other.id == this.id &&
          other.hymnId == this.hymnId &&
          other.language == this.language &&
          other.title == this.title &&
          other.sortTitle == this.sortTitle &&
          other.author == this.author &&
          other.translator == this.translator &&
          other.year == this.year &&
          other.verseCount == this.verseCount &&
          other.hasChords == this.hasChords &&
          other.chordproBody == this.chordproBody &&
          other.lyricsText == this.lyricsText &&
          other.firstLine == this.firstLine);
}

class HymnTextsCompanion extends UpdateCompanion<HymnText> {
  final Value<int> id;
  final Value<int> hymnId;
  final Value<String> language;
  final Value<String> title;
  final Value<String> sortTitle;
  final Value<String?> author;
  final Value<String?> translator;
  final Value<String?> year;
  final Value<int> verseCount;
  final Value<int> hasChords;
  final Value<String> chordproBody;
  final Value<String> lyricsText;
  final Value<String> firstLine;
  const HymnTextsCompanion({
    this.id = const Value.absent(),
    this.hymnId = const Value.absent(),
    this.language = const Value.absent(),
    this.title = const Value.absent(),
    this.sortTitle = const Value.absent(),
    this.author = const Value.absent(),
    this.translator = const Value.absent(),
    this.year = const Value.absent(),
    this.verseCount = const Value.absent(),
    this.hasChords = const Value.absent(),
    this.chordproBody = const Value.absent(),
    this.lyricsText = const Value.absent(),
    this.firstLine = const Value.absent(),
  });
  HymnTextsCompanion.insert({
    this.id = const Value.absent(),
    required int hymnId,
    required String language,
    required String title,
    required String sortTitle,
    this.author = const Value.absent(),
    this.translator = const Value.absent(),
    this.year = const Value.absent(),
    required int verseCount,
    required int hasChords,
    required String chordproBody,
    required String lyricsText,
    required String firstLine,
  }) : hymnId = Value(hymnId),
       language = Value(language),
       title = Value(title),
       sortTitle = Value(sortTitle),
       verseCount = Value(verseCount),
       hasChords = Value(hasChords),
       chordproBody = Value(chordproBody),
       lyricsText = Value(lyricsText),
       firstLine = Value(firstLine);
  static Insertable<HymnText> custom({
    Expression<int>? id,
    Expression<int>? hymnId,
    Expression<String>? language,
    Expression<String>? title,
    Expression<String>? sortTitle,
    Expression<String>? author,
    Expression<String>? translator,
    Expression<String>? year,
    Expression<int>? verseCount,
    Expression<int>? hasChords,
    Expression<String>? chordproBody,
    Expression<String>? lyricsText,
    Expression<String>? firstLine,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (hymnId != null) 'hymn_id': hymnId,
      if (language != null) 'language': language,
      if (title != null) 'title': title,
      if (sortTitle != null) 'sort_title': sortTitle,
      if (author != null) 'author': author,
      if (translator != null) 'translator': translator,
      if (year != null) 'year': year,
      if (verseCount != null) 'verse_count': verseCount,
      if (hasChords != null) 'has_chords': hasChords,
      if (chordproBody != null) 'chordpro_body': chordproBody,
      if (lyricsText != null) 'lyrics_text': lyricsText,
      if (firstLine != null) 'first_line': firstLine,
    });
  }

  HymnTextsCompanion copyWith({
    Value<int>? id,
    Value<int>? hymnId,
    Value<String>? language,
    Value<String>? title,
    Value<String>? sortTitle,
    Value<String?>? author,
    Value<String?>? translator,
    Value<String?>? year,
    Value<int>? verseCount,
    Value<int>? hasChords,
    Value<String>? chordproBody,
    Value<String>? lyricsText,
    Value<String>? firstLine,
  }) {
    return HymnTextsCompanion(
      id: id ?? this.id,
      hymnId: hymnId ?? this.hymnId,
      language: language ?? this.language,
      title: title ?? this.title,
      sortTitle: sortTitle ?? this.sortTitle,
      author: author ?? this.author,
      translator: translator ?? this.translator,
      year: year ?? this.year,
      verseCount: verseCount ?? this.verseCount,
      hasChords: hasChords ?? this.hasChords,
      chordproBody: chordproBody ?? this.chordproBody,
      lyricsText: lyricsText ?? this.lyricsText,
      firstLine: firstLine ?? this.firstLine,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (hymnId.present) {
      map['hymn_id'] = Variable<int>(hymnId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sortTitle.present) {
      map['sort_title'] = Variable<String>(sortTitle.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (translator.present) {
      map['translator'] = Variable<String>(translator.value);
    }
    if (year.present) {
      map['year'] = Variable<String>(year.value);
    }
    if (verseCount.present) {
      map['verse_count'] = Variable<int>(verseCount.value);
    }
    if (hasChords.present) {
      map['has_chords'] = Variable<int>(hasChords.value);
    }
    if (chordproBody.present) {
      map['chordpro_body'] = Variable<String>(chordproBody.value);
    }
    if (lyricsText.present) {
      map['lyrics_text'] = Variable<String>(lyricsText.value);
    }
    if (firstLine.present) {
      map['first_line'] = Variable<String>(firstLine.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HymnTextsCompanion(')
          ..write('id: $id, ')
          ..write('hymnId: $hymnId, ')
          ..write('language: $language, ')
          ..write('title: $title, ')
          ..write('sortTitle: $sortTitle, ')
          ..write('author: $author, ')
          ..write('translator: $translator, ')
          ..write('year: $year, ')
          ..write('verseCount: $verseCount, ')
          ..write('hasChords: $hasChords, ')
          ..write('chordproBody: $chordproBody, ')
          ..write('lyricsText: $lyricsText, ')
          ..write('firstLine: $firstLine')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HymnsTable hymns = $HymnsTable(this);
  late final $HymnTextsTable hymnTexts = $HymnTextsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [hymns, hymnTexts];
}

typedef $$HymnsTableCreateCompanionBuilder = HymnsCompanion Function({
  Value<int> id,
  Value<int?> hymnNumber,
  Value<String?> tuneName,
  Value<String?> meter,
  required String originalKey,
});
typedef $$HymnsTableUpdateCompanionBuilder = HymnsCompanion Function({
  Value<int> id,
  Value<int?> hymnNumber,
  Value<String?> tuneName,
  Value<String?> meter,
  Value<String> originalKey,
});

final class $$HymnsTableReferences
    extends BaseReferences<_$AppDatabase, $HymnsTable, Hymn> {
  $$HymnsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HymnTextsTable, List<HymnText>>
  _hymnTextsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.hymnTexts,
    aliasName: 'hymns__id__hymn_texts__hymn_id',
  );

  $$HymnTextsTableProcessedTableManager get hymnTextsRefs {
    final manager = $$HymnTextsTableTableManager(
      $_db,
      $_db.hymnTexts,
    ).filter((f) => f.hymnId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hymnTextsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HymnsTableFilterComposer extends Composer<_$AppDatabase, $HymnsTable> {
  $$HymnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hymnNumber => $composableBuilder(
    column: $table.hymnNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tuneName => $composableBuilder(
    column: $table.tuneName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meter => $composableBuilder(
    column: $table.meter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalKey => $composableBuilder(
    column: $table.originalKey,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> hymnTextsRefs(
    Expression<bool> Function($$HymnTextsTableFilterComposer f) f,
  ) {
    final $$HymnTextsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hymnTexts,
      getReferencedColumn: (t) => t.hymnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HymnTextsTableFilterComposer(
            $db: $db,
            $table: $db.hymnTexts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HymnsTableOrderingComposer
    extends Composer<_$AppDatabase, $HymnsTable> {
  $$HymnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hymnNumber => $composableBuilder(
    column: $table.hymnNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tuneName => $composableBuilder(
    column: $table.tuneName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meter => $composableBuilder(
    column: $table.meter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalKey => $composableBuilder(
    column: $table.originalKey,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HymnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HymnsTable> {
  $$HymnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get hymnNumber => $composableBuilder(
    column: $table.hymnNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tuneName =>
      $composableBuilder(column: $table.tuneName, builder: (column) => column);

  GeneratedColumn<String> get meter =>
      $composableBuilder(column: $table.meter, builder: (column) => column);

  GeneratedColumn<String> get originalKey => $composableBuilder(
    column: $table.originalKey,
    builder: (column) => column,
  );

  Expression<T> hymnTextsRefs<T extends Object>(
    Expression<T> Function($$HymnTextsTableAnnotationComposer a) f,
  ) {
    final $$HymnTextsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hymnTexts,
      getReferencedColumn: (t) => t.hymnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HymnTextsTableAnnotationComposer(
            $db: $db,
            $table: $db.hymnTexts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HymnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HymnsTable,
          Hymn,
          $$HymnsTableFilterComposer,
          $$HymnsTableOrderingComposer,
          $$HymnsTableAnnotationComposer,
          $$HymnsTableCreateCompanionBuilder,
          $$HymnsTableUpdateCompanionBuilder,
          (Hymn, $$HymnsTableReferences),
          Hymn,
          PrefetchHooks Function({bool hymnTextsRefs})
        > {
  $$HymnsTableTableManager(_$AppDatabase db, $HymnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HymnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HymnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HymnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> hymnNumber = const Value.absent(),
                Value<String?> tuneName = const Value.absent(),
                Value<String?> meter = const Value.absent(),
                Value<String> originalKey = const Value.absent(),
              }) => HymnsCompanion(
                id: id,
                hymnNumber: hymnNumber,
                tuneName: tuneName,
                meter: meter,
                originalKey: originalKey,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> hymnNumber = const Value.absent(),
                Value<String?> tuneName = const Value.absent(),
                Value<String?> meter = const Value.absent(),
                required String originalKey,
              }) => HymnsCompanion.insert(
                id: id,
                hymnNumber: hymnNumber,
                tuneName: tuneName,
                meter: meter,
                originalKey: originalKey,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HymnsTable, Hymn>(table),
                  $$HymnsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({hymnTextsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (hymnTextsRefs) db.hymnTexts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (hymnTextsRefs)
                    await $_getPrefetchedData<Hymn, $HymnsTable, HymnText>(
                      currentTable: table,
                      referencedTable: $$HymnsTableReferences
                          ._hymnTextsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$HymnsTableReferences(db, table, p0).hymnTextsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.hymnId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HymnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HymnsTable,
      Hymn,
      $$HymnsTableFilterComposer,
      $$HymnsTableOrderingComposer,
      $$HymnsTableAnnotationComposer,
      $$HymnsTableCreateCompanionBuilder,
      $$HymnsTableUpdateCompanionBuilder,
      (Hymn, $$HymnsTableReferences),
      Hymn,
      PrefetchHooks Function({bool hymnTextsRefs})
    >;
typedef $$HymnTextsTableCreateCompanionBuilder = HymnTextsCompanion Function({
  Value<int> id,
  required int hymnId,
  required String language,
  required String title,
  required String sortTitle,
  Value<String?> author,
  Value<String?> translator,
  Value<String?> year,
  required int verseCount,
  required int hasChords,
  required String chordproBody,
  required String lyricsText,
  required String firstLine,
});
typedef $$HymnTextsTableUpdateCompanionBuilder = HymnTextsCompanion Function({
  Value<int> id,
  Value<int> hymnId,
  Value<String> language,
  Value<String> title,
  Value<String> sortTitle,
  Value<String?> author,
  Value<String?> translator,
  Value<String?> year,
  Value<int> verseCount,
  Value<int> hasChords,
  Value<String> chordproBody,
  Value<String> lyricsText,
  Value<String> firstLine,
});

final class $$HymnTextsTableReferences
    extends BaseReferences<_$AppDatabase, $HymnTextsTable, HymnText> {
  $$HymnTextsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HymnsTable _hymnIdTable(_$AppDatabase db) =>
      db.hymns.createAlias('hymn_texts__hymn_id__hymns__id');

  $$HymnsTableProcessedTableManager get hymnId {
    final $_column = $_itemColumn<int>('hymn_id')!;

    final manager = $$HymnsTableTableManager(
      $_db,
      $_db.hymns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_hymnIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HymnTextsTableFilterComposer
    extends Composer<_$AppDatabase, $HymnTextsTable> {
  $$HymnTextsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sortTitle => $composableBuilder(
    column: $table.sortTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translator => $composableBuilder(
    column: $table.translator,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hasChords => $composableBuilder(
    column: $table.hasChords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chordproBody => $composableBuilder(
    column: $table.chordproBody,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lyricsText => $composableBuilder(
    column: $table.lyricsText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstLine => $composableBuilder(
    column: $table.firstLine,
    builder: (column) => ColumnFilters(column),
  );

  $$HymnsTableFilterComposer get hymnId {
    final $$HymnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hymnId,
      referencedTable: $db.hymns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HymnsTableFilterComposer(
            $db: $db,
            $table: $db.hymns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HymnTextsTableOrderingComposer
    extends Composer<_$AppDatabase, $HymnTextsTable> {
  $$HymnTextsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sortTitle => $composableBuilder(
    column: $table.sortTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translator => $composableBuilder(
    column: $table.translator,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hasChords => $composableBuilder(
    column: $table.hasChords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chordproBody => $composableBuilder(
    column: $table.chordproBody,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lyricsText => $composableBuilder(
    column: $table.lyricsText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstLine => $composableBuilder(
    column: $table.firstLine,
    builder: (column) => ColumnOrderings(column),
  );

  $$HymnsTableOrderingComposer get hymnId {
    final $$HymnsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hymnId,
      referencedTable: $db.hymns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HymnsTableOrderingComposer(
            $db: $db,
            $table: $db.hymns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HymnTextsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HymnTextsTable> {
  $$HymnTextsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get sortTitle =>
      $composableBuilder(column: $table.sortTitle, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get translator => $composableBuilder(
    column: $table.translator,
    builder: (column) => column,
  );

  GeneratedColumn<String> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get verseCount => $composableBuilder(
    column: $table.verseCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hasChords =>
      $composableBuilder(column: $table.hasChords, builder: (column) => column);

  GeneratedColumn<String> get chordproBody => $composableBuilder(
    column: $table.chordproBody,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lyricsText => $composableBuilder(
    column: $table.lyricsText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstLine =>
      $composableBuilder(column: $table.firstLine, builder: (column) => column);

  $$HymnsTableAnnotationComposer get hymnId {
    final $$HymnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.hymnId,
      referencedTable: $db.hymns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HymnsTableAnnotationComposer(
            $db: $db,
            $table: $db.hymns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HymnTextsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HymnTextsTable,
          HymnText,
          $$HymnTextsTableFilterComposer,
          $$HymnTextsTableOrderingComposer,
          $$HymnTextsTableAnnotationComposer,
          $$HymnTextsTableCreateCompanionBuilder,
          $$HymnTextsTableUpdateCompanionBuilder,
          (HymnText, $$HymnTextsTableReferences),
          HymnText,
          PrefetchHooks Function({bool hymnId})
        > {
  $$HymnTextsTableTableManager(_$AppDatabase db, $HymnTextsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HymnTextsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HymnTextsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HymnTextsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> hymnId = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> sortTitle = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<String?> translator = const Value.absent(),
                Value<String?> year = const Value.absent(),
                Value<int> verseCount = const Value.absent(),
                Value<int> hasChords = const Value.absent(),
                Value<String> chordproBody = const Value.absent(),
                Value<String> lyricsText = const Value.absent(),
                Value<String> firstLine = const Value.absent(),
              }) => HymnTextsCompanion(
                id: id,
                hymnId: hymnId,
                language: language,
                title: title,
                sortTitle: sortTitle,
                author: author,
                translator: translator,
                year: year,
                verseCount: verseCount,
                hasChords: hasChords,
                chordproBody: chordproBody,
                lyricsText: lyricsText,
                firstLine: firstLine,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int hymnId,
                required String language,
                required String title,
                required String sortTitle,
                Value<String?> author = const Value.absent(),
                Value<String?> translator = const Value.absent(),
                Value<String?> year = const Value.absent(),
                required int verseCount,
                required int hasChords,
                required String chordproBody,
                required String lyricsText,
                required String firstLine,
              }) => HymnTextsCompanion.insert(
                id: id,
                hymnId: hymnId,
                language: language,
                title: title,
                sortTitle: sortTitle,
                author: author,
                translator: translator,
                year: year,
                verseCount: verseCount,
                hasChords: hasChords,
                chordproBody: chordproBody,
                lyricsText: lyricsText,
                firstLine: firstLine,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HymnTextsTable, HymnText>(table),
                  $$HymnTextsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({hymnId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (hymnId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.hymnId,
                        referencedTable: $$HymnTextsTableReferences
                            ._hymnIdTable(db),
                        referencedColumn: $$HymnTextsTableReferences
                            ._hymnIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HymnTextsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HymnTextsTable,
      HymnText,
      $$HymnTextsTableFilterComposer,
      $$HymnTextsTableOrderingComposer,
      $$HymnTextsTableAnnotationComposer,
      $$HymnTextsTableCreateCompanionBuilder,
      $$HymnTextsTableUpdateCompanionBuilder,
      (HymnText, $$HymnTextsTableReferences),
      HymnText,
      PrefetchHooks Function({bool hymnId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HymnsTableTableManager get hymns =>
      $$HymnsTableTableManager(_db, _db.hymns);
  $$HymnTextsTableTableManager get hymnTexts =>
      $$HymnTextsTableTableManager(_db, _db.hymnTexts);
}
