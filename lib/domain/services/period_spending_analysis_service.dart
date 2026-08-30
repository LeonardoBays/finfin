import '../../data/models/period_model.dart';
import '../../data/models/transaction_model.dart';
import '../models/period_spending_analysis.dart';

class PeriodSpendingAnalysisService {
  const PeriodSpendingAnalysisService();

  PeriodSpendingAnalysis analyze(
    PeriodModel period, {
    List<TransactionModel> transactions = const [],
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();

    if (period.endsAt.isBefore(period.startsAt)) {
      return const PeriodSpendingAnalysis(
        status: PeriodSpendingStatus.onTrack,
        timeProgress: 0.0,
        spentProgress: 0.0,
        expectedSpent: 0.0,
        spent: 0.0,
        remaining: 0.0,
        progressDifference: 0.0,
        projectedSpent: 0.0,
        projectedDifference: 0.0,
        started: false,
        finished: false,
      );
    }

    final totalSpent = transactions.fold<double>(0.0, (sum, tx) => sum + tx.amount);
    final started = currentTime.isAfter(period.startsAt) ||
        currentTime.isAtSameMomentAs(period.startsAt);
    final finished = currentTime.isAfter(period.endsAt) ||
        currentTime.isAtSameMomentAs(period.endsAt);

    final totalDurationMs = period.endsAt.difference(period.startsAt).inMilliseconds;
    final safeDurationMs = totalDurationMs <= 0 ? 1 : totalDurationMs;

    final timeProgress = totalDurationMs <= 0
        ? 1.0
        : (currentTime.difference(period.startsAt).inMilliseconds / safeDurationMs)
            .clamp(0.0, 1.0);

    final validBudget = period.amount > 0 ? period.amount : 0.0;
    final spentProgress = validBudget > 0 ? (totalSpent / validBudget) : 0.0;
    final expectedSpent = validBudget * timeProgress;
    final remaining = validBudget > 0 ? (validBudget - totalSpent).clamp(0.0, validBudget) : 0.0;
    final progressDifference = spentProgress - timeProgress;

    var projectedSpent = totalSpent;
    if (timeProgress > 0.0) {
      projectedSpent = totalSpent / timeProgress;
    }
    final projectedDifference = projectedSpent - validBudget;

    const epsilon = 1e-9;
    PeriodSpendingStatus status;
    if (totalSpent > validBudget && validBudget > 0) {
      status = PeriodSpendingStatus.exceeded;
    } else if (progressDifference >= (0.20 - epsilon)) {
      status = PeriodSpendingStatus.danger;
    } else if (progressDifference >= (0.10 - epsilon)) {
      status = PeriodSpendingStatus.warning;
    } else {
      status = PeriodSpendingStatus.onTrack;
    }

    if (finished && totalSpent <= validBudget) {
      status = PeriodSpendingStatus.onTrack;
    }

    if (validBudget <= 0 && totalSpent > 0) {
      status = PeriodSpendingStatus.exceeded;
    }

    return PeriodSpendingAnalysis(
      status: status,
      timeProgress: timeProgress.clamp(0.0, 1.0),
      spentProgress: spentProgress,
      expectedSpent: expectedSpent,
      spent: totalSpent,
      remaining: remaining,
      progressDifference: progressDifference,
      projectedSpent: projectedSpent,
      projectedDifference: projectedDifference,
      started: started,
      finished: finished,
    );
  }
}
