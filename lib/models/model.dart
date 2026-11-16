import 'package:den_ai/models/provider.dart';
import 'package:drift/drift.dart';

import '../repositories/database.dart' show ModelData;

enum ModelType { chat, vision, embedding }

class Model {
  final ModelType type;
  final String name;
  final Provider provider;
  final bool handInputName;
  final bool isFallback;

  Model._({
    required this.type,
    required this.name,
    required this.provider,
    this.handInputName = false,
    this.isFallback = false,
  });

  factory Model.fromDb(ModelData data, Provider provider, {bool isFallback = false}) {
    return Model._(
      type: data.type,
      name: data.name,
      handInputName: data.handInputName,
      provider: provider,
      isFallback: isFallback,
    );
  }

  Model copyWith({String? name, Provider? provider, bool? handInputName, bool? isFallback}) {
    return Model._(
      type: type,
      name: name ?? this.name,
      handInputName: handInputName ?? this.handInputName,
      provider: provider ?? this.provider.copy(),
      isFallback: isFallback ?? this.isFallback,
    );
  }
}

class ActiveModels {
  final Model chat;
  final Model vision;
  final Model embedding;

  const ActiveModels({required this.chat, required this.vision, required this.embedding});

  ActiveModels copyWith({Model? chat, Model? vision, Model? embedding}) {
    return ActiveModels(
      chat: chat ?? this.chat.copyWith(),
      vision: vision ?? this.vision.copyWith(),
      embedding: embedding ?? this.embedding.copyWith(),
    );
  }
}

@DataClassName('ModelData')
class Models extends Table {
  TextColumn get type => textEnum<ModelType>()();
  TextColumn get name => text()();
  IntColumn get providerId =>
      integer().nullable().references(Providers, #id, onDelete: KeyAction.setNull)();
  BoolColumn get handInputName => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {type};
}
