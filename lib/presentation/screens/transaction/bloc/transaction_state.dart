part of 'transaction_bloc.dart';

class TransactionFormData extends Equatable {
  const TransactionFormData({
    this.id = '',
    this.description = '',
    this.amount = 0,
    this.periodId,
  });

  final String id;
  final String description;
  final double amount;
  final String? periodId;

  TransactionFormData copyWith({
    String? id,
    String? description,
    double? amount,
    String? periodId,
  }) {
    return TransactionFormData(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      periodId: periodId ?? this.periodId,
    );
  }

  @override
  List<Object?> get props => [id, description, amount, periodId];
}

sealed class TransactionState extends Equatable {
  const TransactionState({this.form, this.periods = const [], this.errorMessage});

  final TransactionFormData? form;
  final List<PeriodSummaryModel> periods;
  final String? errorMessage;

  @override
  List<Object?> get props => [form, periods, errorMessage];
}

final class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

final class TransactionLoading extends TransactionState {
  const TransactionLoading({super.form, super.periods, super.errorMessage});
}

final class TransactionLoaded extends TransactionState {
  const TransactionLoaded({required super.form, required super.periods});
}

final class TransactionSaved extends TransactionState {
  const TransactionSaved({required super.form, required super.periods});
}

final class TransactionSubmitting extends TransactionState {
  const TransactionSubmitting({required super.form, required super.periods});
}

final class TransactionError extends TransactionState {
  const TransactionError({required this.message, super.form, super.periods}) : super(errorMessage: message);

  final String message;

  @override
  List<Object?> get props => [message, form, periods, errorMessage];
}

final class TransactionDeletedState extends TransactionState {
  const TransactionDeletedState();
}
