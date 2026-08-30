import 'package:equatable/equatable.dart';

enum PeriodSpendingStatus { onTrack, warning, danger, exceeded }

class PeriodSpendingAnalysis extends Equatable {
  const PeriodSpendingAnalysis({
    required this.status,
    required this.timeProgress,
    required this.spentProgress,
    required this.expectedSpent,
    required this.spent,
    required this.remaining,
    required this.progressDifference,
    required this.projectedSpent,
    required this.projectedDifference,
    required this.started,
    required this.finished,
  });

  final PeriodSpendingStatus status;
  final double timeProgress;
  final double spentProgress;
  final double expectedSpent;
  final double spent;
  final double remaining;
  final double progressDifference;
  final double projectedSpent;
  final double projectedDifference;
  final bool started;
  final bool finished;

  @override
  List<Object?> get props => [
    status,
    timeProgress,
    spentProgress,
    expectedSpent,
    spent,
    remaining,
    progressDifference,
    projectedSpent,
    projectedDifference,
    started,
    finished,
  ];
}
