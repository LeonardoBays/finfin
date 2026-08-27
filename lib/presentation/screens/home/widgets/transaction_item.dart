import 'package:fin/data/models/transaction_model.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({super.key, required this.transaction});

  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    final amountNum = transaction.amount;
    final amount = (amountNum as num).toDouble();
    const sign = '-';
    final displayAmount = '$sign R\$ ${amount.abs().toStringAsFixed(2)}';

    const leadingIcon = Icons.shopping_basket_outlined;
    final bgColor = Colors.green[50];
    const iconColor = Colors.green;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(leadingIcon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              transaction.description,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: .w600),
              maxLines: 2,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            displayAmount,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
