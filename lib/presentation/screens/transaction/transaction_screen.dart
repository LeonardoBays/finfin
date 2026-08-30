import 'package:fin/presentation/screens/transaction/bloc/transaction_bloc.dart';
import 'package:fin/presentation/screens/transaction/widgets/transaction_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injector.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key, required this.arguments});

  final TransactionArguments arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TransactionBloc>(
      create: (_) => getIt.get<TransactionBloc>()..add(TransactionLoad(arguments.id)),
      child: const TransactionContent(),
    );
  }
}

class TransactionArguments {
  const TransactionArguments({this.id});

  final String? id;
}
