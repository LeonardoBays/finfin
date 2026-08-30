import 'package:fin/presentation/screens/transaction/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../componenets/widgets/delete_button.dart';
import 'transaction_home.dart';

class TransactionContent extends StatelessWidget {
  const TransactionContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionSaved || state is TransactionDeletedState) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          final hasId = state.form?.id.isNotEmpty ?? false;

          return Scaffold(
            appBar: AppBar(
              title: Text(
                hasId ? 'Editar lançamento' : 'Novo lançamento',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              actions: [
                DeleteButton(
                  enable: hasId,
                  isVisible: hasId,
                  onPressed: () {
                    final id = state.form!.id;
                    if (id.isEmpty) return;
                    context.read<TransactionBloc>().add(TransactionDeleted(id));
                  },
                ),
              ],
            ),
            body: TransactionHome(state: state),
          );
        },
      ),
    );
  }
}
