import 'package:den_ai/models/models.dart';

abstract class LorebookEntriesState {
  const LorebookEntriesState();
}

class LorebookEntriesInitialState extends LorebookEntriesState {}

class LorebookEntriesLoadingState extends LorebookEntriesState {}

class LorebookEntriesLoadedState extends LorebookEntriesState {
  final List<LoreEntry> entries;
  const LorebookEntriesLoadedState(this.entries);

  LorebookEntriesLoadedState copy() {
    return LorebookEntriesLoadedState(entries.toList());
  }
}

class LorebookEntriesErrorState extends LorebookEntriesState {
  final String error;
  const LorebookEntriesErrorState(this.error);
}
