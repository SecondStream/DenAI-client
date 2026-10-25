class ImportedCardData {
  final String name;
  final String description;
  final String personality;
  final String scenario;
  final String greeting;
  final String definition;
  final String instructions;
  final List<String> tags;
  final List<ImportedLorebookData> lorebooks;

  ImportedCardData({
    required this.name,
    required this.description,
    required this.personality,
    required this.scenario,
    required this.greeting,
    required this.definition,
    required this.instructions,
    required this.tags,
    required this.lorebooks,
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
