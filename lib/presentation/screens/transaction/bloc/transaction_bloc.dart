import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/period_summary_model.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../../domain/controller/user_controller.dart';
import '../../../../domain/repositories/period_summary_repository.dart';
import '../../../../domain/repositories/transaction_repository.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc(
    this._transactionRepository,
    this._periodSummaryRepository,
    this._userController,
  ) : super(const TransactionInitial()) {
    on<TransactionLoad>(_onLoad);
    on<TransactionSubmitted>(_onSubmitted);
    on<TransactionDeleted>(_onDeleted);
  }

  final TransactionRepository _transactionRepository;
  final PeriodSummaryRepository _periodSummaryRepository;
  final UserController _userController;

  FutureOr<void> _onLoad(
    TransactionLoad event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    try {
      final user = _userController.getUser();
      final periods = await _periodSummaryRepository.listByUser(user.uid);

      if (event.id == null) {
        emit(
          TransactionLoaded(
            form: const TransactionFormData(),
            periods: periods,
          ),
        );
        return;
      }

      final tx = await _transactionRepository.getById(event.id!);
      final form = TransactionFormData(
        id: tx?.id ?? '',
        description: tx?.description ?? '',
        amount: tx?.amount ?? 0,
        periodId: tx?.periodId,
      );

      emit(TransactionLoaded(form: form, periods: periods));
    } catch (e) {
      emit(TransactionError(message: e.toString()));
    }
  }

  FutureOr<void> _onSubmitted(
    TransactionSubmitted event,
    Emitter<TransactionState> emit,
  ) async {
    final form = state.form ?? const TransactionFormData();

    if (event.description.trim().isEmpty || event.amount == 0) {
      emit(
        TransactionError(
          message: 'Preencha todos os campos obrigatórios.',
          form: form,
          periods: state.periods,
        ),
      );
      return;
    }

    emit(TransactionSubmitting(form: form, periods: state.periods));

    try {
      final user = _userController.getUser();
      final transaction = TransactionModel(
        id: event.id.isEmpty ? null : event.id,
        amount: event.amount,
        description: event.description.trim(),
        periodId: (event.periodId == null || event.periodId!.isEmpty)
            ? null
            : event.periodId,
        userUid: user.uid,
      );

      if (event.id.isEmpty) {
        await _transactionRepository.create(transaction);
      } else {
        await _transactionRepository.update(transaction);
      }

      emit(
        TransactionSaved(
          form: TransactionFormData(
            id: event.id,
            description: event.description,
            amount: event.amount,
            periodId: event.periodId,
          ),
          periods: state.periods,
        ),
      );
    } catch (e) {
      emit(
        TransactionError(
          message: e.toString(),
          form: form,
          periods: state.periods,
        ),
      );
    }
  }

  FutureOr<void> _onDeleted(
    TransactionDeleted event,
    Emitter<TransactionState> emit,
  ) async {
    if (event.id.isEmpty) {
      emit(
        const TransactionError(
          message: 'Não foi possível excluir este lançamento.',
        ),
      );
      return;
    }

    try {
      await _transactionRepository.delete(event.id);
      emit(const TransactionDeletedState());
    } catch (e) {
      emit(
        TransactionError(
          message: e.toString(),
          form: state.form,
          periods: state.periods,
        ),
      );
    }
  }
}
