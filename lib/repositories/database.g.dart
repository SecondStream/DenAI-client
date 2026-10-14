// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CharsTable extends Chars with TableInfo<$CharsTable, CharData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
      'crop', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _backgroundMeta =
      const VerificationMeta('background');
  @override
  late final GeneratedColumn<String> background = GeneratedColumn<String>(
      'background', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _appearanceMeta =
      const VerificationMeta('appearance');
  @override
  late final GeneratedColumn<String> appearance = GeneratedColumn<String>(
      'appearance', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _personalityMeta =
      const VerificationMeta('personality');
  @override
  late final GeneratedColumn<String> personality = GeneratedColumn<String>(
      'personality', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _scenarioMeta =
      const VerificationMeta('scenario');
  @override
  late final GeneratedColumn<String> scenario = GeneratedColumn<String>(
      'scenario', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _greetingMeta =
      const VerificationMeta('greeting');
  @override
  late final GeneratedColumn<String> greeting = GeneratedColumn<String>(
      'greeting', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
      'prompt', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        avatar,
        crop,
        background,
        appearance,
        personality,
        scenario,
        greeting,
        prompt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chars';
  @override
  VerificationContext validateIntegrity(Insertable<CharData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('crop')) {
      context.handle(
          _cropMeta, crop.isAcceptableOrUnknown(data['crop']!, _cropMeta));
    }
    if (data.containsKey('background')) {
      context.handle(
          _backgroundMeta,
          background.isAcceptableOrUnknown(
              data['background']!, _backgroundMeta));
    }
    if (data.containsKey('appearance')) {
      context.handle(
          _appearanceMeta,
          appearance.isAcceptableOrUnknown(
              data['appearance']!, _appearanceMeta));
    }
    if (data.containsKey('personality')) {
      context.handle(
          _personalityMeta,
          personality.isAcceptableOrUnknown(
              data['personality']!, _personalityMeta));
    }
    if (data.containsKey('scenario')) {
      context.handle(_scenarioMeta,
          scenario.isAcceptableOrUnknown(data['scenario']!, _scenarioMeta));
    }
    if (data.containsKey('greeting')) {
      context.handle(_greetingMeta,
          greeting.isAcceptableOrUnknown(data['greeting']!, _greetingMeta));
    }
    if (data.containsKey('prompt')) {
      context.handle(_promptMeta,
          prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      crop: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}crop']),
      background: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}background']),
      appearance: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}appearance'])!,
      personality: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}personality'])!,
      scenario: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}scenario'])!,
      greeting: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}greeting'])!,
      prompt: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}prompt'])!,
    );
  }

  @override
  $CharsTable createAlias(String alias) {
    return $CharsTable(attachedDatabase, alias);
  }
}

class CharData extends DataClass implements Insertable<CharData> {
  final int id;
  final String name;
  final String? avatar;
  final String? crop;
  final String? background;
  final String appearance;
  final String personality;
  final String scenario;
  final String greeting;
  final String prompt;
  const CharData(
      {required this.id,
      required this.name,
      this.avatar,
      this.crop,
      this.background,
      required this.appearance,
      required this.personality,
      required this.scenario,
      required this.greeting,
      required this.prompt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || crop != null) {
      map['crop'] = Variable<String>(crop);
    }
    if (!nullToAbsent || background != null) {
      map['background'] = Variable<String>(background);
    }
    map['appearance'] = Variable<String>(appearance);
    map['personality'] = Variable<String>(personality);
    map['scenario'] = Variable<String>(scenario);
    map['greeting'] = Variable<String>(greeting);
    map['prompt'] = Variable<String>(prompt);
    return map;
  }

  CharsCompanion toCompanion(bool nullToAbsent) {
    return CharsCompanion(
      id: Value(id),
      name: Value(name),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      crop: crop == null && nullToAbsent ? const Value.absent() : Value(crop),
      background: background == null && nullToAbsent
          ? const Value.absent()
          : Value(background),
      appearance: Value(appearance),
      personality: Value(personality),
      scenario: Value(scenario),
      greeting: Value(greeting),
      prompt: Value(prompt),
    );
  }

  factory CharData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      crop: serializer.fromJson<String?>(json['crop']),
      background: serializer.fromJson<String?>(json['background']),
      appearance: serializer.fromJson<String>(json['appearance']),
      personality: serializer.fromJson<String>(json['personality']),
      scenario: serializer.fromJson<String>(json['scenario']),
      greeting: serializer.fromJson<String>(json['greeting']),
      prompt: serializer.fromJson<String>(json['prompt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'crop': serializer.toJson<String?>(crop),
      'background': serializer.toJson<String?>(background),
      'appearance': serializer.toJson<String>(appearance),
      'personality': serializer.toJson<String>(personality),
      'scenario': serializer.toJson<String>(scenario),
      'greeting': serializer.toJson<String>(greeting),
      'prompt': serializer.toJson<String>(prompt),
    };
  }

  CharData copyWith(
          {int? id,
          String? name,
          Value<String?> avatar = const Value.absent(),
          Value<String?> crop = const Value.absent(),
          Value<String?> background = const Value.absent(),
          String? appearance,
          String? personality,
          String? scenario,
          String? greeting,
          String? prompt}) =>
      CharData(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar.present ? avatar.value : this.avatar,
        crop: crop.present ? crop.value : this.crop,
        background: background.present ? background.value : this.background,
        appearance: appearance ?? this.appearance,
        personality: personality ?? this.personality,
        scenario: scenario ?? this.scenario,
        greeting: greeting ?? this.greeting,
        prompt: prompt ?? this.prompt,
      );
  @override
  String toString() {
    return (StringBuffer('CharData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('crop: $crop, ')
          ..write('background: $background, ')
          ..write('appearance: $appearance, ')
          ..write('personality: $personality, ')
          ..write('scenario: $scenario, ')
          ..write('greeting: $greeting, ')
          ..write('prompt: $prompt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, avatar, crop, background,
      appearance, personality, scenario, greeting, prompt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.crop == this.crop &&
          other.background == this.background &&
          other.appearance == this.appearance &&
          other.personality == this.personality &&
          other.scenario == this.scenario &&
          other.greeting == this.greeting &&
          other.prompt == this.prompt);
}

class CharsCompanion extends UpdateCompanion<CharData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> avatar;
  final Value<String?> crop;
  final Value<String?> background;
  final Value<String> appearance;
  final Value<String> personality;
  final Value<String> scenario;
  final Value<String> greeting;
  final Value<String> prompt;
  const CharsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.crop = const Value.absent(),
    this.background = const Value.absent(),
    this.appearance = const Value.absent(),
    this.personality = const Value.absent(),
    this.scenario = const Value.absent(),
    this.greeting = const Value.absent(),
    this.prompt = const Value.absent(),
  });
  CharsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.avatar = const Value.absent(),
    this.crop = const Value.absent(),
    this.background = const Value.absent(),
    this.appearance = const Value.absent(),
    this.personality = const Value.absent(),
    this.scenario = const Value.absent(),
    this.greeting = const Value.absent(),
    this.prompt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CharData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<String>? crop,
    Expression<String>? background,
    Expression<String>? appearance,
    Expression<String>? personality,
    Expression<String>? scenario,
    Expression<String>? greeting,
    Expression<String>? prompt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (crop != null) 'crop': crop,
      if (background != null) 'background': background,
      if (appearance != null) 'appearance': appearance,
      if (personality != null) 'personality': personality,
      if (scenario != null) 'scenario': scenario,
      if (greeting != null) 'greeting': greeting,
      if (prompt != null) 'prompt': prompt,
    });
  }

  CharsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? avatar,
      Value<String?>? crop,
      Value<String?>? background,
      Value<String>? appearance,
      Value<String>? personality,
      Value<String>? scenario,
      Value<String>? greeting,
      Value<String>? prompt}) {
    return CharsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      crop: crop ?? this.crop,
      background: background ?? this.background,
      appearance: appearance ?? this.appearance,
      personality: personality ?? this.personality,
      scenario: scenario ?? this.scenario,
      greeting: greeting ?? this.greeting,
      prompt: prompt ?? this.prompt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (crop.present) {
      map['crop'] = Variable<String>(crop.value);
    }
    if (background.present) {
      map['background'] = Variable<String>(background.value);
    }
    if (appearance.present) {
      map['appearance'] = Variable<String>(appearance.value);
    }
    if (personality.present) {
      map['personality'] = Variable<String>(personality.value);
    }
    if (scenario.present) {
      map['scenario'] = Variable<String>(scenario.value);
    }
    if (greeting.present) {
      map['greeting'] = Variable<String>(greeting.value);
    }
    if (prompt.present) {
      map['prompt'] = Variable<String>(prompt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('crop: $crop, ')
          ..write('background: $background, ')
          ..write('appearance: $appearance, ')
          ..write('personality: $personality, ')
          ..write('scenario: $scenario, ')
          ..write('greeting: $greeting, ')
          ..write('prompt: $prompt')
          ..write(')'))
        .toString();
  }
}

