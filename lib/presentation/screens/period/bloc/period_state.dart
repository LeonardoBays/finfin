part of 'period_bloc.dart';

class PeriodFormData extends Equatable {
  const PeriodFormData({
    this.id = '',
    this.name = '',
    this.startsAt,
    this.endsAt,
    this.amount = 0,
    this.periodTypeId = 0,
  });

  final String id;
  final String name;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final double amount;
  final int periodTypeId;

  PeriodFormData copyWith({
    String? id,
    String? name,
    DateTime? startsAt,
    DateTime? endsAt,
    double? amount,
    int? periodTypeId,
  }) {
    return PeriodFormData(
      id: id ?? this.id,
      name: name ?? this.name,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      amount: amount ?? this.amount,
      periodTypeId: periodTypeId ?? this.periodTypeId,
    );
  }

  @override
  List<Object?> get props => [id, name, startsAt, endsAt, amount, periodTypeId];
}

sealed class PeriodState extends Equatable {
  const PeriodState({this.form, this.isSubmitting = false, this.errorMessage});

  final PeriodFormData? form;
  final bool isSubmitting;
  final String? errorMessage;

  @override
  List<Object?> get props => [form, isSubmitting, errorMessage];
}

final class PeriodInitial extends PeriodState {
  const PeriodInitial();
}

final class PeriodLoading extends PeriodState {
  const PeriodLoading({super.form, super.errorMessage});
}

final class PeriodLoaded extends PeriodState {
  const PeriodLoaded({required super.form}) : super();
}

final class PeriodSaved extends PeriodState {
  const PeriodSaved({required super.form});
}

final class PeriodSubmitting extends PeriodState {
  const PeriodSubmitting({required super.form});
}

final class PeriodError extends PeriodState {
  const PeriodError({required this.message, super.form})
    : super(errorMessage: message);

  final String message;

  @override
  List<Object?> get props => [message, form, isSubmitting, errorMessage];
}

final class PeriodDeletedState extends PeriodState {
  const PeriodDeletedState();
}
