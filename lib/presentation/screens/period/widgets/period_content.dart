import 'package:fin/presentation/screens/period/widgets/period_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF2051C9)),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                hasId ? 'Editar intervalo' : 'Novo intervalo',
                style: const TextStyle(
                  color: Color(0xFF1B1B1B),
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: false,
              actions: [
                if (hasId)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Color(0xFF2051C9),
                    ),
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
