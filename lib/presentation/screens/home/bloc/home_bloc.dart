import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/helpers/home_period_summary.dart';
import '../../../../data/models/period_summary_model.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../domain/controller/user_controller.dart';
import '../../../../domain/repositories/period_summary_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this._transactionRepository,
    this._periodSummaryRepository,
    this._userController,
  ) : super(const HomeInitial()) {
    on<HomeLoad>(_onHomeLoad);
  }

  final TransactionRepository _transactionRepository;
  final PeriodSummaryRepository _periodSummaryRepository;
  final UserController _userController;

  FutureOr<void> _onHomeLoad(HomeLoad event, Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    try {
      final user = _userController.getUser();

      final results = await Future.wait([
        _transactionRepository.listByUser(user.uid),
        _periodSummaryRepository.listByUser(user.uid),
      ]);

      final transactions = results[0] as List<TransactionModel>;
      final summaries = (results[1] as List<PeriodSummaryModel>?) ?? const [];
      final periodSummaries = summaries
          .map(
            (summary) => HomePeriodSummary(
              id: summary.id,
              name: summary.name.isNotEmpty ? summary.name : 'Período atual',
              startsAt: summary.startsAt,
              endsAt: summary.endsAt,
              limit: summary.amount,
              spent: summary.totalSpent,
              remaining: summary.remaining,
              progress: summary.percentage,
              daysLeft: summary.daysLeft,
              periodTypeLabel: _periodTypeLabel(summary.periodTypeId),
            ),
          )
          .toList();

      emit(
        HomeLoaded(
          transactions: transactions,
          periodSummaries: periodSummaries,
        ),
      );
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  String _periodTypeLabel(int periodTypeId) {
    switch (periodTypeId) {
      case 1:
        return 'Semanal';
      case 2:
        return 'Mensal';
      case 3:
        return 'Anual';
      default:
        return 'Período';
    }
  }
}
