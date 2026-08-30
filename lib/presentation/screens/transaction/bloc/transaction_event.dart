part of 'transaction_bloc.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();
}

final class TransactionLoad extends TransactionEvent {
  const TransactionLoad(this.id);

  final String? id;

  @override
  List<Object?> get props => [id];
}

final class TransactionSubmitted extends TransactionEvent {
  const TransactionSubmitted({
    required this.id,
    required this.description,
    required this.amount,
    required this.periodId,
  });

  final String id;
  final String description;
  final double amount;
  final String? periodId;

  @override
  List<Object?> get props => [id, description, amount, periodId];
}

final class TransactionDeleted extends TransactionEvent {
  const TransactionDeleted(this.id);

  final String id;

  @override
  List<Object> get props => [id];
}
