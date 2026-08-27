import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/models/period_model.dart';
import '../../../../domain/controller/user_controller.dart';
import '../../../../domain/repositories/period_repository.dart';

part 'period_event.dart';
part 'period_state.dart';

class PeriodBloc extends Bloc<PeriodEvent, PeriodState> {
  PeriodBloc(this._periodRepository, this._userController)
    : super(const PeriodInitial()) {
    on<PeriodLoad>(_onPeriodLoad);
    on<PeriodSubmitted>(_onPeriodSubmitted);
    on<PeriodDeleted>(_onPeriodDeleted);
  }

  final PeriodRepository _periodRepository;
  final UserController _userController;

  FutureOr<void> _onPeriodLoad(
    PeriodLoad event,
    Emitter<PeriodState> emit,
  ) async {
    emit(const PeriodLoading());

    try {
      final id = event.id;

      PeriodModel? period;

      if (id != null) {
        period = await _periodRepository.getById(id);
      }

      emit(
        PeriodLoaded(
          form: PeriodFormData(
            id: period?.id ?? '',
            name: period?.name ?? '',
            startsAt: period?.startsAt,
            endsAt: period?.endsAt,
            amount: period?.amount ?? 0,
            periodTypeId: period?.periodTypeId ?? 0,
          ),
        ),
      );
    } catch (e) {
      emit(PeriodError(message: e.toString()));
    }
  }

  FutureOr<void> _onPeriodSubmitted(
    PeriodSubmitted event,
    Emitter<PeriodState> emit,
  ) async {
    final form = state.form ?? const PeriodFormData();

    final errors = _validateForm(
      name: event.name,
      startsAt: event.startsAt,
      endsAt: event.endsAt,
      amount: event.amount,
    );

    if (errors != null) {
      emit(PeriodError(message: errors, form: form));
      return;
    }

    emit(
      PeriodSubmitting(
        form: form.copyWith(
          id: event.id,
          name: event.name,
          startsAt: event.startsAt,
          endsAt: event.endsAt,
          amount: event.amount,
          periodTypeId: event.periodTypeId,
        ),
      ),
    );

    try {
      final user = _userController.getUser();
      final period = PeriodModel(
        id: event.id.isEmpty ? null : event.id,
        amount: event.amount,
        endsAt: event.endsAt,
        name: event.name.trim(),
        periodTypeId: event.periodTypeId,
        startsAt: event.startsAt,
        updatedAt: DateTime.now(),
        userUid: user.uid,
      );

      if (event.id.isEmpty) {
        await _periodRepository.create(period);
      } else {
        await _periodRepository.update(period);
      }

      emit(
        PeriodSaved(
          form: PeriodFormData(
            id: event.id,
            name: event.name.trim(),
            startsAt: event.startsAt,
            endsAt: event.endsAt,
            amount: event.amount,
            periodTypeId: event.periodTypeId,
          ),
        ),
      );
    } catch (e) {
      emit(PeriodError(message: e.toString(), form: form));
    }
  }

  FutureOr<void> _onPeriodDeleted(
    PeriodDeleted event,
    Emitter<PeriodState> emit,
  ) async {
    if (event.id.isEmpty) {
      emit(
        const PeriodError(message: 'Não foi possível excluir este intervalo.'),
      );
      return;
    }

    try {
      await _periodRepository.delete(event.id);
      emit(const PeriodDeletedState());
    } catch (e) {
      emit(PeriodError(message: e.toString(), form: state.form));
    }
  }

  String? _validateForm({
    required String name,
    required DateTime startsAt,
    required DateTime endsAt,
    required double amount,
  }) {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      return 'Informe o nome do intervalo.';
    }

    final minimumStart = DateTime.now().subtract(const Duration(days: 30));
    if (startsAt.isBefore(minimumStart)) {
      return 'A data de início não pode ser mais antiga que 30 dias atrás.';
    }

    if (endsAt.isBefore(startsAt) || endsAt.isAtSameMomentAs(startsAt)) {
      return 'A data de término deve ser maior que a data de início.';
    }

    if (amount <= 0) {
      return 'Informe um valor planejado válido.';
    }

    return null;
  }
}
