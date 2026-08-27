import 'package:flutter/material.dart';

class HomeBalanceValue extends StatelessWidget {
  const HomeBalanceValue({super.key, required this.balance});

  final String balance;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'R\$ ',
        children: [
          TextSpan(text: balance, style: const TextStyle(fontSize: 40)),
        ],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
