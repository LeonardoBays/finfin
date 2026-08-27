import 'package:dio/dio.dart';

import '../../config/http_schema.dart';
import '../../data/datasources/remote/http_client.dart';
import 'log_interceptor.dart';

class HttpClientImpl extends HttpClient {
  const HttpClientImpl(super.client);

  factory HttpClientImpl.initialize(HttpSchema schema) {
    final client = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        baseUrl: schema.baseUrl,
      ),
    )..interceptors.add(const LogApiInterceptor());

    return HttpClientImpl(client);
  }
}
