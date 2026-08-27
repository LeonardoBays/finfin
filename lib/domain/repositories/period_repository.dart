import '../../data/models/period_model.dart';

abstract class PeriodRepository {
  Future<String> create(PeriodModel period);
  Future<void> update(PeriodModel period);
  Future<void> delete(String id);
  Future<PeriodModel?> getById(String id);
  Future<List<PeriodModel>> listByUser(String userUid);
}
