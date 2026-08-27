import 'package:fin/presentation/screens/home/bloc/home_bloc.dart';
import 'package:fin/presentation/screens/home/widgets/transactions_header.dart';
import 'package:flutter/material.dart';

import 'home_periods.dart';
import 'home_transatcions.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key, required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 160.0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            if (state.periodSummaries.isNotEmpty) ...[
              const TransactionsHeader(label: 'Meus intervalos'),
              HomePeriods(periods: state.periodSummaries),
            ],
            const TransactionsHeader(label: 'Últimos lançamentos'),
            HomeTransatcions(transactions: state.transactions),
          ],
        ),
      ),
    );
  }
}
