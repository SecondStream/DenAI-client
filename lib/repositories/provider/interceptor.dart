import 'package:dio/dio.dart';

class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String message = 'Something went wrong';

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout) {
      message = 'There is no internet connection';
    } else if (err.type == DioExceptionType.badResponse) {
      final status = err.response?.statusCode;
      if (status == 401) {
        message = 'Your session has expired, please log in again.';
      } else {
        message = err.response?.data?['message'] ?? 'Server error ($status)';
      }
    }

    final customException = AppException(message, err.response?.statusCode);

    handler.reject(err.copyWith(error: customException));
  }
}
