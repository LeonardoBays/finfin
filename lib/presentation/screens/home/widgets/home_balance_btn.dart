import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class HomeBalanceBtn extends StatelessWidget {
  const HomeBalanceBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: CustomColors.azulClaro,
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      ),
      icon: const Icon(Icons.account_balance_wallet_outlined, size: 18),
      label: const Text('Sua situação financeira'),
    );
  }
}
