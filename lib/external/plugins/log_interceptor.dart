import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

final class LogApiInterceptor extends Interceptor {

  const LogApiInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('Request >>> ${options.method} ${options.uri}');
      print('Header >>> ${options.headers}');
      print('Body >>> ${options.data}');
      print('===/===/===/===/===/===/===/===');
    }
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('Message: ${err.response}');
      print(
        'Error <<< ${err.response?.requestOptions.method} '
            '[${err.response?.statusCode}] '
            'URI: ${err.requestOptions.uri}',
      );
      print('Message: ${err.message}');
      print('Body: ${err.response?.data}');
      print('Type: ${err.type}');
      print('===/===/===/===/===/===/===/===');
    }
    return super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(
        'Response <<< ${response.requestOptions.method} '
            '[${response.statusCode}] '
            'URI: ${response.requestOptions.uri}',
      );
      print('Body: ${response.data}');
      print('===/===/===/===/===/===/===/===');
    }
    return super.onResponse(response, handler);
  }
}