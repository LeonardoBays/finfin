import 'package:flutter/material.dart';

import '../../../../core/constants/custom_colors.dart';

class TransactionsHeader extends StatelessWidget {
  const TransactionsHeader({super.key, this.onViewAll, required this.label});

  final VoidCallback? onViewAll;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: onViewAll,
            child: const Text(
              'Ver todos',
              style: TextStyle(color: CustomColors.azul, fontWeight: .bold),
            ),
          ),
        ],
      ),
    );
  }
}
