enum ApiRoutes { tires }

sealed class HttpSchema {
  const HttpSchema();

  String get baseUrl;

  String get login => '/users/login';

  String get signUp => '/users/register';

  String get confirmDevice => '/users/confirm';
}

class LocalSchema extends HttpSchema {
  const LocalSchema();

  @override
  String get baseUrl => "http://10.0.2.2:8080/api";
}
