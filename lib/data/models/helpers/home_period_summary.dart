import 'package:equatable/equatable.dart';

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
  ];
}
