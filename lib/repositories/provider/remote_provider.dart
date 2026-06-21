import 'package:den_ai/env.dart';
import 'package:dio/dio.dart';
import 'package:web_socket_channel/io.dart';

class RemoteProvider {
  static const String _baseUrl = Env.apiUrl;
  static const String _wsUrl = Env.wsUrl;
  final Dio _dio;

  RemoteProvider(this._dio);

  Future<TResult?> get<TResult>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final res = await _dio.get<dynamic>(
      _baseUrl + endpoint,
      queryParameters: queryParameters,
      options: options,
    );
    return res.data as TResult?;
  }

  Future<TResult?> post<TResult, TData>(String endpoint, {TData? data, Options? options}) async {
    final res = await _dio.post<dynamic>(_baseUrl + endpoint, data: data, options: options);
    return res.data as TResult?;
  }

  Future<TResult?> put<TResult, TData>(String endpoint, {TData? data, Options? options}) async {
    final res = await _dio.put(_baseUrl + endpoint, data: data);
    return res.data as TResult?;
  }

  Future<TResult?> patch<TResult, TData>(String endpoint, {TData? data, Options? options}) async {
    final res = await _dio.patch(_baseUrl + endpoint, data: data);
    return res.data as TResult?;
  }

  Future<TResult?> delete<TResult, TData>(String endpoint, {TData? data, Options? options}) async {
    final res = await _dio.delete(_baseUrl + endpoint, data: data);
    return res.data as TResult?;
  }

  Future<IOWebSocketChannel> wsConnect(String endpoint) async {
    final wsUrl = Uri.parse(_wsUrl + endpoint);
    final channel = IOWebSocketChannel.connect(wsUrl, pingInterval: Duration(seconds: 2));
    await channel.ready;
    return channel;
  }
}
