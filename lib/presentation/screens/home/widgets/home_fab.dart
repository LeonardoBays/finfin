import 'package:fin/config/routes.dart';
import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../period/period_screen.dart';
import '../../transaction/transaction_screen.dart';
import '../bloc/home_bloc.dart';

class HomeFab extends StatelessWidget {
  const HomeFab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'transaction',
          onPressed: () => _createPeriod(context),
          backgroundColor: CustomColors.azul,
          child: const Icon(Icons.calendar_month_outlined, color: Colors.white),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'period',
          onPressed: () => _createTransaction(context),
          backgroundColor: CustomColors.azul,
          child: const Icon(
            Icons.monetization_on_outlined,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  void _createPeriod(BuildContext context) async {
    await Navigator.of(
      context,
    ).pushNamed(AppRoutes.period.route, arguments: const PeriodArguments());

    if (context.mounted) {
      context.read<HomeBloc>().add(const HomeLoad());
    }
  }

  void _createTransaction(BuildContext context) async {
    await Navigator.of(
      context,
    ).pushNamed(AppRoutes.transactions.route, arguments: const TransactionArguments());

    if (context.mounted) {
      context.read<HomeBloc>().add(const HomeLoad());
    }
  }
}
