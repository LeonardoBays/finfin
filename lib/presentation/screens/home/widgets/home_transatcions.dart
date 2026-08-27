import 'package:fin/presentation/screens/home/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/transaction_model.dart';

class HomeTransatcions extends StatelessWidget {
  const HomeTransatcions({super.key, required this.transactions});

  final List<TransactionModel> transactions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactions.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final t = transactions[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TransactionItem(transaction: t),
        );
      },
    );
  }
}
