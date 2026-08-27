import '../../../config/http_schema.dart';
import '../../../core/resources/remote_source.dart';
import '../../../domain/repositories/remote/api_repository.dart';

class ApiRepositoryImpl extends RemoteDataSource implements ApiRepository {
  ApiRepositoryImpl(super.httpClient, this.schema);

  final HttpSchema schema;
}
