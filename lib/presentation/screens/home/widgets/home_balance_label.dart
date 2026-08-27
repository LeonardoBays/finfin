import 'package:flutter/material.dart';

class HomeSaldoLabel extends StatelessWidget {
  const HomeSaldoLabel({super.key, this.balance});

  final String? balance;

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Saldo atual',
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
