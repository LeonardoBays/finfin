import 'package:dio/dio.dart';

import '../../data/datasources/remote/http_client.dart';
import '../util/exceptions/http_request_exception.dart';

typedef HttpResponse<T> = T Function(Response response);

abstract class RemoteDataSource<T> {

  RemoteDataSource(HttpClient httpClient) {
    _httpClient = httpClient;
  }
  late final HttpClient _httpClient;

  Future<T> get({
    required String path,
    required HttpResponse<T> response,
    required String title,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      final res = await _httpClient.client.get(
        path,
        options: Options(responseType: responseType),
      );

      return response(res);
    } on DioException catch (e) {
      throw HttpRequestException(e.response, title);
    } catch (e) {
      rethrow;
    }
  }

  Future<T> post({
    required String path,
    required HttpResponse<T> response,
    required Object? body,
    required String title,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      final res = await _httpClient.client.post(
        path,
        data: body,
        options: Options(responseType: responseType),
      );

      return response(res);
    } on DioException catch (e) {
      throw HttpRequestException(e.response, title);
    } catch (e) {
      rethrow;
    }
  }
}
