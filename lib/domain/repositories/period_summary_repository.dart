import '../../data/models/period_summary_model.dart';

abstract class PeriodSummaryRepository {
  Future<List<PeriodSummaryModel>> listByUser(String userUid);
  Future<PeriodSummaryModel?> getCurrentByUser(String userUid);
}
