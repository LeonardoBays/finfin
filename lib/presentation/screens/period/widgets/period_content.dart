import 'package:fin/presentation/screens/period/widgets/period_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../componenets/widgets/delete_button.dart';
import '../bloc/period_bloc.dart';

class PeriodContent extends StatelessWidget {
  const PeriodContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<PeriodBloc, PeriodState>(
      listener: (context, state) {
        if (state is PeriodSaved || state is PeriodDeletedState) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<PeriodBloc, PeriodState>(
        builder: (context, state) {
          final hasId = state.form?.id.isNotEmpty ?? false;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                hasId ? 'Editar intervalo' : 'Novo intervalo',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              actions: [
                if (hasId)
                  DeleteButton(
                    enable: hasId,
                    isVisible: hasId,
                    onPressed: () {
                      final id = state.form!.id;
                      if (id.isEmpty) return;
                      context.read<PeriodBloc>().add(PeriodDeleted(id));
                    },
                  ),
              ],
            ),
            body: PeriodHome(state: state),
          );
        },
      ),
    );
  }
}
