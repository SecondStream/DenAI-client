import 'package:dio/dio.dart';

class RemoteProvider {
  static const String _baseUrl = 'http://127.0.0.1:8000';
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
}
