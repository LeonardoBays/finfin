import 'package:dio/dio.dart';

abstract class HttpClient {
  const HttpClient(this.client);

  final Dio client;
}
