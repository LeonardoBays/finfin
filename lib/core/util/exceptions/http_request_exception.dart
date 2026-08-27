import 'package:dio/dio.dart';

import '../../../data/models/api_error.dart';

class HttpRequestException implements Exception {
  const HttpRequestException(this._response, this._title);

  final Response? _response;
  final String _title;

  String get errorMessage {
    try {
      final Map<String, dynamic>? apiErrorJson = _response?.data;

      if (apiErrorJson == null) {
        return _title;
      }

      return ApiError.fromMap(apiErrorJson).message;
    } catch (e) {
      return _title;
    }
  }
}