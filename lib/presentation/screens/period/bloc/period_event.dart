part of 'period_bloc.dart';

sealed class PeriodEvent extends Equatable {
  const PeriodEvent();
}

final class PeriodLoad extends PeriodEvent {
  const PeriodLoad(this.id);

  final String? id;

  @override
  List<Object?> get props => [id];
}

final class PeriodSubmitted extends PeriodEvent {
  const PeriodSubmitted({
    required this.id,
    required this.name,
    required this.startsAt,
    required this.endsAt,
    required this.amount,
    required this.periodTypeId,
  });

  final String id;
  final String name;
  final DateTime startsAt;
  final DateTime endsAt;
  final double amount;
  final int periodTypeId;

  @override
  List<Object?> get props => [id, name, startsAt, endsAt, amount, periodTypeId];
}

final class PeriodDeleted extends PeriodEvent {
  const PeriodDeleted(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}
