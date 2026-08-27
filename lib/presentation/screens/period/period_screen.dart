import 'package:fin/presentation/screens/period/bloc/period_bloc.dart';
import 'package:fin/presentation/screens/period/widgets/period_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injector.dart';

class PeriodScreen extends StatelessWidget {
  const PeriodScreen({super.key, required this.arguments});

  final PeriodArguments arguments;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PeriodBloc>(
      create: (_) => getIt.get<PeriodBloc>()..add(PeriodLoad(arguments.id)),
      child: const PeriodContent(),
    );
  }
}

class PeriodArguments {
  const PeriodArguments({this.id});

  final String? id;
}
