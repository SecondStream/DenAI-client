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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
    'crop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backgroundMeta = const VerificationMeta(
    'background',
  );
  @override
  late final GeneratedColumn<String> background = GeneratedColumn<String>(
    'background',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _appearanceMeta = const VerificationMeta(
    'appearance',
  );
  @override
  late final GeneratedColumn<String> appearance = GeneratedColumn<String>(
    'appearance',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _personalityMeta = const VerificationMeta(
    'personality',
  );
  @override
  late final GeneratedColumn<String> personality = GeneratedColumn<String>(
    'personality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _scenarioMeta = const VerificationMeta(
    'scenario',
  );
  @override
  late final GeneratedColumn<String> scenario = GeneratedColumn<String>(
    'scenario',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _greetingMeta = const VerificationMeta(
    'greeting',
  );
  @override
  late final GeneratedColumn<String> greeting = GeneratedColumn<String>(
    'greeting',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _promptMeta = const VerificationMeta('prompt');
  @override
  late final GeneratedColumn<String> prompt = GeneratedColumn<String>(
    'prompt',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
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
    prompt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chars';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('crop')) {
      context.handle(
        _cropMeta,
        crop.isAcceptableOrUnknown(data['crop']!, _cropMeta),
      );
    }
    if (data.containsKey('background')) {
      context.handle(
        _backgroundMeta,
        background.isAcceptableOrUnknown(data['background']!, _backgroundMeta),
      );
    }
    if (data.containsKey('appearance')) {
      context.handle(
        _appearanceMeta,
        appearance.isAcceptableOrUnknown(data['appearance']!, _appearanceMeta),
      );
    }
    if (data.containsKey('personality')) {
      context.handle(
        _personalityMeta,
        personality.isAcceptableOrUnknown(
          data['personality']!,
          _personalityMeta,
        ),
      );
    }
    if (data.containsKey('scenario')) {
      context.handle(
        _scenarioMeta,
        scenario.isAcceptableOrUnknown(data['scenario']!, _scenarioMeta),
      );
    }
    if (data.containsKey('greeting')) {
      context.handle(
        _greetingMeta,
        greeting.isAcceptableOrUnknown(data['greeting']!, _greetingMeta),
      );
    }
    if (data.containsKey('prompt')) {
      context.handle(
        _promptMeta,
        prompt.isAcceptableOrUnknown(data['prompt']!, _promptMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CharData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      crop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop'],
      ),
      background: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background'],
      ),
      appearance: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appearance'],
      )!,
      personality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personality'],
      )!,
      scenario: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scenario'],
      )!,
      greeting: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}greeting'],
      )!,
      prompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt'],
      )!,
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
  const CharData({
    required this.id,
    required this.name,
    this.avatar,
    this.crop,
    this.background,
    required this.appearance,
    required this.personality,
    required this.scenario,
    required this.greeting,
    required this.prompt,
  });
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
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
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

  factory CharData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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

  CharData copyWith({
    int? id,
    String? name,
    Value<String?> avatar = const Value.absent(),
    Value<String?> crop = const Value.absent(),
    Value<String?> background = const Value.absent(),
    String? appearance,
    String? personality,
    String? scenario,
    String? greeting,
    String? prompt,
  }) => CharData(
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
  CharData copyWithCompanion(CharsCompanion data) {
    return CharData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      crop: data.crop.present ? data.crop.value : this.crop,
      background: data.background.present
          ? data.background.value
          : this.background,
      appearance: data.appearance.present
          ? data.appearance.value
          : this.appearance,
      personality: data.personality.present
          ? data.personality.value
          : this.personality,
      scenario: data.scenario.present ? data.scenario.value : this.scenario,
      greeting: data.greeting.present ? data.greeting.value : this.greeting,
      prompt: data.prompt.present ? data.prompt.value : this.prompt,
    );
  }

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
  int get hashCode => Object.hash(
    id,
    name,
    avatar,
    crop,
    background,
    appearance,
    personality,
    scenario,
    greeting,
    prompt,
  );
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

  CharsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? avatar,
    Value<String?>? crop,
    Value<String?>? background,
    Value<String>? appearance,
    Value<String>? personality,
    Value<String>? scenario,
    Value<String>? greeting,
    Value<String>? prompt,
  }) {
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aboutMeta = const VerificationMeta('about');
  @override
  late final GeneratedColumn<String> about = GeneratedColumn<String>(
    'about',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _coverMeta = const VerificationMeta('cover');
  @override
  late final GeneratedColumn<String> cover = GeneratedColumn<String>(
    'cover',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
    'crop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, about, cover, crop];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lorebooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<LorebookData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('about')) {
      context.handle(
        _aboutMeta,
        about.isAcceptableOrUnknown(data['about']!, _aboutMeta),
      );
    }
    if (data.containsKey('cover')) {
      context.handle(
        _coverMeta,
        cover.isAcceptableOrUnknown(data['cover']!, _coverMeta),
      );
    } else if (isInserting) {
      context.missing(_coverMeta);
    }
    if (data.containsKey('crop')) {
      context.handle(
        _cropMeta,
        crop.isAcceptableOrUnknown(data['crop']!, _cropMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LorebookData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LorebookData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      about: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}about'],
      )!,
      cover: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover'],
      )!,
      crop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop'],
      ),
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
  const LorebookData({
    required this.id,
    required this.name,
    required this.about,
    required this.cover,
    this.crop,
  });
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

  factory LorebookData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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

  LorebookData copyWith({
    int? id,
    String? name,
    String? about,
    String? cover,
    Value<String?> crop = const Value.absent(),
  }) => LorebookData(
    id: id ?? this.id,
    name: name ?? this.name,
    about: about ?? this.about,
    cover: cover ?? this.cover,
    crop: crop.present ? crop.value : this.crop,
  );
  LorebookData copyWithCompanion(LorebooksCompanion data) {
    return LorebookData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      about: data.about.present ? data.about.value : this.about,
      cover: data.cover.present ? data.cover.value : this.cover,
      crop: data.crop.present ? data.crop.value : this.crop,
    );
  }

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
  }) : name = Value(name),
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

  LorebooksCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? about,
    Value<String>? cover,
    Value<String?>? crop,
  }) {
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
    'char_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chars (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _lorebookIdMeta = const VerificationMeta(
    'lorebookId',
  );
  @override
  late final GeneratedColumn<int> lorebookId = GeneratedColumn<int>(
    'lorebook_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lorebooks (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [charId, lorebookId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'char_lorebooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharLorebook> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('char_id')) {
      context.handle(
        _charIdMeta,
        charId.isAcceptableOrUnknown(data['char_id']!, _charIdMeta),
      );
    } else if (isInserting) {
      context.missing(_charIdMeta);
    }
    if (data.containsKey('lorebook_id')) {
      context.handle(
        _lorebookIdMeta,
        lorebookId.isAcceptableOrUnknown(data['lorebook_id']!, _lorebookIdMeta),
      );
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
      charId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}char_id'],
      )!,
      lorebookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lorebook_id'],
      )!,
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

  factory CharLorebook.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
  CharLorebook copyWithCompanion(CharLorebooksCompanion data) {
    return CharLorebook(
      charId: data.charId.present ? data.charId.value : this.charId,
      lorebookId: data.lorebookId.present
          ? data.lorebookId.value
          : this.lorebookId,
    );
  }

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
  }) : charId = Value(charId),
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

  CharLorebooksCompanion copyWith({
    Value<int>? charId,
    Value<int>? lorebookId,
    Value<int>? rowid,
  }) {
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
  static const VerificationMeta _lorebookIdMeta = const VerificationMeta(
    'lorebookId',
  );
  @override
  late final GeneratedColumn<int> lorebookId = GeneratedColumn<int>(
    'lorebook_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES lorebooks (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, lorebookId, title, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lore_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LoreEntryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lorebook_id')) {
      context.handle(
        _lorebookIdMeta,
        lorebookId.isAcceptableOrUnknown(data['lorebook_id']!, _lorebookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lorebookIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LoreEntryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LoreEntryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      lorebookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lorebook_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
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
  const LoreEntryData({
    required this.id,
    required this.lorebookId,
    required this.title,
    required this.content,
  });
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

  factory LoreEntryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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

  LoreEntryData copyWith({
    int? id,
    int? lorebookId,
    String? title,
    String? content,
  }) => LoreEntryData(
    id: id ?? this.id,
    lorebookId: lorebookId ?? this.lorebookId,
    title: title ?? this.title,
    content: content ?? this.content,
  );
  LoreEntryData copyWithCompanion(LoreEntriesCompanion data) {
    return LoreEntryData(
      id: data.id.present ? data.id.value : this.id,
      lorebookId: data.lorebookId.present
          ? data.lorebookId.value
          : this.lorebookId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
    );
  }

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
  }) : lorebookId = Value(lorebookId),
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

  LoreEntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? lorebookId,
    Value<String>? title,
    Value<String>? content,
  }) {
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarMeta = const VerificationMeta('avatar');
  @override
  late final GeneratedColumn<String> avatar = GeneratedColumn<String>(
    'avatar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cropMeta = const VerificationMeta('crop');
  @override
  late final GeneratedColumn<String> crop = GeneratedColumn<String>(
    'crop',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isRemovedMeta = const VerificationMeta(
    'isRemoved',
  );
  @override
  late final GeneratedColumn<bool> isRemoved = GeneratedColumn<bool>(
    'is_removed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_removed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatar,
    crop,
    description,
    isDefault,
    isRemoved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_cards';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserCardData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar')) {
      context.handle(
        _avatarMeta,
        avatar.isAcceptableOrUnknown(data['avatar']!, _avatarMeta),
      );
    }
    if (data.containsKey('crop')) {
      context.handle(
        _cropMeta,
        crop.isAcceptableOrUnknown(data['crop']!, _cropMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_removed')) {
      context.handle(
        _isRemovedMeta,
        isRemoved.isAcceptableOrUnknown(data['is_removed']!, _isRemovedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCardData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCardData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatar: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar'],
      ),
      crop: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crop'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isRemoved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_removed'],
      )!,
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
  const UserCardData({
    required this.id,
    required this.name,
    this.avatar,
    this.crop,
    required this.description,
    required this.isDefault,
    required this.isRemoved,
  });
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
      avatar: avatar == null && nullToAbsent
          ? const Value.absent()
          : Value(avatar),
      crop: crop == null && nullToAbsent ? const Value.absent() : Value(crop),
      description: Value(description),
      isDefault: Value(isDefault),
      isRemoved: Value(isRemoved),
    );
  }

  factory UserCardData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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

  UserCardData copyWith({
    int? id,
    String? name,
    Value<String?> avatar = const Value.absent(),
    Value<String?> crop = const Value.absent(),
    String? description,
    bool? isDefault,
    bool? isRemoved,
  }) => UserCardData(
    id: id ?? this.id,
    name: name ?? this.name,
    avatar: avatar.present ? avatar.value : this.avatar,
    crop: crop.present ? crop.value : this.crop,
    description: description ?? this.description,
    isDefault: isDefault ?? this.isDefault,
    isRemoved: isRemoved ?? this.isRemoved,
  );
  UserCardData copyWithCompanion(UserCardsCompanion data) {
    return UserCardData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatar: data.avatar.present ? data.avatar.value : this.avatar,
      crop: data.crop.present ? data.crop.value : this.crop,
      description: data.description.present
          ? data.description.value
          : this.description,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isRemoved: data.isRemoved.present ? data.isRemoved.value : this.isRemoved,
    );
  }

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

  UserCardsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? avatar,
    Value<String?>? crop,
    Value<String>? description,
    Value<bool>? isDefault,
    Value<bool>? isRemoved,
  }) {
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _charIdMeta = const VerificationMeta('charId');
  @override
  late final GeneratedColumn<int> charId = GeneratedColumn<int>(
    'char_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chars (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _userCardIdMeta = const VerificationMeta(
    'userCardId',
  );
  @override
  late final GeneratedColumn<int> userCardId = GeneratedColumn<int>(
    'user_card_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_cards (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _backgroundMeta = const VerificationMeta(
    'background',
  );
  @override
  late final GeneratedColumn<String> background = GeneratedColumn<String>(
    'background',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    createdAt,
    charId,
    userCardId,
    background,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chats';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChatData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('char_id')) {
      context.handle(
        _charIdMeta,
        charId.isAcceptableOrUnknown(data['char_id']!, _charIdMeta),
      );
    } else if (isInserting) {
      context.missing(_charIdMeta);
    }
    if (data.containsKey('user_card_id')) {
      context.handle(
        _userCardIdMeta,
        userCardId.isAcceptableOrUnknown(
          data['user_card_id']!,
          _userCardIdMeta,
        ),
      );
    }
    if (data.containsKey('background')) {
      context.handle(
        _backgroundMeta,
        background.isAcceptableOrUnknown(data['background']!, _backgroundMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      charId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}char_id'],
      )!,
      userCardId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_card_id'],
      ),
      background: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}background'],
      ),
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
  const ChatData({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.charId,
    this.userCardId,
    this.background,
  });
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

  factory ChatData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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

  ChatData copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    int? charId,
    Value<int?> userCardId = const Value.absent(),
    Value<String?> background = const Value.absent(),
  }) => ChatData(
    id: id ?? this.id,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
    charId: charId ?? this.charId,
    userCardId: userCardId.present ? userCardId.value : this.userCardId,
    background: background.present ? background.value : this.background,
  );
  ChatData copyWithCompanion(ChatsCompanion data) {
    return ChatData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      charId: data.charId.present ? data.charId.value : this.charId,
      userCardId: data.userCardId.present
          ? data.userCardId.value
          : this.userCardId,
      background: data.background.present
          ? data.background.value
          : this.background,
    );
  }

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
  }) : title = Value(title),
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

  ChatsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<DateTime>? createdAt,
    Value<int>? charId,
    Value<int?>? userCardId,
    Value<String?>? background,
  }) {
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
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chats (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<MessageRole, String> role =
      GeneratedColumn<String>(
        'role',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<MessageRole>($MessagesTable.$converterrole);
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelNameMeta = const VerificationMeta(
    'modelName',
  );
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
    'model_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
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
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<MessageData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('model_name')) {
      context.handle(
        _modelNameMeta,
        modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MessageData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chat_id'],
      )!,
      role: $MessagesTable.$converterrole.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}role'],
        )!,
      ),
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      modelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_name'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
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
  const MessageData({
    required this.id,
    required this.chatId,
    required this.role,
    required this.content,
    required this.createdAt,
    this.parentId,
    this.imagePath,
    required this.modelName,
    required this.isActive,
  });
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

  factory MessageData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MessageData(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      role: $MessagesTable.$converterrole.fromJson(
        serializer.fromJson<String>(json['role']),
      ),
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
      'role': serializer.toJson<String>(
        $MessagesTable.$converterrole.toJson(role),
      ),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'parentId': serializer.toJson<int?>(parentId),
      'imagePath': serializer.toJson<String?>(imagePath),
      'modelName': serializer.toJson<String>(modelName),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  MessageData copyWith({
    int? id,
    int? chatId,
    MessageRole? role,
    String? content,
    DateTime? createdAt,
    Value<int?> parentId = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    String? modelName,
    bool? isActive,
  }) => MessageData(
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
  MessageData copyWithCompanion(MessagesCompanion data) {
    return MessageData(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

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
  int get hashCode => Object.hash(
    id,
    chatId,
    role,
    content,
    createdAt,
    parentId,
    imagePath,
    modelName,
    isActive,
  );
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
  }) : chatId = Value(chatId),
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

  MessagesCompanion copyWith({
    Value<int>? id,
    Value<int>? chatId,
    Value<MessageRole>? role,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<int?>? parentId,
    Value<String?>? imagePath,
    Value<String>? modelName,
    Value<bool>? isActive,
  }) {
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
      map['role'] = Variable<String>(
        $MessagesTable.$converterrole.toSql(role.value),
      );
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
  static const VerificationMeta _chatIdMeta = const VerificationMeta('chatId');
  @override
  late final GeneratedColumn<int> chatId = GeneratedColumn<int>(
    'chat_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES chats (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _lastSummarizedMessageIdMeta =
      const VerificationMeta('lastSummarizedMessageId');
  @override
  late final GeneratedColumn<int> lastSummarizedMessageId =
      GeneratedColumn<int>(
        'last_summarized_message_id',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    chatId,
    content,
    lastSummarizedMessageId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'summaries';
  @override
  VerificationContext validateIntegrity(
    Insertable<SummaryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('chat_id')) {
      context.handle(
        _chatIdMeta,
        chatId.isAcceptableOrUnknown(data['chat_id']!, _chatIdMeta),
      );
    } else if (isInserting) {
      context.missing(_chatIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('last_summarized_message_id')) {
      context.handle(
        _lastSummarizedMessageIdMeta,
        lastSummarizedMessageId.isAcceptableOrUnknown(
          data['last_summarized_message_id']!,
          _lastSummarizedMessageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSummarizedMessageIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SummaryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SummaryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      chatId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chat_id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      lastSummarizedMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_summarized_message_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
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
  const SummaryData({
    required this.id,
    required this.chatId,
    required this.content,
    required this.lastSummarizedMessageId,
    required this.createdAt,
  });
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

  factory SummaryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SummaryData(
      id: serializer.fromJson<int>(json['id']),
      chatId: serializer.fromJson<int>(json['chatId']),
      content: serializer.fromJson<String>(json['content']),
      lastSummarizedMessageId: serializer.fromJson<int>(
        json['lastSummarizedMessageId'],
      ),
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
      'lastSummarizedMessageId': serializer.toJson<int>(
        lastSummarizedMessageId,
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SummaryData copyWith({
    int? id,
    int? chatId,
    String? content,
    int? lastSummarizedMessageId,
    DateTime? createdAt,
  }) => SummaryData(
    id: id ?? this.id,
    chatId: chatId ?? this.chatId,
    content: content ?? this.content,
    lastSummarizedMessageId:
        lastSummarizedMessageId ?? this.lastSummarizedMessageId,
    createdAt: createdAt ?? this.createdAt,
  );
  SummaryData copyWithCompanion(SummariesCompanion data) {
    return SummaryData(
      id: data.id.present ? data.id.value : this.id,
      chatId: data.chatId.present ? data.chatId.value : this.chatId,
      content: data.content.present ? data.content.value : this.content,
      lastSummarizedMessageId: data.lastSummarizedMessageId.present
          ? data.lastSummarizedMessageId.value
          : this.lastSummarizedMessageId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

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
  }) : chatId = Value(chatId),
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

  SummariesCompanion copyWith({
    Value<int>? id,
    Value<int>? chatId,
    Value<String>? content,
    Value<int>? lastSummarizedMessageId,
    Value<DateTime>? createdAt,
  }) {
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
      map['last_summarized_message_id'] = Variable<int>(
        lastSummarizedMessageId.value,
      );
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

class $ProvidersTable extends Providers
    with TableInfo<$ProvidersTable, ProviderData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProvidersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _additionalArgsMeta = const VerificationMeta(
    'additionalArgs',
  );
  @override
  late final GeneratedColumn<String> additionalArgs = GeneratedColumn<String>(
    'additional_args',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, url, additionalArgs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'providers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProviderData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('additional_args')) {
      context.handle(
        _additionalArgsMeta,
        additionalArgs.isAcceptableOrUnknown(
          data['additional_args']!,
          _additionalArgsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProviderData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProviderData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      additionalArgs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}additional_args'],
      )!,
    );
  }

  @override
  $ProvidersTable createAlias(String alias) {
    return $ProvidersTable(attachedDatabase, alias);
  }
}

class ProviderData extends DataClass implements Insertable<ProviderData> {
  final int id;
  final String name;
  final String url;
  final String additionalArgs;
  const ProviderData({
    required this.id,
    required this.name,
    required this.url,
    required this.additionalArgs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['additional_args'] = Variable<String>(additionalArgs);
    return map;
  }

  ProvidersCompanion toCompanion(bool nullToAbsent) {
    return ProvidersCompanion(
      id: Value(id),
      name: Value(name),
      url: Value(url),
      additionalArgs: Value(additionalArgs),
    );
  }

  factory ProviderData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProviderData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      additionalArgs: serializer.fromJson<String>(json['additionalArgs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'additionalArgs': serializer.toJson<String>(additionalArgs),
    };
  }

  ProviderData copyWith({
    int? id,
    String? name,
    String? url,
    String? additionalArgs,
  }) => ProviderData(
    id: id ?? this.id,
    name: name ?? this.name,
    url: url ?? this.url,
    additionalArgs: additionalArgs ?? this.additionalArgs,
  );
  ProviderData copyWithCompanion(ProvidersCompanion data) {
    return ProviderData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      additionalArgs: data.additionalArgs.present
          ? data.additionalArgs.value
          : this.additionalArgs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProviderData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('additionalArgs: $additionalArgs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, url, additionalArgs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProviderData &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.additionalArgs == this.additionalArgs);
}

class ProvidersCompanion extends UpdateCompanion<ProviderData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> url;
  final Value<String> additionalArgs;
  const ProvidersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.additionalArgs = const Value.absent(),
  });
  ProvidersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String url,
    this.additionalArgs = const Value.absent(),
  }) : name = Value(name),
       url = Value(url);
  static Insertable<ProviderData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? additionalArgs,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (additionalArgs != null) 'additional_args': additionalArgs,
    });
  }

  ProvidersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? url,
    Value<String>? additionalArgs,
  }) {
    return ProvidersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      additionalArgs: additionalArgs ?? this.additionalArgs,
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
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (additionalArgs.present) {
      map['additional_args'] = Variable<String>(additionalArgs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProvidersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('additionalArgs: $additionalArgs')
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
  static const VerificationMeta _modelNameMeta = const VerificationMeta(
    'modelName',
  );
  @override
  late final GeneratedColumn<String> modelName = GeneratedColumn<String>(
    'model_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visionModelNameMeta = const VerificationMeta(
    'visionModelName',
  );
  @override
  late final GeneratedColumn<String> visionModelName = GeneratedColumn<String>(
    'vision_model_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _embeddingModelNameMeta =
      const VerificationMeta('embeddingModelName');
  @override
  late final GeneratedColumn<String> embeddingModelName =
      GeneratedColumn<String>(
        'embedding_model_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _tokenizerPathMeta = const VerificationMeta(
    'tokenizerPath',
  );
  @override
  late final GeneratedColumn<String> tokenizerPath = GeneratedColumn<String>(
    'tokenizer_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxContextTokensMeta = const VerificationMeta(
    'maxContextTokens',
  );
  @override
  late final GeneratedColumn<int> maxContextTokens = GeneratedColumn<int>(
    'max_context_tokens',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _temperatureMeta = const VerificationMeta(
    'temperature',
  );
  @override
  late final GeneratedColumn<double> temperature = GeneratedColumn<double>(
    'temperature',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minPMeta = const VerificationMeta('minP');
  @override
  late final GeneratedColumn<double> minP = GeneratedColumn<double>(
    'min_p',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _topPMeta = const VerificationMeta('topP');
  @override
  late final GeneratedColumn<double> topP = GeneratedColumn<double>(
    'top_p',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repeatPenaltyMeta = const VerificationMeta(
    'repeatPenalty',
  );
  @override
  late final GeneratedColumn<double> repeatPenalty = GeneratedColumn<double>(
    'repeat_penalty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _globalSystemPromptMeta =
      const VerificationMeta('globalSystemPrompt');
  @override
  late final GeneratedColumn<String> globalSystemPrompt =
      GeneratedColumn<String>(
        'global_system_prompt',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _templateMeta = const VerificationMeta(
    'template',
  );
  @override
  late final GeneratedColumn<String> template = GeneratedColumn<String>(
    'template',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerIdMeta = const VerificationMeta(
    'providerId',
  );
  @override
  late final GeneratedColumn<int> providerId = GeneratedColumn<int>(
    'provider_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES providers (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    modelName,
    visionModelName,
    embeddingModelName,
    tokenizerPath,
    maxContextTokens,
    temperature,
    minP,
    topP,
    repeatPenalty,
    globalSystemPrompt,
    template,
    providerId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingsData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('model_name')) {
      context.handle(
        _modelNameMeta,
        modelName.isAcceptableOrUnknown(data['model_name']!, _modelNameMeta),
      );
    } else if (isInserting) {
      context.missing(_modelNameMeta);
    }
    if (data.containsKey('vision_model_name')) {
      context.handle(
        _visionModelNameMeta,
        visionModelName.isAcceptableOrUnknown(
          data['vision_model_name']!,
          _visionModelNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_visionModelNameMeta);
    }
    if (data.containsKey('embedding_model_name')) {
      context.handle(
        _embeddingModelNameMeta,
        embeddingModelName.isAcceptableOrUnknown(
          data['embedding_model_name']!,
          _embeddingModelNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_embeddingModelNameMeta);
    }
    if (data.containsKey('tokenizer_path')) {
      context.handle(
        _tokenizerPathMeta,
        tokenizerPath.isAcceptableOrUnknown(
          data['tokenizer_path']!,
          _tokenizerPathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tokenizerPathMeta);
    }
    if (data.containsKey('max_context_tokens')) {
      context.handle(
        _maxContextTokensMeta,
        maxContextTokens.isAcceptableOrUnknown(
          data['max_context_tokens']!,
          _maxContextTokensMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxContextTokensMeta);
    }
    if (data.containsKey('temperature')) {
      context.handle(
        _temperatureMeta,
        temperature.isAcceptableOrUnknown(
          data['temperature']!,
          _temperatureMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_temperatureMeta);
    }
    if (data.containsKey('min_p')) {
      context.handle(
        _minPMeta,
        minP.isAcceptableOrUnknown(data['min_p']!, _minPMeta),
      );
    } else if (isInserting) {
      context.missing(_minPMeta);
    }
    if (data.containsKey('top_p')) {
      context.handle(
        _topPMeta,
        topP.isAcceptableOrUnknown(data['top_p']!, _topPMeta),
      );
    } else if (isInserting) {
      context.missing(_topPMeta);
    }
    if (data.containsKey('repeat_penalty')) {
      context.handle(
        _repeatPenaltyMeta,
        repeatPenalty.isAcceptableOrUnknown(
          data['repeat_penalty']!,
          _repeatPenaltyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_repeatPenaltyMeta);
    }
    if (data.containsKey('global_system_prompt')) {
      context.handle(
        _globalSystemPromptMeta,
        globalSystemPrompt.isAcceptableOrUnknown(
          data['global_system_prompt']!,
          _globalSystemPromptMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_globalSystemPromptMeta);
    }
    if (data.containsKey('template')) {
      context.handle(
        _templateMeta,
        template.isAcceptableOrUnknown(data['template']!, _templateMeta),
      );
    } else if (isInserting) {
      context.missing(_templateMeta);
    }
    if (data.containsKey('provider_id')) {
      context.handle(
        _providerIdMeta,
        providerId.isAcceptableOrUnknown(data['provider_id']!, _providerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_providerIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SettingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      modelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_name'],
      )!,
      visionModelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}vision_model_name'],
      )!,
      embeddingModelName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}embedding_model_name'],
      )!,
      tokenizerPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tokenizer_path'],
      )!,
      maxContextTokens: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_context_tokens'],
      )!,
      temperature: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}temperature'],
      )!,
      minP: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_p'],
      )!,
      topP: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}top_p'],
      )!,
      repeatPenalty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}repeat_penalty'],
      )!,
      globalSystemPrompt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}global_system_prompt'],
      )!,
      template: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template'],
      )!,
      providerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}provider_id'],
      )!,
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
  final String embeddingModelName;
  final String tokenizerPath;
  final int maxContextTokens;
  final double temperature;
  final double minP;
  final double topP;
  final double repeatPenalty;
  final String globalSystemPrompt;
  final String template;
  final int providerId;
  const SettingsData({
    required this.id,
    required this.modelName,
    required this.visionModelName,
    required this.embeddingModelName,
    required this.tokenizerPath,
    required this.maxContextTokens,
    required this.temperature,
    required this.minP,
    required this.topP,
    required this.repeatPenalty,
    required this.globalSystemPrompt,
    required this.template,
    required this.providerId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['model_name'] = Variable<String>(modelName);
    map['vision_model_name'] = Variable<String>(visionModelName);
    map['embedding_model_name'] = Variable<String>(embeddingModelName);
    map['tokenizer_path'] = Variable<String>(tokenizerPath);
    map['max_context_tokens'] = Variable<int>(maxContextTokens);
    map['temperature'] = Variable<double>(temperature);
    map['min_p'] = Variable<double>(minP);
    map['top_p'] = Variable<double>(topP);
    map['repeat_penalty'] = Variable<double>(repeatPenalty);
    map['global_system_prompt'] = Variable<String>(globalSystemPrompt);
    map['template'] = Variable<String>(template);
    map['provider_id'] = Variable<int>(providerId);
    return map;
  }

  SettingsTableCompanion toCompanion(bool nullToAbsent) {
    return SettingsTableCompanion(
      id: Value(id),
      modelName: Value(modelName),
      visionModelName: Value(visionModelName),
      embeddingModelName: Value(embeddingModelName),
      tokenizerPath: Value(tokenizerPath),
      maxContextTokens: Value(maxContextTokens),
      temperature: Value(temperature),
      minP: Value(minP),
      topP: Value(topP),
      repeatPenalty: Value(repeatPenalty),
      globalSystemPrompt: Value(globalSystemPrompt),
      template: Value(template),
      providerId: Value(providerId),
    );
  }

  factory SettingsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingsData(
      id: serializer.fromJson<int>(json['id']),
      modelName: serializer.fromJson<String>(json['modelName']),
      visionModelName: serializer.fromJson<String>(json['visionModelName']),
      embeddingModelName: serializer.fromJson<String>(
        json['embeddingModelName'],
      ),
      tokenizerPath: serializer.fromJson<String>(json['tokenizerPath']),
      maxContextTokens: serializer.fromJson<int>(json['maxContextTokens']),
      temperature: serializer.fromJson<double>(json['temperature']),
      minP: serializer.fromJson<double>(json['minP']),
      topP: serializer.fromJson<double>(json['topP']),
      repeatPenalty: serializer.fromJson<double>(json['repeatPenalty']),
      globalSystemPrompt: serializer.fromJson<String>(
        json['globalSystemPrompt'],
      ),
      template: serializer.fromJson<String>(json['template']),
      providerId: serializer.fromJson<int>(json['providerId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'modelName': serializer.toJson<String>(modelName),
      'visionModelName': serializer.toJson<String>(visionModelName),
      'embeddingModelName': serializer.toJson<String>(embeddingModelName),
      'tokenizerPath': serializer.toJson<String>(tokenizerPath),
      'maxContextTokens': serializer.toJson<int>(maxContextTokens),
      'temperature': serializer.toJson<double>(temperature),
      'minP': serializer.toJson<double>(minP),
      'topP': serializer.toJson<double>(topP),
      'repeatPenalty': serializer.toJson<double>(repeatPenalty),
      'globalSystemPrompt': serializer.toJson<String>(globalSystemPrompt),
      'template': serializer.toJson<String>(template),
      'providerId': serializer.toJson<int>(providerId),
    };
  }

  SettingsData copyWith({
    int? id,
    String? modelName,
    String? visionModelName,
    String? embeddingModelName,
    String? tokenizerPath,
    int? maxContextTokens,
    double? temperature,
    double? minP,
    double? topP,
    double? repeatPenalty,
    String? globalSystemPrompt,
    String? template,
    int? providerId,
  }) => SettingsData(
    id: id ?? this.id,
    modelName: modelName ?? this.modelName,
    visionModelName: visionModelName ?? this.visionModelName,
    embeddingModelName: embeddingModelName ?? this.embeddingModelName,
    tokenizerPath: tokenizerPath ?? this.tokenizerPath,
    maxContextTokens: maxContextTokens ?? this.maxContextTokens,
    temperature: temperature ?? this.temperature,
    minP: minP ?? this.minP,
    topP: topP ?? this.topP,
    repeatPenalty: repeatPenalty ?? this.repeatPenalty,
    globalSystemPrompt: globalSystemPrompt ?? this.globalSystemPrompt,
    template: template ?? this.template,
    providerId: providerId ?? this.providerId,
  );
  SettingsData copyWithCompanion(SettingsTableCompanion data) {
    return SettingsData(
      id: data.id.present ? data.id.value : this.id,
      modelName: data.modelName.present ? data.modelName.value : this.modelName,
      visionModelName: data.visionModelName.present
          ? data.visionModelName.value
          : this.visionModelName,
      embeddingModelName: data.embeddingModelName.present
          ? data.embeddingModelName.value
          : this.embeddingModelName,
      tokenizerPath: data.tokenizerPath.present
          ? data.tokenizerPath.value
          : this.tokenizerPath,
      maxContextTokens: data.maxContextTokens.present
          ? data.maxContextTokens.value
          : this.maxContextTokens,
      temperature: data.temperature.present
          ? data.temperature.value
          : this.temperature,
      minP: data.minP.present ? data.minP.value : this.minP,
      topP: data.topP.present ? data.topP.value : this.topP,
      repeatPenalty: data.repeatPenalty.present
          ? data.repeatPenalty.value
          : this.repeatPenalty,
      globalSystemPrompt: data.globalSystemPrompt.present
          ? data.globalSystemPrompt.value
          : this.globalSystemPrompt,
      template: data.template.present ? data.template.value : this.template,
      providerId: data.providerId.present
          ? data.providerId.value
          : this.providerId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingsData(')
          ..write('id: $id, ')
          ..write('modelName: $modelName, ')
          ..write('visionModelName: $visionModelName, ')
          ..write('embeddingModelName: $embeddingModelName, ')
          ..write('tokenizerPath: $tokenizerPath, ')
          ..write('maxContextTokens: $maxContextTokens, ')
          ..write('temperature: $temperature, ')
          ..write('minP: $minP, ')
          ..write('topP: $topP, ')
          ..write('repeatPenalty: $repeatPenalty, ')
          ..write('globalSystemPrompt: $globalSystemPrompt, ')
          ..write('template: $template, ')
          ..write('providerId: $providerId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    modelName,
    visionModelName,
    embeddingModelName,
    tokenizerPath,
    maxContextTokens,
    temperature,
    minP,
    topP,
    repeatPenalty,
    globalSystemPrompt,
    template,
    providerId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingsData &&
          other.id == this.id &&
          other.modelName == this.modelName &&
          other.visionModelName == this.visionModelName &&
          other.embeddingModelName == this.embeddingModelName &&
          other.tokenizerPath == this.tokenizerPath &&
          other.maxContextTokens == this.maxContextTokens &&
          other.temperature == this.temperature &&
          other.minP == this.minP &&
          other.topP == this.topP &&
          other.repeatPenalty == this.repeatPenalty &&
          other.globalSystemPrompt == this.globalSystemPrompt &&
          other.template == this.template &&
          other.providerId == this.providerId);
}

class SettingsTableCompanion extends UpdateCompanion<SettingsData> {
  final Value<int> id;
  final Value<String> modelName;
  final Value<String> visionModelName;
  final Value<String> embeddingModelName;
  final Value<String> tokenizerPath;
  final Value<int> maxContextTokens;
  final Value<double> temperature;
  final Value<double> minP;
  final Value<double> topP;
  final Value<double> repeatPenalty;
  final Value<String> globalSystemPrompt;
  final Value<String> template;
  final Value<int> providerId;
  const SettingsTableCompanion({
    this.id = const Value.absent(),
    this.modelName = const Value.absent(),
    this.visionModelName = const Value.absent(),
    this.embeddingModelName = const Value.absent(),
    this.tokenizerPath = const Value.absent(),
    this.maxContextTokens = const Value.absent(),
    this.temperature = const Value.absent(),
    this.minP = const Value.absent(),
    this.topP = const Value.absent(),
    this.repeatPenalty = const Value.absent(),
    this.globalSystemPrompt = const Value.absent(),
    this.template = const Value.absent(),
    this.providerId = const Value.absent(),
  });
  SettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String modelName,
    required String visionModelName,
    required String embeddingModelName,
    required String tokenizerPath,
    required int maxContextTokens,
    required double temperature,
    required double minP,
    required double topP,
    required double repeatPenalty,
    required String globalSystemPrompt,
    required String template,
    required int providerId,
  }) : modelName = Value(modelName),
       visionModelName = Value(visionModelName),
       embeddingModelName = Value(embeddingModelName),
       tokenizerPath = Value(tokenizerPath),
       maxContextTokens = Value(maxContextTokens),
       temperature = Value(temperature),
       minP = Value(minP),
       topP = Value(topP),
       repeatPenalty = Value(repeatPenalty),
       globalSystemPrompt = Value(globalSystemPrompt),
       template = Value(template),
       providerId = Value(providerId);
  static Insertable<SettingsData> custom({
    Expression<int>? id,
    Expression<String>? modelName,
    Expression<String>? visionModelName,
    Expression<String>? embeddingModelName,
    Expression<String>? tokenizerPath,
    Expression<int>? maxContextTokens,
    Expression<double>? temperature,
    Expression<double>? minP,
    Expression<double>? topP,
    Expression<double>? repeatPenalty,
    Expression<String>? globalSystemPrompt,
    Expression<String>? template,
    Expression<int>? providerId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modelName != null) 'model_name': modelName,
      if (visionModelName != null) 'vision_model_name': visionModelName,
      if (embeddingModelName != null)
        'embedding_model_name': embeddingModelName,
      if (tokenizerPath != null) 'tokenizer_path': tokenizerPath,
      if (maxContextTokens != null) 'max_context_tokens': maxContextTokens,
      if (temperature != null) 'temperature': temperature,
      if (minP != null) 'min_p': minP,
      if (topP != null) 'top_p': topP,
      if (repeatPenalty != null) 'repeat_penalty': repeatPenalty,
      if (globalSystemPrompt != null)
        'global_system_prompt': globalSystemPrompt,
      if (template != null) 'template': template,
      if (providerId != null) 'provider_id': providerId,
    });
  }

  SettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? modelName,
    Value<String>? visionModelName,
    Value<String>? embeddingModelName,
    Value<String>? tokenizerPath,
    Value<int>? maxContextTokens,
    Value<double>? temperature,
    Value<double>? minP,
    Value<double>? topP,
    Value<double>? repeatPenalty,
    Value<String>? globalSystemPrompt,
    Value<String>? template,
    Value<int>? providerId,
  }) {
    return SettingsTableCompanion(
      id: id ?? this.id,
      modelName: modelName ?? this.modelName,
      visionModelName: visionModelName ?? this.visionModelName,
      embeddingModelName: embeddingModelName ?? this.embeddingModelName,
      tokenizerPath: tokenizerPath ?? this.tokenizerPath,
      maxContextTokens: maxContextTokens ?? this.maxContextTokens,
      temperature: temperature ?? this.temperature,
      minP: minP ?? this.minP,
      topP: topP ?? this.topP,
      repeatPenalty: repeatPenalty ?? this.repeatPenalty,
      globalSystemPrompt: globalSystemPrompt ?? this.globalSystemPrompt,
      template: template ?? this.template,
      providerId: providerId ?? this.providerId,
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
    if (embeddingModelName.present) {
      map['embedding_model_name'] = Variable<String>(embeddingModelName.value);
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
    if (providerId.present) {
      map['provider_id'] = Variable<int>(providerId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('modelName: $modelName, ')
          ..write('visionModelName: $visionModelName, ')
          ..write('embeddingModelName: $embeddingModelName, ')
          ..write('tokenizerPath: $tokenizerPath, ')
          ..write('maxContextTokens: $maxContextTokens, ')
          ..write('temperature: $temperature, ')
          ..write('minP: $minP, ')
          ..write('topP: $topP, ')
          ..write('repeatPenalty: $repeatPenalty, ')
          ..write('globalSystemPrompt: $globalSystemPrompt, ')
          ..write('template: $template, ')
          ..write('providerId: $providerId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CharsTable chars = $CharsTable(this);
  late final $LorebooksTable lorebooks = $LorebooksTable(this);
  late final $CharLorebooksTable charLorebooks = $CharLorebooksTable(this);
  late final $LoreEntriesTable loreEntries = $LoreEntriesTable(this);
  late final $UserCardsTable userCards = $UserCardsTable(this);
  late final $ChatsTable chats = $ChatsTable(this);
  late final $MessagesTable messages = $MessagesTable(this);
  late final $SummariesTable summaries = $SummariesTable(this);
  late final $ProvidersTable providers = $ProvidersTable(this);
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
    providers,
    settingsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chars',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('char_lorebooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lorebooks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('char_lorebooks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'lorebooks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('lore_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chars',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chats', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'user_cards',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('chats', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chats',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('messages', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'chats',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('summaries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CharsTableCreateCompanionBuilder =
    CharsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> avatar,
      Value<String?> crop,
      Value<String?> background,
      Value<String> appearance,
      Value<String> personality,
      Value<String> scenario,
      Value<String> greeting,
      Value<String> prompt,
    });
typedef $$CharsTableUpdateCompanionBuilder =
    CharsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> avatar,
      Value<String?> crop,
      Value<String?> background,
      Value<String> appearance,
      Value<String> personality,
      Value<String> scenario,
      Value<String> greeting,
      Value<String> prompt,
    });

final class $$CharsTableReferences
    extends BaseReferences<_$AppDatabase, $CharsTable, CharData> {
  $$CharsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CharLorebooksTable, List<CharLorebook>>
  _charLorebooksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.charLorebooks,
    aliasName: 'chars__id__char_lorebooks__char_id',
  );

  $$CharLorebooksTableProcessedTableManager get charLorebooksRefs {
    final manager = $$CharLorebooksTableTableManager(
      $_db,
      $_db.charLorebooks,
    ).filter((f) => f.charId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_charLorebooksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChatsTable, List<ChatData>> _chatsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chats,
    aliasName: 'chars__id__chats__char_id',
  );

  $$ChatsTableProcessedTableManager get chatsRefs {
    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.charId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CharsTableFilterComposer extends Composer<_$AppDatabase, $CharsTable> {
  $$CharsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personality => $composableBuilder(
    column: $table.personality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scenario => $composableBuilder(
    column: $table.scenario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get greeting => $composableBuilder(
    column: $table.greeting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> charLorebooksRefs(
    Expression<bool> Function($$CharLorebooksTableFilterComposer f) f,
  ) {
    final $$CharLorebooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charLorebooks,
      getReferencedColumn: (t) => t.charId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharLorebooksTableFilterComposer(
            $db: $db,
            $table: $db.charLorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> chatsRefs(
    Expression<bool> Function($$ChatsTableFilterComposer f) f,
  ) {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.charId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharsTableOrderingComposer
    extends Composer<_$AppDatabase, $CharsTable> {
  $$CharsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personality => $composableBuilder(
    column: $table.personality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scenario => $composableBuilder(
    column: $table.scenario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get greeting => $composableBuilder(
    column: $table.greeting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prompt => $composableBuilder(
    column: $table.prompt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CharsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharsTable> {
  $$CharsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get crop =>
      $composableBuilder(column: $table.crop, builder: (column) => column);

  GeneratedColumn<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appearance => $composableBuilder(
    column: $table.appearance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personality => $composableBuilder(
    column: $table.personality,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scenario =>
      $composableBuilder(column: $table.scenario, builder: (column) => column);

  GeneratedColumn<String> get greeting =>
      $composableBuilder(column: $table.greeting, builder: (column) => column);

  GeneratedColumn<String> get prompt =>
      $composableBuilder(column: $table.prompt, builder: (column) => column);

  Expression<T> charLorebooksRefs<T extends Object>(
    Expression<T> Function($$CharLorebooksTableAnnotationComposer a) f,
  ) {
    final $$CharLorebooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charLorebooks,
      getReferencedColumn: (t) => t.charId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharLorebooksTableAnnotationComposer(
            $db: $db,
            $table: $db.charLorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> chatsRefs<T extends Object>(
    Expression<T> Function($$ChatsTableAnnotationComposer a) f,
  ) {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.charId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CharsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharsTable,
          CharData,
          $$CharsTableFilterComposer,
          $$CharsTableOrderingComposer,
          $$CharsTableAnnotationComposer,
          $$CharsTableCreateCompanionBuilder,
          $$CharsTableUpdateCompanionBuilder,
          (CharData, $$CharsTableReferences),
          CharData,
          PrefetchHooks Function({bool charLorebooksRefs, bool chatsRefs})
        > {
  $$CharsTableTableManager(_$AppDatabase db, $CharsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<String?> crop = const Value.absent(),
                Value<String?> background = const Value.absent(),
                Value<String> appearance = const Value.absent(),
                Value<String> personality = const Value.absent(),
                Value<String> scenario = const Value.absent(),
                Value<String> greeting = const Value.absent(),
                Value<String> prompt = const Value.absent(),
              }) => CharsCompanion(
                id: id,
                name: name,
                avatar: avatar,
                crop: crop,
                background: background,
                appearance: appearance,
                personality: personality,
                scenario: scenario,
                greeting: greeting,
                prompt: prompt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> avatar = const Value.absent(),
                Value<String?> crop = const Value.absent(),
                Value<String?> background = const Value.absent(),
                Value<String> appearance = const Value.absent(),
                Value<String> personality = const Value.absent(),
                Value<String> scenario = const Value.absent(),
                Value<String> greeting = const Value.absent(),
                Value<String> prompt = const Value.absent(),
              }) => CharsCompanion.insert(
                id: id,
                name: name,
                avatar: avatar,
                crop: crop,
                background: background,
                appearance: appearance,
                personality: personality,
                scenario: scenario,
                greeting: greeting,
                prompt: prompt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharsTable, CharData>(table),
                  $$CharsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({charLorebooksRefs = false, chatsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (charLorebooksRefs) db.charLorebooks,
                    if (chatsRefs) db.chats,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (charLorebooksRefs)
                        await $_getPrefetchedDataByColumns<
                          CharData,
                          $CharsTable,
                          CharLorebook,
                          $CharLorebooksTable
                        >(
                          currentTable: table,
                          referencedTable: $$CharsTableReferences
                              ._charLorebooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharsTableReferences(
                                db,
                                table,
                                p0,
                              ).charLorebooksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'char_id',
                          typedResults: items,
                        ),
                      if (chatsRefs)
                        await $_getPrefetchedDataByColumns<
                          CharData,
                          $CharsTable,
                          ChatData,
                          $ChatsTable
                        >(
                          currentTable: table,
                          referencedTable: $$CharsTableReferences
                              ._chatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CharsTableReferences(db, table, p0).chatsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'char_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CharsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharsTable,
      CharData,
      $$CharsTableFilterComposer,
      $$CharsTableOrderingComposer,
      $$CharsTableAnnotationComposer,
      $$CharsTableCreateCompanionBuilder,
      $$CharsTableUpdateCompanionBuilder,
      (CharData, $$CharsTableReferences),
      CharData,
      PrefetchHooks Function({bool charLorebooksRefs, bool chatsRefs})
    >;
typedef $$LorebooksTableCreateCompanionBuilder =
    LorebooksCompanion Function({
      Value<int> id,
      required String name,
      Value<String> about,
      required String cover,
      Value<String?> crop,
    });
typedef $$LorebooksTableUpdateCompanionBuilder =
    LorebooksCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> about,
      Value<String> cover,
      Value<String?> crop,
    });

final class $$LorebooksTableReferences
    extends BaseReferences<_$AppDatabase, $LorebooksTable, LorebookData> {
  $$LorebooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CharLorebooksTable, List<CharLorebook>>
  _charLorebooksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.charLorebooks,
    aliasName: 'lorebooks__id__char_lorebooks__lorebook_id',
  );

  $$CharLorebooksTableProcessedTableManager get charLorebooksRefs {
    final manager = $$CharLorebooksTableTableManager(
      $_db,
      $_db.charLorebooks,
    ).filter((f) => f.lorebookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_charLorebooksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LoreEntriesTable, List<LoreEntryData>>
  _loreEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.loreEntries,
    aliasName: 'lorebooks__id__lore_entries__lorebook_id',
  );

  $$LoreEntriesTableProcessedTableManager get loreEntriesRefs {
    final manager = $$LoreEntriesTableTableManager(
      $_db,
      $_db.loreEntries,
    ).filter((f) => f.lorebookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loreEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LorebooksTableFilterComposer
    extends Composer<_$AppDatabase, $LorebooksTable> {
  $$LorebooksTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get about => $composableBuilder(
    column: $table.about,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cover => $composableBuilder(
    column: $table.cover,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> charLorebooksRefs(
    Expression<bool> Function($$CharLorebooksTableFilterComposer f) f,
  ) {
    final $$CharLorebooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charLorebooks,
      getReferencedColumn: (t) => t.lorebookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharLorebooksTableFilterComposer(
            $db: $db,
            $table: $db.charLorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> loreEntriesRefs(
    Expression<bool> Function($$LoreEntriesTableFilterComposer f) f,
  ) {
    final $$LoreEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loreEntries,
      getReferencedColumn: (t) => t.lorebookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoreEntriesTableFilterComposer(
            $db: $db,
            $table: $db.loreEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LorebooksTableOrderingComposer
    extends Composer<_$AppDatabase, $LorebooksTable> {
  $$LorebooksTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get about => $composableBuilder(
    column: $table.about,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cover => $composableBuilder(
    column: $table.cover,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LorebooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $LorebooksTable> {
  $$LorebooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get about =>
      $composableBuilder(column: $table.about, builder: (column) => column);

  GeneratedColumn<String> get cover =>
      $composableBuilder(column: $table.cover, builder: (column) => column);

  GeneratedColumn<String> get crop =>
      $composableBuilder(column: $table.crop, builder: (column) => column);

  Expression<T> charLorebooksRefs<T extends Object>(
    Expression<T> Function($$CharLorebooksTableAnnotationComposer a) f,
  ) {
    final $$CharLorebooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.charLorebooks,
      getReferencedColumn: (t) => t.lorebookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharLorebooksTableAnnotationComposer(
            $db: $db,
            $table: $db.charLorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> loreEntriesRefs<T extends Object>(
    Expression<T> Function($$LoreEntriesTableAnnotationComposer a) f,
  ) {
    final $$LoreEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loreEntries,
      getReferencedColumn: (t) => t.lorebookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoreEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.loreEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LorebooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LorebooksTable,
          LorebookData,
          $$LorebooksTableFilterComposer,
          $$LorebooksTableOrderingComposer,
          $$LorebooksTableAnnotationComposer,
          $$LorebooksTableCreateCompanionBuilder,
          $$LorebooksTableUpdateCompanionBuilder,
          (LorebookData, $$LorebooksTableReferences),
          LorebookData,
          PrefetchHooks Function({bool charLorebooksRefs, bool loreEntriesRefs})
        > {
  $$LorebooksTableTableManager(_$AppDatabase db, $LorebooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LorebooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LorebooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LorebooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> about = const Value.absent(),
                Value<String> cover = const Value.absent(),
                Value<String?> crop = const Value.absent(),
              }) => LorebooksCompanion(
                id: id,
                name: name,
                about: about,
                cover: cover,
                crop: crop,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String> about = const Value.absent(),
                required String cover,
                Value<String?> crop = const Value.absent(),
              }) => LorebooksCompanion.insert(
                id: id,
                name: name,
                about: about,
                cover: cover,
                crop: crop,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LorebooksTable, LorebookData>(table),
                  $$LorebooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({charLorebooksRefs = false, loreEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (charLorebooksRefs) db.charLorebooks,
                    if (loreEntriesRefs) db.loreEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (charLorebooksRefs)
                        await $_getPrefetchedDataByColumns<
                          LorebookData,
                          $LorebooksTable,
                          CharLorebook,
                          $CharLorebooksTable
                        >(
                          currentTable: table,
                          referencedTable: $$LorebooksTableReferences
                              ._charLorebooksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LorebooksTableReferences(
                                db,
                                table,
                                p0,
                              ).charLorebooksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'lorebook_id',
                          typedResults: items,
                        ),
                      if (loreEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          LorebookData,
                          $LorebooksTable,
                          LoreEntryData,
                          $LoreEntriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$LorebooksTableReferences
                              ._loreEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LorebooksTableReferences(
                                db,
                                table,
                                p0,
                              ).loreEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'lorebook_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LorebooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LorebooksTable,
      LorebookData,
      $$LorebooksTableFilterComposer,
      $$LorebooksTableOrderingComposer,
      $$LorebooksTableAnnotationComposer,
      $$LorebooksTableCreateCompanionBuilder,
      $$LorebooksTableUpdateCompanionBuilder,
      (LorebookData, $$LorebooksTableReferences),
      LorebookData,
      PrefetchHooks Function({bool charLorebooksRefs, bool loreEntriesRefs})
    >;
typedef $$CharLorebooksTableCreateCompanionBuilder =
    CharLorebooksCompanion Function({
      required int charId,
      required int lorebookId,
      Value<int> rowid,
    });
typedef $$CharLorebooksTableUpdateCompanionBuilder =
    CharLorebooksCompanion Function({
      Value<int> charId,
      Value<int> lorebookId,
      Value<int> rowid,
    });

final class $$CharLorebooksTableReferences
    extends BaseReferences<_$AppDatabase, $CharLorebooksTable, CharLorebook> {
  $$CharLorebooksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CharsTable _charIdTable(_$AppDatabase db) =>
      db.chars.createAlias('char_lorebooks__char_id__chars__id');

  $$CharsTableProcessedTableManager get charId {
    final $_column = $_itemColumn<int>('char_id')!;

    final manager = $$CharsTableTableManager(
      $_db,
      $_db.chars,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_charIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LorebooksTable _lorebookIdTable(_$AppDatabase db) =>
      db.lorebooks.createAlias('char_lorebooks__lorebook_id__lorebooks__id');

  $$LorebooksTableProcessedTableManager get lorebookId {
    final $_column = $_itemColumn<int>('lorebook_id')!;

    final manager = $$LorebooksTableTableManager(
      $_db,
      $_db.lorebooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lorebookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharLorebooksTableFilterComposer
    extends Composer<_$AppDatabase, $CharLorebooksTable> {
  $$CharLorebooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CharsTableFilterComposer get charId {
    final $$CharsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.charId,
      referencedTable: $db.chars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharsTableFilterComposer(
            $db: $db,
            $table: $db.chars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LorebooksTableFilterComposer get lorebookId {
    final $$LorebooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lorebookId,
      referencedTable: $db.lorebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LorebooksTableFilterComposer(
            $db: $db,
            $table: $db.lorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharLorebooksTableOrderingComposer
    extends Composer<_$AppDatabase, $CharLorebooksTable> {
  $$CharLorebooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CharsTableOrderingComposer get charId {
    final $$CharsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.charId,
      referencedTable: $db.chars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharsTableOrderingComposer(
            $db: $db,
            $table: $db.chars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LorebooksTableOrderingComposer get lorebookId {
    final $$LorebooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lorebookId,
      referencedTable: $db.lorebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LorebooksTableOrderingComposer(
            $db: $db,
            $table: $db.lorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharLorebooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharLorebooksTable> {
  $$CharLorebooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CharsTableAnnotationComposer get charId {
    final $$CharsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.charId,
      referencedTable: $db.chars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharsTableAnnotationComposer(
            $db: $db,
            $table: $db.chars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LorebooksTableAnnotationComposer get lorebookId {
    final $$LorebooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lorebookId,
      referencedTable: $db.lorebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LorebooksTableAnnotationComposer(
            $db: $db,
            $table: $db.lorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharLorebooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharLorebooksTable,
          CharLorebook,
          $$CharLorebooksTableFilterComposer,
          $$CharLorebooksTableOrderingComposer,
          $$CharLorebooksTableAnnotationComposer,
          $$CharLorebooksTableCreateCompanionBuilder,
          $$CharLorebooksTableUpdateCompanionBuilder,
          (CharLorebook, $$CharLorebooksTableReferences),
          CharLorebook,
          PrefetchHooks Function({bool charId, bool lorebookId})
        > {
  $$CharLorebooksTableTableManager(_$AppDatabase db, $CharLorebooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharLorebooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharLorebooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharLorebooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> charId = const Value.absent(),
                Value<int> lorebookId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharLorebooksCompanion(
                charId: charId,
                lorebookId: lorebookId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int charId,
                required int lorebookId,
                Value<int> rowid = const Value.absent(),
              }) => CharLorebooksCompanion.insert(
                charId: charId,
                lorebookId: lorebookId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CharLorebooksTable, CharLorebook>(table),
                  $$CharLorebooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({charId = false, lorebookId = false}) {
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
                    if (charId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.charId,
                                referencedTable: $$CharLorebooksTableReferences
                                    ._charIdTable(db),
                                referencedColumn: $$CharLorebooksTableReferences
                                    ._charIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (lorebookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lorebookId,
                                referencedTable: $$CharLorebooksTableReferences
                                    ._lorebookIdTable(db),
                                referencedColumn: $$CharLorebooksTableReferences
                                    ._lorebookIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$CharLorebooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharLorebooksTable,
      CharLorebook,
      $$CharLorebooksTableFilterComposer,
      $$CharLorebooksTableOrderingComposer,
      $$CharLorebooksTableAnnotationComposer,
      $$CharLorebooksTableCreateCompanionBuilder,
      $$CharLorebooksTableUpdateCompanionBuilder,
      (CharLorebook, $$CharLorebooksTableReferences),
      CharLorebook,
      PrefetchHooks Function({bool charId, bool lorebookId})
    >;
typedef $$LoreEntriesTableCreateCompanionBuilder =
    LoreEntriesCompanion Function({
      Value<int> id,
      required int lorebookId,
      required String title,
      Value<String> content,
    });
typedef $$LoreEntriesTableUpdateCompanionBuilder =
    LoreEntriesCompanion Function({
      Value<int> id,
      Value<int> lorebookId,
      Value<String> title,
      Value<String> content,
    });

final class $$LoreEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $LoreEntriesTable, LoreEntryData> {
  $$LoreEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $LorebooksTable _lorebookIdTable(_$AppDatabase db) =>
      db.lorebooks.createAlias('lore_entries__lorebook_id__lorebooks__id');

  $$LorebooksTableProcessedTableManager get lorebookId {
    final $_column = $_itemColumn<int>('lorebook_id')!;

    final manager = $$LorebooksTableTableManager(
      $_db,
      $_db.lorebooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_lorebookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LoreEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LoreEntriesTable> {
  $$LoreEntriesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  $$LorebooksTableFilterComposer get lorebookId {
    final $$LorebooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lorebookId,
      referencedTable: $db.lorebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LorebooksTableFilterComposer(
            $db: $db,
            $table: $db.lorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoreEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LoreEntriesTable> {
  $$LoreEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  $$LorebooksTableOrderingComposer get lorebookId {
    final $$LorebooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lorebookId,
      referencedTable: $db.lorebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LorebooksTableOrderingComposer(
            $db: $db,
            $table: $db.lorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoreEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoreEntriesTable> {
  $$LoreEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  $$LorebooksTableAnnotationComposer get lorebookId {
    final $$LorebooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.lorebookId,
      referencedTable: $db.lorebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LorebooksTableAnnotationComposer(
            $db: $db,
            $table: $db.lorebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoreEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoreEntriesTable,
          LoreEntryData,
          $$LoreEntriesTableFilterComposer,
          $$LoreEntriesTableOrderingComposer,
          $$LoreEntriesTableAnnotationComposer,
          $$LoreEntriesTableCreateCompanionBuilder,
          $$LoreEntriesTableUpdateCompanionBuilder,
          (LoreEntryData, $$LoreEntriesTableReferences),
          LoreEntryData,
          PrefetchHooks Function({bool lorebookId})
        > {
  $$LoreEntriesTableTableManager(_$AppDatabase db, $LoreEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoreEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoreEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoreEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> lorebookId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
              }) => LoreEntriesCompanion(
                id: id,
                lorebookId: lorebookId,
                title: title,
                content: content,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int lorebookId,
                required String title,
                Value<String> content = const Value.absent(),
              }) => LoreEntriesCompanion.insert(
                id: id,
                lorebookId: lorebookId,
                title: title,
                content: content,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LoreEntriesTable, LoreEntryData>(table),
                  $$LoreEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({lorebookId = false}) {
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
                    if (lorebookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.lorebookId,
                                referencedTable: $$LoreEntriesTableReferences
                                    ._lorebookIdTable(db),
                                referencedColumn: $$LoreEntriesTableReferences
                                    ._lorebookIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$LoreEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoreEntriesTable,
      LoreEntryData,
      $$LoreEntriesTableFilterComposer,
      $$LoreEntriesTableOrderingComposer,
      $$LoreEntriesTableAnnotationComposer,
      $$LoreEntriesTableCreateCompanionBuilder,
      $$LoreEntriesTableUpdateCompanionBuilder,
      (LoreEntryData, $$LoreEntriesTableReferences),
      LoreEntryData,
      PrefetchHooks Function({bool lorebookId})
    >;
typedef $$UserCardsTableCreateCompanionBuilder =
    UserCardsCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> avatar,
      Value<String?> crop,
      Value<String> description,
      Value<bool> isDefault,
      Value<bool> isRemoved,
    });
typedef $$UserCardsTableUpdateCompanionBuilder =
    UserCardsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> avatar,
      Value<String?> crop,
      Value<String> description,
      Value<bool> isDefault,
      Value<bool> isRemoved,
    });

final class $$UserCardsTableReferences
    extends BaseReferences<_$AppDatabase, $UserCardsTable, UserCardData> {
  $$UserCardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChatsTable, List<ChatData>> _chatsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.chats,
    aliasName: 'user_cards__id__chats__user_card_id',
  );

  $$ChatsTableProcessedTableManager get chatsRefs {
    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.userCardId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserCardsTableFilterComposer
    extends Composer<_$AppDatabase, $UserCardsTable> {
  $$UserCardsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRemoved => $composableBuilder(
    column: $table.isRemoved,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> chatsRefs(
    Expression<bool> Function($$ChatsTableFilterComposer f) f,
  ) {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.userCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserCardsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCardsTable> {
  $$UserCardsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatar => $composableBuilder(
    column: $table.avatar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crop => $composableBuilder(
    column: $table.crop,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRemoved => $composableBuilder(
    column: $table.isRemoved,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserCardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCardsTable> {
  $$UserCardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get avatar =>
      $composableBuilder(column: $table.avatar, builder: (column) => column);

  GeneratedColumn<String> get crop =>
      $composableBuilder(column: $table.crop, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isRemoved =>
      $composableBuilder(column: $table.isRemoved, builder: (column) => column);

  Expression<T> chatsRefs<T extends Object>(
    Expression<T> Function($$ChatsTableAnnotationComposer a) f,
  ) {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.userCardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserCardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserCardsTable,
          UserCardData,
          $$UserCardsTableFilterComposer,
          $$UserCardsTableOrderingComposer,
          $$UserCardsTableAnnotationComposer,
          $$UserCardsTableCreateCompanionBuilder,
          $$UserCardsTableUpdateCompanionBuilder,
          (UserCardData, $$UserCardsTableReferences),
          UserCardData,
          PrefetchHooks Function({bool chatsRefs})
        > {
  $$UserCardsTableTableManager(_$AppDatabase db, $UserCardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> avatar = const Value.absent(),
                Value<String?> crop = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isRemoved = const Value.absent(),
              }) => UserCardsCompanion(
                id: id,
                name: name,
                avatar: avatar,
                crop: crop,
                description: description,
                isDefault: isDefault,
                isRemoved: isRemoved,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> avatar = const Value.absent(),
                Value<String?> crop = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isRemoved = const Value.absent(),
              }) => UserCardsCompanion.insert(
                id: id,
                name: name,
                avatar: avatar,
                crop: crop,
                description: description,
                isDefault: isDefault,
                isRemoved: isRemoved,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserCardsTable, UserCardData>(table),
                  $$UserCardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chatsRefs) db.chats],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chatsRefs)
                    await $_getPrefetchedDataByColumns<
                      UserCardData,
                      $UserCardsTable,
                      ChatData,
                      $ChatsTable
                    >(
                      currentTable: table,
                      referencedTable: $$UserCardsTableReferences
                          ._chatsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$UserCardsTableReferences(db, table, p0).chatsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'user_card_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UserCardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserCardsTable,
      UserCardData,
      $$UserCardsTableFilterComposer,
      $$UserCardsTableOrderingComposer,
      $$UserCardsTableAnnotationComposer,
      $$UserCardsTableCreateCompanionBuilder,
      $$UserCardsTableUpdateCompanionBuilder,
      (UserCardData, $$UserCardsTableReferences),
      UserCardData,
      PrefetchHooks Function({bool chatsRefs})
    >;
typedef $$ChatsTableCreateCompanionBuilder =
    ChatsCompanion Function({
      Value<int> id,
      required String title,
      required DateTime createdAt,
      required int charId,
      Value<int?> userCardId,
      Value<String?> background,
    });
typedef $$ChatsTableUpdateCompanionBuilder =
    ChatsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<DateTime> createdAt,
      Value<int> charId,
      Value<int?> userCardId,
      Value<String?> background,
    });

final class $$ChatsTableReferences
    extends BaseReferences<_$AppDatabase, $ChatsTable, ChatData> {
  $$ChatsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CharsTable _charIdTable(_$AppDatabase db) =>
      db.chars.createAlias('chats__char_id__chars__id');

  $$CharsTableProcessedTableManager get charId {
    final $_column = $_itemColumn<int>('char_id')!;

    final manager = $$CharsTableTableManager(
      $_db,
      $_db.chars,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_charIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UserCardsTable _userCardIdTable(_$AppDatabase db) =>
      db.userCards.createAlias('chats__user_card_id__user_cards__id');

  $$UserCardsTableProcessedTableManager? get userCardId {
    final $_column = $_itemColumn<int>('user_card_id');
    if ($_column == null) return null;
    final manager = $$UserCardsTableTableManager(
      $_db,
      $_db.userCards,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userCardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MessagesTable, List<MessageData>>
  _messagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.messages,
    aliasName: 'chats__id__messages__chat_id',
  );

  $$MessagesTableProcessedTableManager get messagesRefs {
    final manager = $$MessagesTableTableManager(
      $_db,
      $_db.messages,
    ).filter((f) => f.chatId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_messagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SummariesTable, List<SummaryData>>
  _summariesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.summaries,
    aliasName: 'chats__id__summaries__chat_id',
  );

  $$SummariesTableProcessedTableManager get summariesRefs {
    final manager = $$SummariesTableTableManager(
      $_db,
      $_db.summaries,
    ).filter((f) => f.chatId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_summariesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ChatsTableFilterComposer extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnFilters(column),
  );

  $$CharsTableFilterComposer get charId {
    final $$CharsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.charId,
      referencedTable: $db.chars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharsTableFilterComposer(
            $db: $db,
            $table: $db.chars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserCardsTableFilterComposer get userCardId {
    final $$UserCardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userCardId,
      referencedTable: $db.userCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCardsTableFilterComposer(
            $db: $db,
            $table: $db.userCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> messagesRefs(
    Expression<bool> Function($$MessagesTableFilterComposer f) f,
  ) {
    final $$MessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableFilterComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> summariesRefs(
    Expression<bool> Function($$SummariesTableFilterComposer f) f,
  ) {
    final $$SummariesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.summaries,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SummariesTableFilterComposer(
            $db: $db,
            $table: $db.summaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => ColumnOrderings(column),
  );

  $$CharsTableOrderingComposer get charId {
    final $$CharsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.charId,
      referencedTable: $db.chars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharsTableOrderingComposer(
            $db: $db,
            $table: $db.chars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserCardsTableOrderingComposer get userCardId {
    final $$UserCardsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userCardId,
      referencedTable: $db.userCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCardsTableOrderingComposer(
            $db: $db,
            $table: $db.userCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChatsTable> {
  $$ChatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get background => $composableBuilder(
    column: $table.background,
    builder: (column) => column,
  );

  $$CharsTableAnnotationComposer get charId {
    final $$CharsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.charId,
      referencedTable: $db.chars,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharsTableAnnotationComposer(
            $db: $db,
            $table: $db.chars,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserCardsTableAnnotationComposer get userCardId {
    final $$UserCardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userCardId,
      referencedTable: $db.userCards,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCardsTableAnnotationComposer(
            $db: $db,
            $table: $db.userCards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> messagesRefs<T extends Object>(
    Expression<T> Function($$MessagesTableAnnotationComposer a) f,
  ) {
    final $$MessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.messages,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.messages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> summariesRefs<T extends Object>(
    Expression<T> Function($$SummariesTableAnnotationComposer a) f,
  ) {
    final $$SummariesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.summaries,
      getReferencedColumn: (t) => t.chatId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SummariesTableAnnotationComposer(
            $db: $db,
            $table: $db.summaries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ChatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChatsTable,
          ChatData,
          $$ChatsTableFilterComposer,
          $$ChatsTableOrderingComposer,
          $$ChatsTableAnnotationComposer,
          $$ChatsTableCreateCompanionBuilder,
          $$ChatsTableUpdateCompanionBuilder,
          (ChatData, $$ChatsTableReferences),
          ChatData,
          PrefetchHooks Function({
            bool charId,
            bool userCardId,
            bool messagesRefs,
            bool summariesRefs,
          })
        > {
  $$ChatsTableTableManager(_$AppDatabase db, $ChatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> charId = const Value.absent(),
                Value<int?> userCardId = const Value.absent(),
                Value<String?> background = const Value.absent(),
              }) => ChatsCompanion(
                id: id,
                title: title,
                createdAt: createdAt,
                charId: charId,
                userCardId: userCardId,
                background: background,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required DateTime createdAt,
                required int charId,
                Value<int?> userCardId = const Value.absent(),
                Value<String?> background = const Value.absent(),
              }) => ChatsCompanion.insert(
                id: id,
                title: title,
                createdAt: createdAt,
                charId: charId,
                userCardId: userCardId,
                background: background,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChatsTable, ChatData>(table),
                  $$ChatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                charId = false,
                userCardId = false,
                messagesRefs = false,
                summariesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (messagesRefs) db.messages,
                    if (summariesRefs) db.summaries,
                  ],
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
                        if (charId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.charId,
                                    referencedTable: $$ChatsTableReferences
                                        ._charIdTable(db),
                                    referencedColumn: $$ChatsTableReferences
                                        ._charIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (userCardId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userCardId,
                                    referencedTable: $$ChatsTableReferences
                                        ._userCardIdTable(db),
                                    referencedColumn: $$ChatsTableReferences
                                        ._userCardIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (messagesRefs)
                        await $_getPrefetchedDataByColumns<
                          ChatData,
                          $ChatsTable,
                          MessageData,
                          $MessagesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ChatsTableReferences
                              ._messagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChatsTableReferences(
                                db,
                                table,
                                p0,
                              ).messagesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'chat_id',
                          typedResults: items,
                        ),
                      if (summariesRefs)
                        await $_getPrefetchedDataByColumns<
                          ChatData,
                          $ChatsTable,
                          SummaryData,
                          $SummariesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ChatsTableReferences
                              ._summariesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ChatsTableReferences(
                                db,
                                table,
                                p0,
                              ).summariesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'chat_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ChatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChatsTable,
      ChatData,
      $$ChatsTableFilterComposer,
      $$ChatsTableOrderingComposer,
      $$ChatsTableAnnotationComposer,
      $$ChatsTableCreateCompanionBuilder,
      $$ChatsTableUpdateCompanionBuilder,
      (ChatData, $$ChatsTableReferences),
      ChatData,
      PrefetchHooks Function({
        bool charId,
        bool userCardId,
        bool messagesRefs,
        bool summariesRefs,
      })
    >;
typedef $$MessagesTableCreateCompanionBuilder =
    MessagesCompanion Function({
      Value<int> id,
      required int chatId,
      required MessageRole role,
      required String content,
      required DateTime createdAt,
      Value<int?> parentId,
      Value<String?> imagePath,
      Value<String> modelName,
      Value<bool> isActive,
    });
typedef $$MessagesTableUpdateCompanionBuilder =
    MessagesCompanion Function({
      Value<int> id,
      Value<int> chatId,
      Value<MessageRole> role,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<int?> parentId,
      Value<String?> imagePath,
      Value<String> modelName,
      Value<bool> isActive,
    });

final class $$MessagesTableReferences
    extends BaseReferences<_$AppDatabase, $MessagesTable, MessageData> {
  $$MessagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatsTable _chatIdTable(_$AppDatabase db) =>
      db.chats.createAlias('messages__chat_id__chats__id');

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<int>('chat_id')!;

    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MessagesTableFilterComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<MessageRole, MessageRole, String> get role =>
      $composableBuilder(
        column: $table.role,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableOrderingComposer({
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableOrderingComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MessagesTable> {
  $$MessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MessageRole, String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MessagesTable,
          MessageData,
          $$MessagesTableFilterComposer,
          $$MessagesTableOrderingComposer,
          $$MessagesTableAnnotationComposer,
          $$MessagesTableCreateCompanionBuilder,
          $$MessagesTableUpdateCompanionBuilder,
          (MessageData, $$MessagesTableReferences),
          MessageData,
          PrefetchHooks Function({bool chatId})
        > {
  $$MessagesTableTableManager(_$AppDatabase db, $MessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chatId = const Value.absent(),
                Value<MessageRole> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> modelName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MessagesCompanion(
                id: id,
                chatId: chatId,
                role: role,
                content: content,
                createdAt: createdAt,
                parentId: parentId,
                imagePath: imagePath,
                modelName: modelName,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chatId,
                required MessageRole role,
                required String content,
                required DateTime createdAt,
                Value<int?> parentId = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<String> modelName = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => MessagesCompanion.insert(
                id: id,
                chatId: chatId,
                role: role,
                content: content,
                createdAt: createdAt,
                parentId: parentId,
                imagePath: imagePath,
                modelName: modelName,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MessagesTable, MessageData>(table),
                  $$MessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatId = false}) {
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
                    if (chatId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chatId,
                                referencedTable: $$MessagesTableReferences
                                    ._chatIdTable(db),
                                referencedColumn: $$MessagesTableReferences
                                    ._chatIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$MessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MessagesTable,
      MessageData,
      $$MessagesTableFilterComposer,
      $$MessagesTableOrderingComposer,
      $$MessagesTableAnnotationComposer,
      $$MessagesTableCreateCompanionBuilder,
      $$MessagesTableUpdateCompanionBuilder,
      (MessageData, $$MessagesTableReferences),
      MessageData,
      PrefetchHooks Function({bool chatId})
    >;
typedef $$SummariesTableCreateCompanionBuilder =
    SummariesCompanion Function({
      Value<int> id,
      required int chatId,
      Value<String> content,
      required int lastSummarizedMessageId,
      Value<DateTime> createdAt,
    });
typedef $$SummariesTableUpdateCompanionBuilder =
    SummariesCompanion Function({
      Value<int> id,
      Value<int> chatId,
      Value<String> content,
      Value<int> lastSummarizedMessageId,
      Value<DateTime> createdAt,
    });

final class $$SummariesTableReferences
    extends BaseReferences<_$AppDatabase, $SummariesTable, SummaryData> {
  $$SummariesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ChatsTable _chatIdTable(_$AppDatabase db) =>
      db.chats.createAlias('summaries__chat_id__chats__id');

  $$ChatsTableProcessedTableManager get chatId {
    final $_column = $_itemColumn<int>('chat_id')!;

    final manager = $$ChatsTableTableManager(
      $_db,
      $_db.chats,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_chatIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SummariesTableFilterComposer
    extends Composer<_$AppDatabase, $SummariesTable> {
  $$SummariesTableFilterComposer({
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

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSummarizedMessageId => $composableBuilder(
    column: $table.lastSummarizedMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ChatsTableFilterComposer get chatId {
    final $$ChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableFilterComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SummariesTableOrderingComposer
    extends Composer<_$AppDatabase, $SummariesTable> {
  $$SummariesTableOrderingComposer({
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

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSummarizedMessageId => $composableBuilder(
    column: $table.lastSummarizedMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ChatsTableOrderingComposer get chatId {
    final $$ChatsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableOrderingComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SummariesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SummariesTable> {
  $$SummariesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<int> get lastSummarizedMessageId => $composableBuilder(
    column: $table.lastSummarizedMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ChatsTableAnnotationComposer get chatId {
    final $$ChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.chatId,
      referencedTable: $db.chats,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.chats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SummariesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SummariesTable,
          SummaryData,
          $$SummariesTableFilterComposer,
          $$SummariesTableOrderingComposer,
          $$SummariesTableAnnotationComposer,
          $$SummariesTableCreateCompanionBuilder,
          $$SummariesTableUpdateCompanionBuilder,
          (SummaryData, $$SummariesTableReferences),
          SummaryData,
          PrefetchHooks Function({bool chatId})
        > {
  $$SummariesTableTableManager(_$AppDatabase db, $SummariesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SummariesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SummariesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SummariesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> chatId = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<int> lastSummarizedMessageId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SummariesCompanion(
                id: id,
                chatId: chatId,
                content: content,
                lastSummarizedMessageId: lastSummarizedMessageId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int chatId,
                Value<String> content = const Value.absent(),
                required int lastSummarizedMessageId,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SummariesCompanion.insert(
                id: id,
                chatId: chatId,
                content: content,
                lastSummarizedMessageId: lastSummarizedMessageId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SummariesTable, SummaryData>(table),
                  $$SummariesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({chatId = false}) {
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
                    if (chatId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.chatId,
                                referencedTable: $$SummariesTableReferences
                                    ._chatIdTable(db),
                                referencedColumn: $$SummariesTableReferences
                                    ._chatIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$SummariesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SummariesTable,
      SummaryData,
      $$SummariesTableFilterComposer,
      $$SummariesTableOrderingComposer,
      $$SummariesTableAnnotationComposer,
      $$SummariesTableCreateCompanionBuilder,
      $$SummariesTableUpdateCompanionBuilder,
      (SummaryData, $$SummariesTableReferences),
      SummaryData,
      PrefetchHooks Function({bool chatId})
    >;
typedef $$ProvidersTableCreateCompanionBuilder =
    ProvidersCompanion Function({
      Value<int> id,
      required String name,
      required String url,
      Value<String> additionalArgs,
    });
typedef $$ProvidersTableUpdateCompanionBuilder =
    ProvidersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> url,
      Value<String> additionalArgs,
    });

final class $$ProvidersTableReferences
    extends BaseReferences<_$AppDatabase, $ProvidersTable, ProviderData> {
  $$ProvidersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SettingsTableTable, List<SettingsData>>
  _settingsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.settingsTable,
    aliasName: 'providers__id__settings_table__provider_id',
  );

  $$SettingsTableTableProcessedTableManager get settingsTableRefs {
    final manager = $$SettingsTableTableTableManager(
      $_db,
      $_db.settingsTable,
    ).filter((f) => f.providerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_settingsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProvidersTableFilterComposer
    extends Composer<_$AppDatabase, $ProvidersTable> {
  $$ProvidersTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get additionalArgs => $composableBuilder(
    column: $table.additionalArgs,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> settingsTableRefs(
    Expression<bool> Function($$SettingsTableTableFilterComposer f) f,
  ) {
    final $$SettingsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settingsTable,
      getReferencedColumn: (t) => t.providerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettingsTableTableFilterComposer(
            $db: $db,
            $table: $db.settingsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProvidersTableOrderingComposer
    extends Composer<_$AppDatabase, $ProvidersTable> {
  $$ProvidersTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get additionalArgs => $composableBuilder(
    column: $table.additionalArgs,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProvidersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProvidersTable> {
  $$ProvidersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get additionalArgs => $composableBuilder(
    column: $table.additionalArgs,
    builder: (column) => column,
  );

  Expression<T> settingsTableRefs<T extends Object>(
    Expression<T> Function($$SettingsTableTableAnnotationComposer a) f,
  ) {
    final $$SettingsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.settingsTable,
      getReferencedColumn: (t) => t.providerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SettingsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.settingsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProvidersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProvidersTable,
          ProviderData,
          $$ProvidersTableFilterComposer,
          $$ProvidersTableOrderingComposer,
          $$ProvidersTableAnnotationComposer,
          $$ProvidersTableCreateCompanionBuilder,
          $$ProvidersTableUpdateCompanionBuilder,
          (ProviderData, $$ProvidersTableReferences),
          ProviderData,
          PrefetchHooks Function({bool settingsTableRefs})
        > {
  $$ProvidersTableTableManager(_$AppDatabase db, $ProvidersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProvidersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProvidersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProvidersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> additionalArgs = const Value.absent(),
              }) => ProvidersCompanion(
                id: id,
                name: name,
                url: url,
                additionalArgs: additionalArgs,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String url,
                Value<String> additionalArgs = const Value.absent(),
              }) => ProvidersCompanion.insert(
                id: id,
                name: name,
                url: url,
                additionalArgs: additionalArgs,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProvidersTable, ProviderData>(table),
                  $$ProvidersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({settingsTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (settingsTableRefs) db.settingsTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (settingsTableRefs)
                    await $_getPrefetchedDataByColumns<
                      ProviderData,
                      $ProvidersTable,
                      SettingsData,
                      $SettingsTableTable
                    >(
                      currentTable: table,
                      referencedTable: $$ProvidersTableReferences
                          ._settingsTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProvidersTableReferences(
                            db,
                            table,
                            p0,
                          ).settingsTableRefs,
                      currentColumn: 'id',
                      referencedColumn: 'provider_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProvidersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProvidersTable,
      ProviderData,
      $$ProvidersTableFilterComposer,
      $$ProvidersTableOrderingComposer,
      $$ProvidersTableAnnotationComposer,
      $$ProvidersTableCreateCompanionBuilder,
      $$ProvidersTableUpdateCompanionBuilder,
      (ProviderData, $$ProvidersTableReferences),
      ProviderData,
      PrefetchHooks Function({bool settingsTableRefs})
    >;
typedef $$SettingsTableTableCreateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      required String modelName,
      required String visionModelName,
      required String embeddingModelName,
      required String tokenizerPath,
      required int maxContextTokens,
      required double temperature,
      required double minP,
      required double topP,
      required double repeatPenalty,
      required String globalSystemPrompt,
      required String template,
      required int providerId,
    });
typedef $$SettingsTableTableUpdateCompanionBuilder =
    SettingsTableCompanion Function({
      Value<int> id,
      Value<String> modelName,
      Value<String> visionModelName,
      Value<String> embeddingModelName,
      Value<String> tokenizerPath,
      Value<int> maxContextTokens,
      Value<double> temperature,
      Value<double> minP,
      Value<double> topP,
      Value<double> repeatPenalty,
      Value<String> globalSystemPrompt,
      Value<String> template,
      Value<int> providerId,
    });

final class $$SettingsTableTableReferences
    extends BaseReferences<_$AppDatabase, $SettingsTableTable, SettingsData> {
  $$SettingsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProvidersTable _providerIdTable(_$AppDatabase db) =>
      db.providers.createAlias('settings_table__provider_id__providers__id');

  $$ProvidersTableProcessedTableManager get providerId {
    final $_column = $_itemColumn<int>('provider_id')!;

    final manager = $$ProvidersTableTableManager(
      $_db,
      $_db.providers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_providerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableFilterComposer({
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

  ColumnFilters<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visionModelName => $composableBuilder(
    column: $table.visionModelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get embeddingModelName => $composableBuilder(
    column: $table.embeddingModelName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tokenizerPath => $composableBuilder(
    column: $table.tokenizerPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxContextTokens => $composableBuilder(
    column: $table.maxContextTokens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minP => $composableBuilder(
    column: $table.minP,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get topP => $composableBuilder(
    column: $table.topP,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get repeatPenalty => $composableBuilder(
    column: $table.repeatPenalty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get globalSystemPrompt => $composableBuilder(
    column: $table.globalSystemPrompt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get template => $composableBuilder(
    column: $table.template,
    builder: (column) => ColumnFilters(column),
  );

  $$ProvidersTableFilterComposer get providerId {
    final $$ProvidersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.providerId,
      referencedTable: $db.providers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvidersTableFilterComposer(
            $db: $db,
            $table: $db.providers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get modelName => $composableBuilder(
    column: $table.modelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visionModelName => $composableBuilder(
    column: $table.visionModelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get embeddingModelName => $composableBuilder(
    column: $table.embeddingModelName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tokenizerPath => $composableBuilder(
    column: $table.tokenizerPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxContextTokens => $composableBuilder(
    column: $table.maxContextTokens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minP => $composableBuilder(
    column: $table.minP,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get topP => $composableBuilder(
    column: $table.topP,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get repeatPenalty => $composableBuilder(
    column: $table.repeatPenalty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get globalSystemPrompt => $composableBuilder(
    column: $table.globalSystemPrompt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get template => $composableBuilder(
    column: $table.template,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProvidersTableOrderingComposer get providerId {
    final $$ProvidersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.providerId,
      referencedTable: $db.providers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvidersTableOrderingComposer(
            $db: $db,
            $table: $db.providers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTableTable> {
  $$SettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get modelName =>
      $composableBuilder(column: $table.modelName, builder: (column) => column);

  GeneratedColumn<String> get visionModelName => $composableBuilder(
    column: $table.visionModelName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get embeddingModelName => $composableBuilder(
    column: $table.embeddingModelName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tokenizerPath => $composableBuilder(
    column: $table.tokenizerPath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxContextTokens => $composableBuilder(
    column: $table.maxContextTokens,
    builder: (column) => column,
  );

  GeneratedColumn<double> get temperature => $composableBuilder(
    column: $table.temperature,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minP =>
      $composableBuilder(column: $table.minP, builder: (column) => column);

  GeneratedColumn<double> get topP =>
      $composableBuilder(column: $table.topP, builder: (column) => column);

  GeneratedColumn<double> get repeatPenalty => $composableBuilder(
    column: $table.repeatPenalty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get globalSystemPrompt => $composableBuilder(
    column: $table.globalSystemPrompt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get template =>
      $composableBuilder(column: $table.template, builder: (column) => column);

  $$ProvidersTableAnnotationComposer get providerId {
    final $$ProvidersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.providerId,
      referencedTable: $db.providers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProvidersTableAnnotationComposer(
            $db: $db,
            $table: $db.providers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTableTable,
          SettingsData,
          $$SettingsTableTableFilterComposer,
          $$SettingsTableTableOrderingComposer,
          $$SettingsTableTableAnnotationComposer,
          $$SettingsTableTableCreateCompanionBuilder,
          $$SettingsTableTableUpdateCompanionBuilder,
          (SettingsData, $$SettingsTableTableReferences),
          SettingsData,
          PrefetchHooks Function({bool providerId})
        > {
  $$SettingsTableTableTableManager(_$AppDatabase db, $SettingsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> modelName = const Value.absent(),
                Value<String> visionModelName = const Value.absent(),
                Value<String> embeddingModelName = const Value.absent(),
                Value<String> tokenizerPath = const Value.absent(),
                Value<int> maxContextTokens = const Value.absent(),
                Value<double> temperature = const Value.absent(),
                Value<double> minP = const Value.absent(),
                Value<double> topP = const Value.absent(),
                Value<double> repeatPenalty = const Value.absent(),
                Value<String> globalSystemPrompt = const Value.absent(),
                Value<String> template = const Value.absent(),
                Value<int> providerId = const Value.absent(),
              }) => SettingsTableCompanion(
                id: id,
                modelName: modelName,
                visionModelName: visionModelName,
                embeddingModelName: embeddingModelName,
                tokenizerPath: tokenizerPath,
                maxContextTokens: maxContextTokens,
                temperature: temperature,
                minP: minP,
                topP: topP,
                repeatPenalty: repeatPenalty,
                globalSystemPrompt: globalSystemPrompt,
                template: template,
                providerId: providerId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String modelName,
                required String visionModelName,
                required String embeddingModelName,
                required String tokenizerPath,
                required int maxContextTokens,
                required double temperature,
                required double minP,
                required double topP,
                required double repeatPenalty,
                required String globalSystemPrompt,
                required String template,
                required int providerId,
              }) => SettingsTableCompanion.insert(
                id: id,
                modelName: modelName,
                visionModelName: visionModelName,
                embeddingModelName: embeddingModelName,
                tokenizerPath: tokenizerPath,
                maxContextTokens: maxContextTokens,
                temperature: temperature,
                minP: minP,
                topP: topP,
                repeatPenalty: repeatPenalty,
                globalSystemPrompt: globalSystemPrompt,
                template: template,
                providerId: providerId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTableTable, SettingsData>(table),
                  $$SettingsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({providerId = false}) {
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
                    if (providerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.providerId,
                                referencedTable: $$SettingsTableTableReferences
                                    ._providerIdTable(db),
                                referencedColumn: $$SettingsTableTableReferences
                                    ._providerIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$SettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTableTable,
      SettingsData,
      $$SettingsTableTableFilterComposer,
      $$SettingsTableTableOrderingComposer,
      $$SettingsTableTableAnnotationComposer,
      $$SettingsTableTableCreateCompanionBuilder,
      $$SettingsTableTableUpdateCompanionBuilder,
      (SettingsData, $$SettingsTableTableReferences),
      SettingsData,
      PrefetchHooks Function({bool providerId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CharsTableTableManager get chars =>
      $$CharsTableTableManager(_db, _db.chars);
  $$LorebooksTableTableManager get lorebooks =>
      $$LorebooksTableTableManager(_db, _db.lorebooks);
  $$CharLorebooksTableTableManager get charLorebooks =>
      $$CharLorebooksTableTableManager(_db, _db.charLorebooks);
  $$LoreEntriesTableTableManager get loreEntries =>
      $$LoreEntriesTableTableManager(_db, _db.loreEntries);
  $$UserCardsTableTableManager get userCards =>
      $$UserCardsTableTableManager(_db, _db.userCards);
  $$ChatsTableTableManager get chats =>
      $$ChatsTableTableManager(_db, _db.chats);
  $$MessagesTableTableManager get messages =>
      $$MessagesTableTableManager(_db, _db.messages);
  $$SummariesTableTableManager get summaries =>
      $$SummariesTableTableManager(_db, _db.summaries);
  $$ProvidersTableTableManager get providers =>
      $$ProvidersTableTableManager(_db, _db.providers);
  $$SettingsTableTableTableManager get settingsTable =>
      $$SettingsTableTableTableManager(_db, _db.settingsTable);
}
