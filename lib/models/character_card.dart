class ImportedCardData {
  final String name;
  final String description;
  final String personality;
  final String scenario;
  final String greeting;
  final String notes;
  final String instructions;
  final List<String> tags;
  final List<ImportedLorebookData> lorebooks;

  ImportedCardData({
    required this.name,
    required this.description,
    required this.personality,
    required this.scenario,
    required this.greeting,
    required this.notes,
    required this.instructions,
    required this.tags,
    required this.lorebooks,
  });
}

class ImportedFromAssetsCardData extends ImportedCardData {
  final String avatar;
  final String background;

  ImportedFromAssetsCardData({
    required super.name,
    required super.description,
    required super.personality,
    required super.scenario,
    required super.greeting,
    required super.notes,
    required super.instructions,
    required super.tags,
    required super.lorebooks,
    required this.avatar,
    required this.background,
  });
}

class ImportedLorebookData {
  final String name;
  final String description;
  final List<ImportedLoreEntryData> entries;

  ImportedLorebookData({required this.name, required this.description, required this.entries});
}

class ImportedLoreEntryData {
  final String title;
  final String content;

  ImportedLoreEntryData({required this.title, required this.content});
}
