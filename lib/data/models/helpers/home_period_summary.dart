import 'package:equatable/equatable.dart';

import '../../../../../domain/models/period_spending_analysis.dart';

class HomePeriodSummary extends Equatable {
  const HomePeriodSummary({
    required this.id,
    required this.name,
    required this.startsAt,
    required this.endsAt,
    required this.limit,
    required this.spent,
    required this.remaining,
    required this.progress,
    required this.daysLeft,
    required this.periodTypeLabel,
    this.analysis,
  });

  final String id;
  final String name;
  final DateTime startsAt;
  final DateTime endsAt;
  final double limit;
  final double spent;
  final double remaining;
  final double progress;
  final int daysLeft;
  final String periodTypeLabel;
  final PeriodSpendingAnalysis? analysis;

  @override
  List<Object?> get props => [
    id,
    name,
    startsAt,
    endsAt,
    limit,
    spent,
    remaining,
    progress,
    daysLeft,
    periodTypeLabel,
    analysis,
  ];
}
