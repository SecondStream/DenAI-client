import 'package:den_ai/repositories/provider/remote_provider.dart';

abstract class BaseRepository {
  final RemoteProvider remote;
  final String endpoint;

  BaseRepository(this.remote, this.endpoint);
}
