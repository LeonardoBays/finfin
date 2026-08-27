import 'package:equatable/equatable.dart';

class ApiError extends Equatable {
  const ApiError({
    required this.timestamp,
    required this.status,
    required this.error,
    required this.message,
    required this.path,
  });

  factory ApiError.fromMap(Map<String, dynamic> json) {
    return ApiError(
      error: json['error'],
      message: json['message'],
      path: json['path'],
      status: json['status'],
      timestamp: json['timestamp'],
    );
  }

  final String timestamp;
  final int status;
  final String error;
  final String message;
  final String path;

  @override
  List<Object> get props => [timestamp, status, error, message, path];

  @override
  String toString() {
    return 'ApiError{'
        'timestamp: $timestamp, '
        'status: $status, '
        'error: $error, '
        'message: $message, '
        'path: $path'
        '}';
  }
}
