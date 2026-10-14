abstract class LorebookEntriesEvent {
  const LorebookEntriesEvent();
}

class LoadEntriesEvent extends LorebookEntriesEvent {
  final int bookId;
  const LoadEntriesEvent(this.bookId);
}

class DeleteEntryEvent extends LorebookEntriesEvent {
  final int entryId;
  const DeleteEntryEvent(this.entryId);
}

class SaveEntryEvent extends LorebookEntriesEvent {
  final int? id;
  final int lorebookId;
  final String title;
  final String content;

  const SaveEntryEvent({
    required this.id,
    required this.lorebookId,
    required this.title,
    required this.content,
  });
}