class $LorebooksTable extends Lorebooks
    with TableInfo<$LorebooksTable, LorebookData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LorebooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _aboutMeta = const VerificationMeta('about');
  @override
  late final GeneratedColumn<String> about = GeneratedColumn<String>(
      'about', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
      'cover', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
      'crop', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, about, cover, crop];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lorebooks';
  @override
  VerificationContext validateIntegrity(Insertable<LorebookData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('about')) {
      context.handle(
          _aboutMeta, about.isAcceptableOrUnknown(data['about']!, _aboutMeta));
    }
    if (data.containsKey('cover')) {
      context.handle(
          _coverMeta, cover.isAcceptableOrUnknown(data['cover']!, _coverMeta));
    } else if (isInserting) {
      context.missing(_coverMeta);
    }
    if (data.containsKey('crop')) {
      context.handle(
          _cropMeta, crop.isAcceptableOrUnknown(data['crop']!, _cropMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LorebookData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LorebookData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      about: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}about'])!,
      cover: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cover'])!,
      crop: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}crop']),
    );
  }

  @override
  $LorebooksTable createAlias(String alias) {
    return $LorebooksTable(attachedDatabase, alias);
  }
}

class LorebookData extends DataClass implements Insertable<LorebookData> {
  final int id;
  final String name;
  final String about;
  final String cover;
  final String? crop;
  const LorebookData(
      {required this.id,
      required this.name,
      required this.about,
      required this.cover,
      this.crop});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['about'] = Variable<String>(about);
    map['cover'] = Variable<String>(cover);
    if (!nullToAbsent || crop != null) {
      map['crop'] = Variable<String>(crop);
    }
    return map;
  }

  LorebooksCompanion toCompanion(bool nullToAbsent) {
    return LorebooksCompanion(
      id: Value(id),
      name: Value(name),
      about: Value(about),
      cover: Value(cover),
      crop: crop == null && nullToAbsent ? const Value.absent() : Value(crop),
    );
  }

  factory LorebookData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LorebookData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      about: serializer.fromJson<String>(json['about']),
      cover: serializer.fromJson<String>(json['cover']),
      crop: serializer.fromJson<String?>(json['crop']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'about': serializer.toJson<String>(about),
      'cover': serializer.toJson<String>(cover),
      'crop': serializer.toJson<String?>(crop),
    };
  }

  LorebookData copyWith(
          {int? id,
          String? name,
          String? about,
          String? cover,
          Value<String?> crop = const Value.absent()}) =>
      LorebookData(
        id: id ?? this.id,
        name: name ?? this.name,
        about: about ?? this.about,
        cover: cover ?? this.cover,
        crop: crop.present ? crop.value : this.crop,
      );
  @override
  String toString() {
    return (StringBuffer('LorebookData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('about: $about, ')
          ..write('cover: $cover, ')
          ..write('crop: $crop')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, about, cover, crop);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LorebookData &&
          other.id == this.id &&
          other.name == this.name &&
          other.about == this.about &&
          other.cover == this.cover &&
          other.crop == this.crop);
}

class LorebooksCompanion extends UpdateCompanion<LorebookData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> about;
  final Value<String> cover;
  final Value<String?> crop;
  const LorebooksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.about = const Value.absent(),
    this.cover = const Value.absent(),
    this.crop = const Value.absent(),
  });
  LorebooksCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.about = const Value.absent(),
    required String cover,
    this.crop = const Value.absent(),
  })  : name = Value(name),
        cover = Value(cover);
  static Insertable<LorebookData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? about,
    Expression<String>? cover,
    Expression<String>? crop,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (about != null) 'about': about,
      if (cover != null) 'cover': cover,
      if (crop != null) 'crop': crop,
    });
  }

  LorebooksCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? about,
      Value<String>? cover,
      Value<String?>? crop}) {
    return LorebooksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      about: about ?? this.about,
      cover: cover ?? this.cover,
      crop: crop ?? this.crop,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (about.present) {
      map['about'] = Variable<String>(about.value);
    }
    if (cover.present) {
      map['cover'] = Variable<String>(cover.value);
    }
    if (crop.present) {
      map['crop'] = Variable<String>(crop.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LorebooksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('about: $about, ')
          ..write('cover: $cover, ')
          ..write('crop: $crop')
          ..write(')'))
        .toString();
  }
}

class $CharLorebooksTable extends CharLorebooks
    with TableInfo<$CharLorebooksTable, CharLorebook> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharLorebooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _charIdMeta = const VerificationMeta('charId');
  @override
  late final GeneratedColumn<int> charId = GeneratedColumn<int>(
      'char_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES chars (id) ON DELETE CASCADE'));
  static const VerificationMeta _lorebookIdMeta =
      const VerificationMeta('lorebookId');
  @override
  late final GeneratedColumn<int> lorebookId = GeneratedColumn<int>(
      'lorebook_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lorebooks (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [charId, lorebookId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'char_lorebooks';
  @override
  VerificationContext validateIntegrity(Insertable<CharLorebook> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('char_id')) {
      context.handle(_charIdMeta,
          charId.isAcceptableOrUnknown(data['char_id']!, _charIdMeta));
    } else if (isInserting) {
      context.missing(_charIdMeta);
    }
    if (data.containsKey('lorebook_id')) {
      context.handle(
          _lorebookIdMeta,
          lorebookId.isAcceptableOrUnknown(
              data['lorebook_id']!, _lorebookIdMeta));
    } else if (isInserting) {
      context.missing(_lorebookIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {charId, lorebookId};
  @override
  CharLorebook map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharLorebook(
      charId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}char_id'])!,
      lorebookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lorebook_id'])!,
    );
  }

  @override
  $CharLorebooksTable createAlias(String alias) {
    return $CharLorebooksTable(attachedDatabase, alias);
  }
}

