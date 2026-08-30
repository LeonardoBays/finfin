import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/models/period_summary_model.dart';
import '../../domain/repositories/period_summary_repository.dart';

class PeriodSummaryRemoteRepository implements PeriodSummaryRepository {
  PeriodSummaryRemoteRepository(this.firestore);

  final FirebaseFirestore firestore;

  @override
  Future<List<PeriodSummaryModel>> listByUser(String userUid) async {
    final periodsSnap = await firestore
        .collection('periods')
        .where('userUid', isEqualTo: userUid)
        .get();

    final transactionsSnap = await firestore
        .collection('transactions')
        .where('userUid', isEqualTo: userUid)
        .get();

    final totalsByPeriod = <String, double>{};
    for (final doc in transactionsSnap.docs) {
      final data = doc.data();
      final periodId = data['periodId'] as String?;
      if (periodId == null || periodId.isEmpty) continue;

      final amount = data['amount'] is num
          ? (data['amount'] as num).toDouble()
          : 0.0;
      totalsByPeriod[periodId] = (totalsByPeriod[periodId] ?? 0.0) + amount;
    }

    final summaries = <PeriodSummaryModel>[];
    for (final periodDoc in periodsSnap.docs) {
      final data = periodDoc.data();
      final periodId = periodDoc.id;
      final amount = data['amount'] is num
          ? (data['amount'] as num).toDouble()
          : 0.0;
      final totalSpent = totalsByPeriod[periodId] ?? 0.0;
      final startsAt = data['startsAt'] is Timestamp
          ? (data['startsAt'] as Timestamp).toDate()
          : DateTime.now();
      final endsAt = data['endsAt'] is Timestamp
          ? (data['endsAt'] as Timestamp).toDate()
          : DateTime.now();
      final remaining = amount - totalSpent;
      final percentage = amount <= 0
          ? 0.0
          : ((totalSpent / amount) * 100).clamp(0.0, 100.0);

      final enda = DateTime(endsAt.year, endsAt.month, endsAt.day);
      final dtNow = DateTime.now();
      final dtnowa = DateTime(dtNow.year, dtNow.month, dtNow.day);

      final daysLeft = enda.difference(dtnowa).inDays;

      summaries.add(
        PeriodSummaryModel(
          id: periodId,
          name: data['name'] as String? ?? '',
          userUid: userUid,
          amount: amount,
          totalSpent: totalSpent,
          remaining: remaining,
          percentage: percentage,
          startsAt: startsAt,
          endsAt: endsAt,
          daysLeft: daysLeft < 0 ? 0 : daysLeft,
          periodTypeId: data['periodTypeId'] is int
              ? data['periodTypeId'] as int
              : int.tryParse('${data['periodTypeId']}') ?? 0,
        ),
      );
    }

    summaries.sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return summaries;
  }

  @override
  Future<PeriodSummaryModel?> getCurrentByUser(String userUid) async {
    final summaries = await listByUser(userUid);
    if (summaries.isEmpty) return null;

    final now = DateTime.now();
    final active = summaries.where(
      (summary) =>
          (summary.startsAt.isBefore(now) ||
              summary.startsAt.isAtSameMomentAs(now)) &&
          (summary.endsAt.isAfter(now) || summary.endsAt.isAtSameMomentAs(now)),
    );

    return active.isNotEmpty
        ? active.first
        : summaries.reduce(
            (current, next) =>
                current.endsAt.isAfter(next.endsAt) ? current : next,
          );
  }
}
