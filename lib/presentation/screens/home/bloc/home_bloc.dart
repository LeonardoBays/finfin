import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../data/models/helpers/home_period_summary.dart';
import '../../../../data/models/period_model.dart';
import '../../../../data/models/period_summary_model.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../domain/controller/user_controller.dart';
import '../../../../domain/repositories/period_summary_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';
import '../../../../domain/services/period_spending_analysis_service.dart';

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
      const analysisService = PeriodSpendingAnalysisService();
      final periodSummaries = summaries
          .map((summary) {
            final periodTransactions = transactions
                .where((transaction) => transaction.periodId == summary.id)
                .toList();
            final analysis = analysisService.analyze(
              PeriodModel(
                id: summary.id,
                amount: summary.amount,
                endsAt: summary.endsAt,
                name: summary.name,
                periodTypeId: summary.periodTypeId,
                startsAt: summary.startsAt,
                updatedAt: DateTime.now(),
                userUid: user.uid,
              ),
              transactions: periodTransactions,
            );

            return HomePeriodSummary(
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
              analysis: analysis,
            );
          })
          .toList();

      // Compute totals using `limit` as total of period
      final totalPeriod = periodSummaries.fold<double>(0.0, (sum, s) => sum + s.limit);
      final totalTransactions = transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
      final difference = totalPeriod - totalTransactions;

      final formattedBalance =
          NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2)
              .format(difference)
              .trim();

      emit(
        HomeLoaded(
          transactions: transactions,
          periodSummaries: periodSummaries,
          balance: formattedBalance,
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
