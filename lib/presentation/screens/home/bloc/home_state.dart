part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState({
    this.transactions = const [],
    this.periodSummaries = const [],
    this.balance = '',
  });

  final List<TransactionModel> transactions;
  final List<HomePeriodSummary> periodSummaries;
  final String balance;

  @override
  List<Object?> get props => [transactions, periodSummaries, balance];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required super.transactions,
    required super.periodSummaries,
    required super.balance,
  });
}

final class HomeError extends HomeState {
  const HomeError({
    required this.message,
    super.transactions,
    super.periodSummaries,
    super.balance,
  });

  final String message;

  @override
  List<Object?> get props => [message, transactions, periodSummaries, balance];
}
