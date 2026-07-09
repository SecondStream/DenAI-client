import 'dart:io';
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

  Future<TResult?> post<TResult, TData>(
    String endpoint, {
    TData? data,
    Options? options,
  }) async {
    final res = await _dio.post<dynamic>(
      _baseUrl + endpoint,
      data: data,
      options: options,
    );
    return res.data as TResult?;
  }

  Future<TResult?> put<TResult, TData>(
    String endpoint, {
    TData? data,
    Options? options,
  }) async {
    final res = await _dio.put(_baseUrl + endpoint, data: data);
    return res.data as TResult?;
  }

  Future<TResult?> patch<TResult, TData>(
    String endpoint, {
    TData? data,
    Options? options,
  }) async {
    final res = await _dio.patch(_baseUrl + endpoint, data: data);
    return res.data as TResult?;
  }

  Future<TResult?> delete<TResult, TData>(
    String endpoint, {
    TData? data,
    Options? options,
  }) async {
    final res = await _dio.delete(_baseUrl + endpoint, data: data);
    return res.data as TResult?;
  }

  Future<IOWebSocketChannel> wsConnect(String endpoint) async {
    final wsUrl = Uri.parse(_wsUrl + endpoint);
    final channel = IOWebSocketChannel.connect(
      wsUrl,
      pingInterval: Duration(seconds: 20),
    );
    //await channel.ready;
    return channel;
  }

  Future<File?> download(String url) async {
    final dio = Dio();
    try {
      final tempDir = Directory.systemTemp;
      final uri = Uri.parse(url);
      final path = uri.path;
      final ext = path.split('.').last;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
      final savePath = '${tempDir.path}/$fileName';
      await dio.download(url, savePath);
      return File(savePath);
    } catch (_) {
      return null;
    }
  }
}