class CharLorebook extends DataClass implements Insertable<CharLorebook> {
  final int charId;
  final int lorebookId;
  const CharLorebook({required this.charId, required this.lorebookId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['char_id'] = Variable<int>(charId);
    map['lorebook_id'] = Variable<int>(lorebookId);
    return map;
  }

  CharLorebooksCompanion toCompanion(bool nullToAbsent) {
    return CharLorebooksCompanion(
      charId: Value(charId),
      lorebookId: Value(lorebookId),
    );
  }

  factory CharLorebook.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharLorebook(
      charId: serializer.fromJson<int>(json['charId']),
      lorebookId: serializer.fromJson<int>(json['lorebookId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'charId': serializer.toJson<int>(charId),
      'lorebookId': serializer.toJson<int>(lorebookId),
    };
  }

  CharLorebook copyWith({int? charId, int? lorebookId}) => CharLorebook(
        charId: charId ?? this.charId,
        lorebookId: lorebookId ?? this.lorebookId,
      );
  @override
  String toString() {
    return (StringBuffer('CharLorebook(')
          ..write('charId: $charId, ')
          ..write('lorebookId: $lorebookId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(charId, lorebookId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharLorebook &&
          other.charId == this.charId &&
          other.lorebookId == this.lorebookId);
}

class CharLorebooksCompanion extends UpdateCompanion<CharLorebook> {
  final Value<int> charId;
  final Value<int> lorebookId;
  final Value<int> rowid;
  const CharLorebooksCompanion({
    this.charId = const Value.absent(),
    this.lorebookId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharLorebooksCompanion.insert({
    required int charId,
    required int lorebookId,
    this.rowid = const Value.absent(),
  })  : charId = Value(charId),
        lorebookId = Value(lorebookId);
  static Insertable<CharLorebook> custom({
    Expression<int>? charId,
    Expression<int>? lorebookId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (charId != null) 'char_id': charId,
      if (lorebookId != null) 'lorebook_id': lorebookId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharLorebooksCompanion copyWith(
      {Value<int>? charId, Value<int>? lorebookId, Value<int>? rowid}) {
    return CharLorebooksCompanion(
      charId: charId ?? this.charId,
      lorebookId: lorebookId ?? this.lorebookId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (charId.present) {
      map['char_id'] = Variable<int>(charId.value);
    }
    if (lorebookId.present) {
      map['lorebook_id'] = Variable<int>(lorebookId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharLorebooksCompanion(')
          ..write('charId: $charId, ')
          ..write('lorebookId: $lorebookId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LoreEntriesTable extends LoreEntries
    with TableInfo<$LoreEntriesTable, LoreEntryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoreEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _lorebookIdMeta =
      const VerificationMeta('lorebookId');
  @override
  late final GeneratedColumn<int> lorebookId = GeneratedColumn<int>(
      'lorebook_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES lorebooks (id) ON DELETE CASCADE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  @override
  List<GeneratedColumn> get $columns => [id, lorebookId, title, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lore_entries';
  @override
  VerificationContext validateIntegrity(Insertable<LoreEntryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lorebook_id')) {
      context.handle(
          _lorebookIdMeta,
          lorebookId.isAcceptableOrUnknown(
              data['lorebook_id']!, _lorebookIdMeta));
    } else if (isInserting) {
      context.missing(_lorebookIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoreEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoreEntryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lorebookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}lorebook_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
    );
  }

  @override
  $LoreEntriesTable createAlias(String alias) {
    return $LoreEntriesTable(attachedDatabase, alias);
  }
}

class LoreEntryData extends DataClass implements Insertable<LoreEntryData> {
  final int id;
  final int lorebookId;
  final String title;
  final String content;
  const LoreEntryData(
      {required this.id,
      required this.lorebookId,
      required this.title,
      required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lorebook_id'] = Variable<int>(lorebookId);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    return map;
  }

  LoreEntriesCompanion toCompanion(bool nullToAbsent) {
    return LoreEntriesCompanion(
      id: Value(id),
      lorebookId: Value(lorebookId),
      title: Value(title),
      content: Value(content),
    );
  }

  factory LoreEntryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LoreEntryData(
      id: serializer.fromJson<int>(json['id']),
      lorebookId: serializer.fromJson<int>(json['lorebookId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lorebookId': serializer.toJson<int>(lorebookId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
    };
  }

  LoreEntryData copyWith(
          {int? id, int? lorebookId, String? title, String? content}) =>
      LoreEntryData(
        id: id ?? this.id,
        lorebookId: lorebookId ?? this.lorebookId,
        title: title ?? this.title,
        content: content ?? this.content,
      );
  @override
  String toString() {
    return (StringBuffer('LoreEntryData(')
          ..write('id: $id, ')
          ..write('lorebookId: $lorebookId, ')
          ..write('title: $title, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lorebookId, title, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LoreEntryData &&
          other.id == this.id &&
          other.lorebookId == this.lorebookId &&
          other.title == this.title &&
          other.content == this.content);
}

class LoreEntriesCompanion extends UpdateCompanion<LoreEntryData> {
  final Value<int> id;
  final Value<int> lorebookId;
  final Value<String> title;
  final Value<String> content;
  const LoreEntriesCompanion({
    this.id = const Value.absent(),
    this.lorebookId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
  });
  LoreEntriesCompanion.insert({
    this.id = const Value.absent(),
    required int lorebookId,
    required String title,
    this.content = const Value.absent(),
  })  : lorebookId = Value(lorebookId),
        title = Value(title);
  static Insertable<LoreEntryData> custom({
    Expression<int>? id,
    Expression<int>? lorebookId,
    Expression<String>? title,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lorebookId != null) 'lorebook_id': lorebookId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
    });
  }

  LoreEntriesCompanion copyWith(
      {Value<int>? id,
      Value<int>? lorebookId,
      Value<String>? title,
      Value<String>? content}) {
    return LoreEntriesCompanion(
      id: id ?? this.id,
      lorebookId: lorebookId ?? this.lorebookId,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lorebookId.present) {
      map['lorebook_id'] = Variable<int>(lorebookId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoreEntriesCompanion(')
          ..write('id: $id, ')
          ..write('lorebookId: $lorebookId, ')
          ..write('title: $title, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $UserCardsTable extends UserCards
    with TableInfo<$UserCardsTable, UserCardData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
      'avatar', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
      'crop', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isRemovedMeta =
      const VerificationMeta('isRemoved');
  @override
  late final GeneratedColumn<bool> isRemoved = GeneratedColumn<bool>(
      'is_removed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_removed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, avatar, crop, description, isDefault, isRemoved];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_cards';
  @override
  VerificationContext validateIntegrity(Insertable<UserCardData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(_avatarMeta,
          avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta));
    }
    if (data.containsKey('crop')) {
      context.handle(
          _cropMeta, crop.isAcceptableOrUnknown(data['crop']!, _cropMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('is_removed')) {
      context.handle(_isRemovedMeta,
          isRemoved.isAcceptableOrUnknown(data['is_removed']!, _isRemovedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCardData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatar: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar']),
      crop: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}crop']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      isRemoved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_removed'])!,
    );
  }

  @override
  $UserCardsTable createAlias(String alias) {
    return $UserCardsTable(attachedDatabase, alias);
  }
}

class UserCardData extends DataClass implements Insertable<UserCardData> {
  final int id;
  final String name;
  final String? avatar;
  final String? crop;
  final String description;
  final bool isDefault;
  final bool isRemoved;
  const UserCardData(
      {required this.id,
      required this.name,
      this.avatar,
      this.crop,
      required this.description,
      required this.isDefault,
      required this.isRemoved});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatar != null) {
      map['avatar'] = Variable<String>(avatar);
    }
    if (!nullToAbsent || crop != null) {
      map['crop'] = Variable<String>(crop);
    }
    map['description'] = Variable<String>(description);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_removed'] = Variable<bool>(isRemoved);
    return map;
  }

  UserCardsCompanion toCompanion(bool nullToAbsent) {
    return UserCardsCompanion(
      id: Value(id),
      name: Value(name),
      avatar:
          avatar == null && nullToAbsent ? const Value.absent() : Value(avatar),
      crop: crop == null && nullToAbsent ? const Value.absent() : Value(crop),
      description: Value(description),
      isDefault: Value(isDefault),
      isRemoved: Value(isRemoved),
    );
  }

  factory UserCardData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCardData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatar: serializer.fromJson<String?>(json['avatar']),
      crop: serializer.fromJson<String?>(json['crop']),
      description: serializer.fromJson<String>(json['description']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isRemoved: serializer.fromJson<bool>(json['isRemoved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'avatar': serializer.toJson<String?>(avatar),
      'crop': serializer.toJson<String?>(crop),
      'description': serializer.toJson<String>(description),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isRemoved': serializer.toJson<bool>(isRemoved),
    };
  }

  UserCardData copyWith(
          {int? id,
          String? name,
          Value<String?> avatar = const Value.absent(),
          Value<String?> crop = const Value.absent(),
          String? description,
          bool? isDefault,
          bool? isRemoved}) =>
      UserCardData(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar.present ? avatar.value : this.avatar,
        crop: crop.present ? crop.value : this.crop,
        description: description ?? this.description,
        isDefault: isDefault ?? this.isDefault,
        isRemoved: isRemoved ?? this.isRemoved,
      );
  @override
  String toString() {
    return (StringBuffer('UserCardData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('crop: $crop, ')
          ..write('description: $description, ')
          ..write('isDefault: $isDefault, ')
          ..write('isRemoved: $isRemoved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, avatar, crop, description, isDefault, isRemoved);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCardData &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatar == this.avatar &&
          other.crop == this.crop &&
          other.description == this.description &&
          other.isDefault == this.isDefault &&
          other.isRemoved == this.isRemoved);
}

class UserCardsCompanion extends UpdateCompanion<UserCardData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> avatar;
  final Value<String?> crop;
  final Value<String> description;
  final Value<bool> isDefault;
  final Value<bool> isRemoved;
  const UserCardsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatar = const Value.absent(),
    this.crop = const Value.absent(),
    this.description = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isRemoved = const Value.absent(),
  });
  UserCardsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.avatar = const Value.absent(),
    this.crop = const Value.absent(),
    this.description = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isRemoved = const Value.absent(),
  }) : name = Value(name);
  static Insertable<UserCardData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? avatar,
    Expression<String>? crop,
    Expression<String>? description,
    Expression<bool>? isDefault,
    Expression<bool>? isRemoved,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatar != null) 'avatar': avatar,
      if (crop != null) 'crop': crop,
      if (description != null) 'description': description,
      if (isDefault != null) 'is_default': isDefault,
      if (isRemoved != null) 'is_removed': isRemoved,
    });
  }

  UserCardsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? avatar,
      Value<String?>? crop,
      Value<String>? description,
      Value<bool>? isDefault,
      Value<bool>? isRemoved}) {
    return UserCardsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      crop: crop ?? this.crop,
      description: description ?? this.description,
      isDefault: isDefault ?? this.isDefault,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatar.present) {
      map['avatar'] = Variable<String>(avatar.value);
    }
    if (crop.present) {
      map['crop'] = Variable<String>(crop.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isRemoved.present) {
      map['is_removed'] = Variable<bool>(isRemoved.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCardsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatar: $avatar, ')
          ..write('crop: $crop, ')
          ..write('description: $description, ')
          ..write('isDefault: $isDefault, ')
          ..write('isRemoved: $isRemoved')
          ..write(')'))
        .toString();
  }
}

class $ChatsTable extends Chats with TableInfo<$ChatsTable, ChatData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _charIdMeta = const VerificationMeta('charId');
  @override
  late final GeneratedColumn<int> charId = GeneratedColumn<int>(
      'char_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES chars (id) ON DELETE CASCADE'));
  static const VerificationMeta _userCardIdMeta =
      const VerificationMeta('userCardId');
  @override
  late final GeneratedColumn<int> userCardId = GeneratedColumn<int>(
      'user_card_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES user_cards (id) ON DELETE SET NULL'));
  static const VerificationMeta _backgroundMeta =
      const VerificationMeta('background');
  @override
  late final GeneratedColumn<String> background = GeneratedColumn<String>(
      'background', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, createdAt, charId, userCardId, background];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(Insertable<ChatData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('char_id')) {
      context.handle(_charIdMeta,
          charId.isAcceptableOrUnknown(data['char_id']!, _charIdMeta));
    } else if (isInserting) {
      context.missing(_charIdMeta);
    }
    if (data.containsKey('user_card_id')) {
      context.handle(
          _userCardIdMeta,
          userCardId.isAcceptableOrUnknown(
              data['user_card_id']!, _userCardIdMeta));
    }
    if (data.containsKey('background')) {
      context.handle(
          _backgroundMeta,
          background.isAcceptableOrUnknown(
              data['background']!, _backgroundMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      charId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}char_id'])!,
      userCardId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}user_card_id']),
      background: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}background']),
    );
  }

  @override
  $ChatsTable createAlias(String alias) {
    return $ChatsTable(attachedDatabase, alias);
  }
}

class ChatData extends DataClass implements Insertable<ChatData> {
  final int id;
  final String title;
  final DateTime createdAt;
  final int charId;
  final int? userCardId;
  final String? background;
  const ChatData(
      {required this.id,
      required this.title,
      required this.createdAt,
      required this.charId,
      this.userCardId,
      this.background});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['char_id'] = Variable<int>(charId);
    if (!nullToAbsent || userCardId != null) {
      map['user_card_id'] = Variable<int>(userCardId);
    }
    if (!nullToAbsent || background != null) {
      map['background'] = Variable<String>(background);
    }
    return map;
  }

  ChatsCompanion toCompanion(bool nullToAbsent) {
    return ChatsCompanion(
      id: Value(id),
      title: Value(title),
      createdAt: Value(createdAt),
      charId: Value(charId),
      userCardId: userCardId == null && nullToAbsent
          ? const Value.absent()
          : Value(userCardId),
      background: background == null && nullToAbsent
          ? const Value.absent()
          : Value(background),
    );
  }

  factory ChatData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      charId: serializer.fromJson<int>(json['charId']),
      userCardId: serializer.fromJson<int?>(json['userCardId']),
      background: serializer.fromJson<String?>(json['background']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'charId': serializer.toJson<int>(charId),
      'userCardId': serializer.toJson<int?>(userCardId),
      'background': serializer.toJson<String?>(background),
    };
  }

  ChatData copyWith(
          {int? id,
          String? title,
          DateTime? createdAt,
          int? charId,
          Value<int?> userCardId = const Value.absent(),
          Value<String?> background = const Value.absent()}) =>
      ChatData(
        id: id ?? this.id,
        title: title ?? this.title,
        createdAt: createdAt ?? this.createdAt,
        charId: charId ?? this.charId,
        userCardId: userCardId.present ? userCardId.value : this.userCardId,
        background: background.present ? background.value : this.background,
      );
  @override
  String toString() {
    return (StringBuffer('ChatData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('charId: $charId, ')
          ..write('userCardId: $userCardId, ')
          ..write('background: $background')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, createdAt, charId, userCardId, background);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatData &&
          other.id == this.id &&
          other.title == this.title &&
          other.createdAt == this.createdAt &&
          other.charId == this.charId &&
          other.userCardId == this.userCardId &&
          other.background == this.background);
}

class ChatsCompanion extends UpdateCompanion<ChatData> {
  final Value<int> id;
  final Value<String> title;
  final Value<DateTime> createdAt;
  final Value<int> charId;
  final Value<int?> userCardId;
  final Value<String?> background;
  const ChatsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.charId = const Value.absent(),
    this.userCardId = const Value.absent(),
    this.background = const Value.absent(),
  });
  ChatsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required DateTime createdAt,
    required int charId,
    this.userCardId = const Value.absent(),
    this.background = const Value.absent(),
  })  : title = Value(title),
        createdAt = Value(createdAt),
        charId = Value(charId);
  static Insertable<ChatData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
    Expression<int>? charId,
    Expression<int>? userCardId,
    Expression<String>? background,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
      if (charId != null) 'char_id': charId,
      if (userCardId != null) 'user_card_id': userCardId,
      if (background != null) 'background': background,
    });
  }

  ChatsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<DateTime>? createdAt,
      Value<int>? charId,
      Value<int?>? userCardId,
      Value<String?>? background}) {
    return ChatsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      charId: charId ?? this.charId,
      userCardId: userCardId ?? this.userCardId,
      background: background ?? this.background,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (charId.present) {
      map['char_id'] = Variable<int>(charId.value);
    }
    if (userCardId.present) {
      map['user_card_id'] = Variable<int>(userCardId.value);
    }
    if (background.present) {
      map['background'] = Variable<String>(background.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt, ')
          ..write('charId: $charId, ')
          ..write('userCardId: $userCardId, ')
          ..write('background: $background')
          ..write(')'))
        .toString();
  }
}

class $MessagesTable extends Messages
    with TableInfo<$MessagesTable, MessageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES chats (id) ON DELETE CASCADE'));
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumnWithTypeConverter<MessageRole, String> role =
      GeneratedColumn<String>('role', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<MessageRole>($MessagesTable.$converterrole);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modelNameMeta =
      const VerificationMeta('modelName');
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
      'model_name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        chatId,
        role,
        content,
        createdAt,
        parentId,
        imagePath,
        modelName,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(Insertable<MessageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    context.handle(_roleMeta, const VerificationResult.success());
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('model_name')) {
      context.handle(_modelNameMeta,
          modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_id'])!,
      role: $MessagesTable.$converterrole.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      modelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $MessagesTable createAlias(String alias) {
    return $MessagesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<MessageRole, String, String> $converterrole =
      const EnumNameConverter<MessageRole>(MessageRole.values);
}

class MessageData extends DataClass implements Insertable<MessageData> {
  final int id;
  final int chatId;
  final MessageRole role;
  final String content;
  final DateTime createdAt;
  final int? parentId;
  final String? imagePath;
  final String modelName;
  final bool isActive;
  const MessageData(
      {required this.id,
      required this.chatId,
      required this.role,
      required this.content,
      required this.createdAt,
      this.parentId,
      this.imagePath,
      required this.modelName,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<int>(chatId);
    {
      map['role'] = Variable<String>($MessagesTable.$converterrole.toSql(role));
    }
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['model_name'] = Variable<String>(modelName);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  MessagesCompanion toCompanion(bool nullToAbsent) {
    return MessagesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      modelName: Value(modelName),
      isActive: Value(isActive),
    );
  }

  factory MessageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageData(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      role: $MessagesTable.$converterrole
          .fromJson(serializer.fromJson<String>(json['role'])),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      modelName: serializer.fromJson<String>(json['modelName']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatId': serializer.toJson<int>(chatId),
      'role':
          serializer.toJson<String>($MessagesTable.$converterrole.toJson(role)),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'parentId': serializer.toJson<int?>(parentId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'modelName': serializer.toJson<String>(modelName),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MessageData copyWith(
          {int? id,
          int? chatId,
          MessageRole? role,
          String? content,
          DateTime? createdAt,
          Value<int?> parentId = const Value.absent(),
          Value<String?> imagePath = const Value.absent(),
          String? modelName,
          bool? isActive}) =>
      MessageData(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        role: role ?? this.role,
        content: content ?? this.content,
        createdAt: createdAt ?? this.createdAt,
        parentId: parentId.present ? parentId.value : this.parentId,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        modelName: modelName ?? this.modelName,
        isActive: isActive ?? this.isActive,
      );
  @override
  String toString() {
    return (StringBuffer('MessageData(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('parentId: $parentId, ')
          ..write('imagePath: $imagePath, ')
          ..write('modelName: $modelName, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, chatId, role, content, createdAt,
      parentId, imagePath, modelName, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MessageData &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAt == this.createdAt &&
          other.parentId == this.parentId &&
          other.imagePath == this.imagePath &&
          other.modelName == this.modelName &&
          other.isActive == this.isActive);
}

class MessagesCompanion extends UpdateCompanion<MessageData> {
  final Value<int> id;
  final Value<int> chatId;
  final Value<MessageRole> role;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int?> parentId;
  final Value<String?> imagePath;
  final Value<String> modelName;
  final Value<bool> isActive;
  const MessagesCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.parentId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.modelName = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  MessagesCompanion.insert({
    this.id = const Value.absent(),
    required int chatId,
    required MessageRole role,
    required String content,
    required DateTime createdAt,
    this.parentId = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.modelName = const Value.absent(),
    this.isActive = const Value.absent(),
  })  : chatId = Value(chatId),
        role = Value(role),
        content = Value(content),
        createdAt = Value(createdAt);
  static Insertable<MessageData> custom({
    Expression<int>? id,
    Expression<int>? chatId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? parentId,
    Expression<String>? imagePath,
    Expression<String>? modelName,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (parentId != null) 'parent_id': parentId,
      if (imagePath != null) 'image_path': imagePath,
      if (modelName != null) 'model_name': modelName,
      if (isActive != null) 'is_active': isActive,
    });
  }

  MessagesCompanion copyWith(
      {Value<int>? id,
      Value<int>? chatId,
      Value<MessageRole>? role,
      Value<String>? content,
      Value<DateTime>? createdAt,
      Value<int?>? parentId,
      Value<String?>? imagePath,
      Value<String>? modelName,
      Value<bool>? isActive}) {
    return MessagesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      parentId: parentId ?? this.parentId,
      imagePath: imagePath ?? this.imagePath,
      modelName: modelName ?? this.modelName,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (role.present) {
      map['role'] =
          Variable<String>($MessagesTable.$converterrole.toSql(role.value));
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MessagesCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('parentId: $parentId, ')
          ..write('imagePath: $imagePath, ')
          ..write('modelName: $modelName, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SummariesTable extends Summaries
    with TableInfo<$SummariesTable, SummaryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SummariesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
      'chat_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES chats (id) ON DELETE CASCADE'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _lastSummarizedMessageIdMeta =
      const VerificationMeta('lastSummarizedMessageId');
  @override
  late final GeneratedColumn<int> lastSummarizedMessageId =
      GeneratedColumn<int>('last_summarized_message_id', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, chatId, content, lastSummarizedMessageId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'summaries';
  @override
  VerificationContext validateIntegrity(Insertable<SummaryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(_chatIdMeta,
          chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta));
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    }
    if (data.containsKey('last_summarized_message_id')) {
      context.handle(
          _lastSummarizedMessageIdMeta,
          lastSummarizedMessageId.isAcceptableOrUnknown(
              data['last_summarized_message_id']!,
              _lastSummarizedMessageIdMeta));
    } else if (isInserting) {
      context.missing(_lastSummarizedMessageIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SummaryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SummaryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      chatId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chat_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      lastSummarizedMessageId: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}last_summarized_message_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SummariesTable createAlias(String alias) {
    return $SummariesTable(attachedDatabase, alias);
  }
}

class SummaryData extends DataClass implements Insertable<SummaryData> {
  final int id;
  final int chatId;
  final String content;
  final int lastSummarizedMessageId;
  final DateTime createdAt;
  const SummaryData(
      {required this.id,
      required this.chatId,
      required this.content,
      required this.lastSummarizedMessageId,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['chat_id'] = Variable<int>(chatId);
    map['content'] = Variable<String>(content);
    map['last_summarized_message_id'] = Variable<int>(lastSummarizedMessageId);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SummariesCompanion toCompanion(bool nullToAbsent) {
    return SummariesCompanion(
      id: Value(id),
      chatId: Value(chatId),
      content: Value(content),
      lastSummarizedMessageId: Value(lastSummarizedMessageId),
      createdAt: Value(createdAt),
    );
  }

  factory SummaryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SummaryData(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      content: serializer.fromJson<String>(json['content']),
      lastSummarizedMessageId:
          serializer.fromJson<int>(json['lastSummarizedMessageId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'chatId': serializer.toJson<int>(chatId),
      'content': serializer.toJson<String>(content),
      'lastSummarizedMessageId':
          serializer.toJson<int>(lastSummarizedMessageId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SummaryData copyWith(
          {int? id,
          int? chatId,
          String? content,
          int? lastSummarizedMessageId,
          DateTime? createdAt}) =>
      SummaryData(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        content: content ?? this.content,
        lastSummarizedMessageId:
            lastSummarizedMessageId ?? this.lastSummarizedMessageId,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('SummaryData(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('content: $content, ')
          ..write('lastSummarizedMessageId: $lastSummarizedMessageId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, chatId, content, lastSummarizedMessageId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SummaryData &&
          other.id == this.id &&
          other.chatId == this.chatId &&
          other.content == this.content &&
          other.lastSummarizedMessageId == this.lastSummarizedMessageId &&
          other.createdAt == this.createdAt);
}

class SummariesCompanion extends UpdateCompanion<SummaryData> {
  final Value<int> id;
  final Value<int> chatId;
  final Value<String> content;
  final Value<int> lastSummarizedMessageId;
  final Value<DateTime> createdAt;
  const SummariesCompanion({
    this.id = const Value.absent(),
    this.chatId = const Value.absent(),
    this.content = const Value.absent(),
    this.lastSummarizedMessageId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SummariesCompanion.insert({
    this.id = const Value.absent(),
    required int chatId,
    this.content = const Value.absent(),
    required int lastSummarizedMessageId,
    this.createdAt = const Value.absent(),
  })  : chatId = Value(chatId),
        lastSummarizedMessageId = Value(lastSummarizedMessageId);
  static Insertable<SummaryData> custom({
    Expression<int>? id,
    Expression<int>? chatId,
    Expression<String>? content,
    Expression<int>? lastSummarizedMessageId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (chatId != null) 'chat_id': chatId,
      if (content != null) 'content': content,
      if (lastSummarizedMessageId != null)
        'last_summarized_message_id': lastSummarizedMessageId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SummariesCompanion copyWith(
      {Value<int>? id,
      Value<int>? chatId,
      Value<String>? content,
      Value<int>? lastSummarizedMessageId,
      Value<DateTime>? createdAt}) {
    return SummariesCompanion(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      content: content ?? this.content,
      lastSummarizedMessageId:
          lastSummarizedMessageId ?? this.lastSummarizedMessageId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (chatId.present) {
      map['chat_id'] = Variable<int>(chatId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (lastSummarizedMessageId.present) {
      map['last_summarized_message_id'] =
          Variable<int>(lastSummarizedMessageId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SummariesCompanion(')
          ..write('id: $id, ')
          ..write('chatId: $chatId, ')
          ..write('content: $content, ')
          ..write('lastSummarizedMessageId: $lastSummarizedMessageId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SettingsTableTable extends SettingsTable
    with TableInfo<$SettingsTableTable, SettingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _modelNameMeta =
      const VerificationMeta('modelName');
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
      'model_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _visionModelNameMeta =
      const VerificationMeta('visionModelName');
  @override
  late final GeneratedColumn<String> visionModelName = GeneratedColumn<String>(
      'vision_model_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tokenizerPathMeta =
      const VerificationMeta('tokenizerPath');
  @override
  late final GeneratedColumn<String> tokenizerPath = GeneratedColumn<String>(
      'tokenizer_path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _maxContextTokensMeta =
      const VerificationMeta('maxContextTokens');
  @override
  late final GeneratedColumn<int> maxContextTokens = GeneratedColumn<int>(
      'max_context_tokens', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _temperatureMeta =
      const VerificationMeta('temperature');
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
      'temperature', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _minPMeta = const VerificationMeta('minP');
  @override
  late final GeneratedColumn<double> minP = GeneratedColumn<double>(
      'min_p', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _topPMeta = const VerificationMeta('topP');
  @override
  late final GeneratedColumn<double> topP = GeneratedColumn<double>(
      'top_p', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _repeatPenaltyMeta =
      const VerificationMeta('repeatPenalty');
  @override
  late final GeneratedColumn<double> repeatPenalty = GeneratedColumn<double>(
      'repeat_penalty', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _globalSystemPromptMeta =
      const VerificationMeta('globalSystemPrompt');
  @override
  late final GeneratedColumn<String> globalSystemPrompt =
      GeneratedColumn<String>('global_system_prompt', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _templateMeta =
      const VerificationMeta('template');
  @override
  late final GeneratedColumn<String> template = GeneratedColumn<String>(
      'template', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _providerMeta =
      const VerificationMeta('provider');
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
      'provider', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        modelName,
        visionModelName,
        tokenizerPath,
        maxContextTokens,
        temperature,
        minP,
        topP,
        repeatPenalty,
        globalSystemPrompt,
        template,
        provider
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(Insertable<SettingsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('model_name')) {
      context.handle(_modelNameMeta,
          modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta));
    } else if (isInserting) {
      context.missing(_modelNameMeta);
    }
    if (data.containsKey('vision_model_name')) {
      context.handle(
          _visionModelNameMeta,
          visionModelName.isAcceptableOrUnknown(
              data['vision_model_name']!, _visionModelNameMeta));
    } else if (isInserting) {
      context.missing(_visionModelNameMeta);
    }
    if (data.containsKey('tokenizer_path')) {
      context.handle(
          _tokenizerPathMeta,
          tokenizerPath.isAcceptableOrUnknown(
              data['tokenizer_path']!, _tokenizerPathMeta));
    } else if (isInserting) {
      context.missing(_tokenizerPathMeta);
    }
    if (data.containsKey('max_context_tokens')) {
      context.handle(
          _maxContextTokensMeta,
          maxContextTokens.isAcceptableOrUnknown(
              data['max_context_tokens']!, _maxContextTokensMeta));
    } else if (isInserting) {
      context.missing(_maxContextTokensMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
          _temperatureMeta,
          temperature.isAcceptableOrUnknown(
              data['temperature']!, _temperatureMeta));
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('min_p')) {
      context.handle(
          _minPMeta, minP.isAcceptableOrUnknown(data['min_p']!, _minPMeta));
    } else if (isInserting) {
      context.missing(_minPMeta);
    }
    if (data.containsKey('top_p')) {
      context.handle(
          _topPMeta, topP.isAcceptableOrUnknown(data['top_p']!, _topPMeta));
    } else if (isInserting) {
      context.missing(_topPMeta);
    }
    if (data.containsKey('repeat_penalty')) {
      context.handle(
          _repeatPenaltyMeta,
          repeatPenalty.isAcceptableOrUnknown(
              data['repeat_penalty']!, _repeatPenaltyMeta));
    } else if (isInserting) {
      context.missing(_repeatPenaltyMeta);
    }
    if (data.containsKey('global_system_prompt')) {
      context.handle(
          _globalSystemPromptMeta,
          globalSystemPrompt.isAcceptableOrUnknown(
              data['global_system_prompt']!, _globalSystemPromptMeta));
    } else if (isInserting) {
      context.missing(_globalSystemPromptMeta);
    }
    if (data.containsKey('template')) {
      context.handle(_templateMeta,
          template.isAcceptableOrUnknown(data['template']!, _templateMeta));
    } else if (isInserting) {
      context.missing(_templateMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(_providerMeta,
          provider.isAcceptableOrUnknown(data['provider']!, _providerMeta));
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      modelName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_name'])!,
      visionModelName: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}vision_model_name'])!,
      tokenizerPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tokenizer_path'])!,
      maxContextTokens: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}max_context_tokens'])!,
      temperature: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}temperature'])!,
      minP: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}min_p'])!,
      topP: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}top_p'])!,
      repeatPenalty: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}repeat_penalty'])!,
      globalSystemPrompt: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}global_system_prompt'])!,
      template: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}template'])!,
      provider: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}provider'])!,
    );
  }

  @override
  $SettingsTableTable createAlias(String alias) {
    return $SettingsTableTable(attachedDatabase, alias);
  }
}

class SettingsData extends DataClass implements Insertable<SettingsData> {
  final int id;
  final String modelName;
  final String visionModelName;
  final String tokenizerPath;
  final int maxContextTokens;
  final double temperature;
  final double minP;
  final double topP;
  final double repeatPenalty;
  final String globalSystemPrompt;
  final String template;
  final String provider;
  const SettingsData(
      {required this.id,
      required this.modelName,
      required this.visionModelName,
      required this.tokenizerPath,
      required this.maxContextTokens,
      required this.temperature,
      required this.minP,
      required this.topP,
      required this.repeatPenalty,
      required this.globalSystemPrompt,
      required this.template,
      required this.provider});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['model_name'] = Variable<String>(modelName);
    map['vision_model_name'] = Variable<String>(visionModelName);
    map['tokenizer_path'] = Variable<String>(tokenizerPath);
    map['max_context_tokens'] = Variable<int>(maxContextTokens);
    map['temperature'] = Variable<double>(temperature);
    map['min_p'] = Variable<double>(minP);
    map['top_p'] = Variable<double>(topP);
    map['repeat_penalty'] = Variable<double>(repeatPenalty);
    map['global_system_prompt'] = Variable<String>(globalSystemPrompt);
    map['template'] = Variable<String>(template);
    map['provider'] = Variable<String>(provider);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      modelName: Value(modelName),
      visionModelName: Value(visionModelName),
      tokenizerPath: Value(tokenizerPath),
      maxContextTokens: Value(maxContextTokens),
      temperature: Value(temperature),
      minP: Value(minP),
      topP: Value(topP),
      repeatPenalty: Value(repeatPenalty),
      globalSystemPrompt: Value(globalSystemPrompt),
      template: Value(template),
      provider: Value(provider),
    );
  }

  factory SettingsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsData(
      id: serializer.fromJson<int>(json['id']),
      modelName: serializer.fromJson<String>(json['modelName']),
      visionModelName: serializer.fromJson<String>(json['visionModelName']),
      tokenizerPath: serializer.fromJson<String>(json['tokenizerPath']),
      maxContextTokens: serializer.fromJson<int>(json['maxContextTokens']),
      temperature: serializer.fromJson<double>(json['temperature']),
      minP: serializer.fromJson<double>(json['minP']),
      topP: serializer.fromJson<double>(json['topP']),
      repeatPenalty: serializer.fromJson<double>(json['repeatPenalty']),
      globalSystemPrompt:
          serializer.fromJson<String>(json['globalSystemPrompt']),
      template: serializer.fromJson<String>(json['template']),
      provider: serializer.fromJson<String>(json['provider']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modelName': serializer.toJson<String>(modelName),
      'visionModelName': serializer.toJson<String>(visionModelName),
      'tokenizerPath': serializer.toJson<String>(tokenizerPath),
      'maxContextTokens': serializer.toJson<int>(maxContextTokens),
      'temperature': serializer.toJson<double>(temperature),
      'minP': serializer.toJson<double>(minP),
      'topP': serializer.toJson<double>(topP),
      'repeatPenalty': serializer.toJson<double>(repeatPenalty),
      'globalSystemPrompt': serializer.toJson<String>(globalSystemPrompt),
      'template': serializer.toJson<String>(template),
      'provider': serializer.toJson<String>(provider),
    };
  }

  SettingsData copyWith(
          {int? id,
          String? modelName,
          String? visionModelName,
          String? tokenizerPath,
          int? maxContextTokens,
          double? temperature,
          double? minP,
          double? topP,
          double? repeatPenalty,
          String? globalSystemPrompt,
          String? template,
          String? provider}) =>
      SettingsData(
        id: id ?? this.id,
        modelName: modelName ?? this.modelName,
        visionModelName: visionModelName ?? this.visionModelName,
        tokenizerPath: tokenizerPath ?? this.tokenizerPath,
        maxContextTokens: maxContextTokens ?? this.maxContextTokens,
        temperature: temperature ?? this.temperature,
        minP: minP ?? this.minP,
        topP: topP ?? this.topP,
        repeatPenalty: repeatPenalty ?? this.repeatPenalty,
        globalSystemPrompt: globalSystemPrompt ?? this.globalSystemPrompt,
        template: template ?? this.template,
        provider: provider ?? this.provider,
      );
  @override
  String toString() {
    return (StringBuffer('SettingsData(')
          ..write('id: $id, ')
          ..write('modelName: $modelName, ')
          ..write('visionModelName: $visionModelName, ')
          ..write('tokenizerPath: $tokenizerPath, ')
          ..write('maxContextTokens: $maxContextTokens, ')
          ..write('temperature: $temperature, ')
          ..write('minP: $minP, ')
          ..write('topP: $topP, ')
          ..write('repeatPenalty: $repeatPenalty, ')
          ..write('globalSystemPrompt: $globalSystemPrompt, ')
          ..write('template: $template, ')
          ..write('provider: $provider')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      modelName,
      visionModelName,
      tokenizerPath,
      maxContextTokens,
      temperature,
      minP,
      topP,
      repeatPenalty,
      globalSystemPrompt,
      template,
      provider);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsData &&
          other.id == this.id &&
          other.modelName == this.modelName &&
          other.visionModelName == this.visionModelName &&
          other.tokenizerPath == this.tokenizerPath &&
          other.maxContextTokens == this.maxContextTokens &&
          other.temperature == this.temperature &&
          other.minP == this.minP &&
          other.topP == this.topP &&
          other.repeatPenalty == this.repeatPenalty &&
          other.globalSystemPrompt == this.globalSystemPrompt &&
          other.template == this.template &&
          other.provider == this.provider);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsData> {
  final Value<int> id;
  final Value<String> modelName;
  final Value<String> visionModelName;
  final Value<String> tokenizerPath;
  final Value<int> maxContextTokens;
  final Value<double> temperature;
  final Value<double> minP;
  final Value<double> topP;
  final Value<double> repeatPenalty;
  final Value<String> globalSystemPrompt;
  final Value<String> template;
  final Value<String> provider;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.modelName = const Value.absent(),
    this.visionModelName = const Value.absent(),
    this.tokenizerPath = const Value.absent(),
    this.maxContextTokens = const Value.absent(),
    this.temperature = const Value.absent(),
    this.minP = const Value.absent(),
    this.topP = const Value.absent(),
    this.repeatPenalty = const Value.absent(),
    this.globalSystemPrompt = const Value.absent(),
    this.template = const Value.absent(),
    this.provider = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String modelName,
    required String visionModelName,
    required String tokenizerPath,
    required int maxContextTokens,
    required double temperature,
    required double minP,
    required double topP,
    required double repeatPenalty,
    required String globalSystemPrompt,
    required String template,
    required String provider,
  })  : modelName = Value(modelName),
        visionModelName = Value(visionModelName),
        tokenizerPath = Value(tokenizerPath),
        maxContextTokens = Value(maxContextTokens),
        temperature = Value(temperature),
        minP = Value(minP),
        topP = Value(topP),
        repeatPenalty = Value(repeatPenalty),
        globalSystemPrompt = Value(globalSystemPrompt),
        template = Value(template),
        provider = Value(provider);
  static Insertable<SettingsData> custom({
    Expression<int>? id,
    Expression<String>? modelName,
    Expression<String>? visionModelName,
    Expression<String>? tokenizerPath,
    Expression<int>? maxContextTokens,
    Expression<double>? temperature,
    Expression<double>? minP,
    Expression<double>? topP,
    Expression<double>? repeatPenalty,
    Expression<String>? globalSystemPrompt,
    Expression<String>? template,
    Expression<String>? provider,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelName != null) 'model_name': modelName,
      if (visionModelName != null) 'vision_model_name': visionModelName,
      if (tokenizerPath != null) 'tokenizer_path': tokenizerPath,
      if (maxContextTokens != null) 'max_context_tokens': maxContextTokens,
      if (temperature != null) 'temperature': temperature,
      if (minP != null) 'min_p': minP,
      if (topP != null) 'top_p': topP,
      if (repeatPenalty != null) 'repeat_penalty': repeatPenalty,
      if (globalSystemPrompt != null)
        'global_system_prompt': globalSystemPrompt,
      if (template != null) 'template': template,
      if (provider != null) 'provider': provider,
    });
  }

  SettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? modelName,
      Value<String>? visionModelName,
      Value<String>? tokenizerPath,
      Value<int>? maxContextTokens,
      Value<double>? temperature,
      Value<double>? minP,
      Value<double>? topP,
      Value<double>? repeatPenalty,
      Value<String>? globalSystemPrompt,
      Value<String>? template,
      Value<String>? provider}) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      visionModelName: visionModelName ?? this.visionModelName,
      tokenizerPath: tokenizerPath ?? this.tokenizerPath,
      maxContextTokens: maxContextTokens ?? this.maxContextTokens,
      temperature: temperature ?? this.temperature,
      minP: minP ?? this.minP,
      topP: topP ?? this.topP,
      repeatPenalty: repeatPenalty ?? this.repeatPenalty,
      globalSystemPrompt: globalSystemPrompt ?? this.globalSystemPrompt,
      template: template ?? this.template,
      provider: provider ?? this.provider,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (modelName.present) {
      map['model_name'] = Variable<String>(modelName.value);
    }
    if (visionModelName.present) {
      map['vision_model_name'] = Variable<String>(visionModelName.value);
    }
    if (tokenizerPath.present) {
      map['tokenizer_path'] = Variable<String>(tokenizerPath.value);
    }
    if (maxContextTokens.present) {
      map['max_context_tokens'] = Variable<int>(maxContextTokens.value);
    }
    if (temperature.present) {
      map['temperature'] = Variable<double>(temperature.value);
    }
    if (minP.present) {
      map['min_p'] = Variable<double>(minP.value);
    }
    if (topP.present) {
      map['top_p'] = Variable<double>(topP.value);
    }
    if (repeatPenalty.present) {
      map['repeat_penalty'] = Variable<double>(repeatPenalty.value);
    }
    if (globalSystemPrompt.present) {
      map['global_system_prompt'] = Variable<String>(globalSystemPrompt.value);
    }
    if (template.present) {
      map['template'] = Variable<String>(template.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('modelName: $modelName, ')
          ..write('visionModelName: $visionModelName, ')
          ..write('tokenizerPath: $tokenizerPath, ')
          ..write('maxContextTokens: $maxContextTokens, ')
          ..write('temperature: $temperature, ')
          ..write('minP: $minP, ')
          ..write('topP: $topP, ')
          ..write('repeatPenalty: $repeatPenalty, ')
          ..write('globalSystemPrompt: $globalSystemPrompt, ')
          ..write('template: $template, ')
          ..write('provider: $provider')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $CharsTable chars = $CharsTable(this);
  late final $LorebooksTable lorebooks = $LorebooksTable(this);
  late final $CharLorebooksTable charLorebooks = $CharLorebooksTable(this);
  late final $LoreEntriesTable loreEntries = $LoreEntriesTable(this);
  late final $UserCardsTable userCards = $UserCardsTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $SummariesTable summaries = $SummariesTable(this);
  late final $SettingsTableTable settingsTable = $SettingsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        chars,
        lorebooks,
        charLorebooks,
        loreEntries,
        userCards,
        chats,
        messages,
        summaries,
        settingsTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('chars',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('char_lorebooks', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('lorebooks',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('char_lorebooks', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('lorebooks',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('lore_entries', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('chars',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chats', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('user_cards',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('chats', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('chats',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('messages', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('chats',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('summaries', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
