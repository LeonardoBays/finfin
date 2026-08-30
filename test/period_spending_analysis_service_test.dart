import 'package:fin/data/models/period_model.dart';
import 'package:fin/data/models/transaction_model.dart';
import 'package:fin/domain/models/period_spending_analysis.dart';
import 'package:fin/domain/services/period_spending_analysis_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const service = PeriodSpendingAnalysisService();

  group('PeriodSpendingAnalysisService', () {
    test('period has not started', () {
      final now = DateTime(2026, 1, 15, 12);
      final period = PeriodModel(
        amount: 100,
        endsAt: now.add(const Duration(days: 10)),
        name: 'Jan',
        periodTypeId: 1,
        startsAt: now.add(const Duration(days: 1)),
        updatedAt: now,
        userUid: 'user-1',
      );

      final analysis = service.analyze(period, now: now);

      expect(analysis.started, isFalse);
      expect(analysis.timeProgress, 0.0);
      expect(analysis.status, PeriodSpendingStatus.onTrack);
      expect(analysis.expectedSpent, 0.0);
    });

    test('period is halfway through and spending is on track', () {
      final now = DateTime(2026, 1, 15, 12);
      final period = PeriodModel(
        amount: 100,
        endsAt: now.add(const Duration(days: 5)),
        name: 'Jan',
        periodTypeId: 1,
        startsAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
        userUid: 'user-1',
      );

      final analysis = service.analyze(
        period,
        transactions: [
          TransactionModel(
            amount: 50,
            description: 'spent half',
            periodId: 'period-1',
            userUid: 'user-1',
          ),
        ],
        now: now,
      );

      expect(analysis.timeProgress, closeTo(0.5, 0.0001));
      expect(analysis.spentProgress, closeTo(0.5, 0.0001));
      expect(analysis.progressDifference, closeTo(0.0, 0.0001));
      expect(analysis.status, PeriodSpendingStatus.onTrack);
    });

    test(
      'period is halfway through and spending reaches the warning threshold',
      () {
        final now = DateTime(2026, 1, 15, 12);
        final period = PeriodModel(
          amount: 100,
          endsAt: now.add(const Duration(days: 5)),
          name: 'Jan',
          periodTypeId: 1,
          startsAt: now.subtract(const Duration(days: 5)),
          updatedAt: now,
          userUid: 'user-1',
        );

        final analysis = service.analyze(
          period,
          transactions: [
            TransactionModel(
              amount: 60,
              description: 'warning spend',
              periodId: 'period-1',
              userUid: 'user-1',
            ),
          ],
          now: now,
        );

        expect(analysis.progressDifference, closeTo(0.1, 0.0001));
        expect(analysis.status, PeriodSpendingStatus.warning);
      },
    );

    test(
      'period is halfway through and spending reaches the danger threshold',
      () {
        final now = DateTime(2026, 1, 15, 12);
        final period = PeriodModel(
          amount: 100,
          endsAt: now.add(const Duration(days: 5)),
          name: 'Jan',
          periodTypeId: 1,
          startsAt: now.subtract(const Duration(days: 5)),
          updatedAt: now,
          userUid: 'user-1',
        );

        final analysis = service.analyze(
          period,
          transactions: [
            TransactionModel(
              amount: 70,
              description: 'danger spend',
              periodId: 'period-1',
              userUid: 'user-1',
            ),
          ],
          now: now,
        );

        expect(analysis.progressDifference, closeTo(0.2, 0.0001));
        expect(analysis.status, PeriodSpendingStatus.danger);
      },
    );

    test('budget is exceeded', () {
      final now = DateTime(2026, 1, 15, 12);
      final period = PeriodModel(
        amount: 100,
        endsAt: now.add(const Duration(days: 5)),
        name: 'Jan',
        periodTypeId: 1,
        startsAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
        userUid: 'user-1',
      );

      final analysis = service.analyze(
        period,
        transactions: [
          TransactionModel(
            amount: 120,
            description: 'over budget',
            periodId: 'period-1',
            userUid: 'user-1',
          ),
        ],
        now: now,
      );

      expect(analysis.status, PeriodSpendingStatus.exceeded);
      expect(analysis.remaining, 0.0);
      expect(analysis.spent, 120.0);
    });

    test('period has finished without exceeding the budget', () {
      final now = DateTime(2026, 1, 15, 12);
      final period = PeriodModel(
        amount: 100,
        endsAt: now.subtract(const Duration(days: 1)),
        name: 'Jan',
        periodTypeId: 1,
        startsAt: now.subtract(const Duration(days: 10)),
        updatedAt: now,
        userUid: 'user-1',
      );

      final analysis = service.analyze(
        period,
        transactions: [
          TransactionModel(
            amount: 75,
            description: 'finished on track',
            periodId: 'period-1',
            userUid: 'user-1',
          ),
        ],
        now: now,
      );

      expect(analysis.finished, isTrue);
      expect(analysis.timeProgress, closeTo(1.0, 0.0001));
      expect(analysis.status, PeriodSpendingStatus.onTrack);
    });

    test('no transactions', () {
      final now = DateTime(2026, 1, 15, 12);
      final period = PeriodModel(
        amount: 100,
        endsAt: now.add(const Duration(days: 10)),
        name: 'Jan',
        periodTypeId: 1,
        startsAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
        userUid: 'user-1',
      );

      final analysis = service.analyze(period, now: now);

      expect(analysis.spent, 0.0);
      expect(analysis.remaining, 100.0);
      expect(analysis.status, PeriodSpendingStatus.onTrack);
    });

    test('budget is zero', () {
      final now = DateTime(2026, 1, 15, 12);
      final period = PeriodModel(
        amount: 0,
        endsAt: now.add(const Duration(days: 10)),
        name: 'Jan',
        periodTypeId: 1,
        startsAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
        userUid: 'user-1',
      );

      final analysis = service.analyze(
        period,
        transactions: [
          TransactionModel(
            amount: 20,
            description: 'zero budget',
            periodId: 'period-1',
            userUid: 'user-1',
          ),
        ],
        now: now,
      );

      expect(analysis.status, PeriodSpendingStatus.exceeded);
      expect(analysis.remaining, 0.0);
    });

    test('invalid period dates', () {
      final now = DateTime(2026, 1, 15, 12);
      final period = PeriodModel(
        amount: 100,
        endsAt: now.subtract(const Duration(days: 2)),
        name: 'Jan',
        periodTypeId: 1,
        startsAt: now,
        updatedAt: now,
        userUid: 'user-1',
      );

      final analysis = service.analyze(period, now: now);

      expect(analysis.status, PeriodSpendingStatus.onTrack);
      expect(analysis.timeProgress, 0.0);
      expect(analysis.remaining, 0.0);
    });

    test('projection calculation', () {
      final now = DateTime(2026, 1, 15, 12);
      final period = PeriodModel(
        amount: 100,
        endsAt: now.add(const Duration(days: 5)),
        name: 'Jan',
        periodTypeId: 1,
        startsAt: now.subtract(const Duration(days: 5)),
        updatedAt: now,
        userUid: 'user-1',
      );

      final analysis = service.analyze(
        period,
        transactions: [
          TransactionModel(
            amount: 75,
            description: 'projection test',
            periodId: 'period-1',
            userUid: 'user-1',
          ),
        ],
        now: now,
      );

      expect(analysis.projectedSpent, closeTo(150.0, 0.0001));
      expect(analysis.projectedDifference, closeTo(50.0, 0.0001));
    });
  });
}
