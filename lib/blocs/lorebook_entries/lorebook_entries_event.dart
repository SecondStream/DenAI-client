import 'package:den_ai/models/models.dart';

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
  final LoreEntryIn entry;
  const SaveEntryEvent(this.entry);
}
