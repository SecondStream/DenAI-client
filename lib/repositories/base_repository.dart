import 'package:den_ai/repositories/database.dart';

abstract class BaseRepository {
  final AppDatabase db;

  BaseRepository(this.db);
}
