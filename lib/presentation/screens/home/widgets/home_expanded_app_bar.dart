import 'package:fin/presentation/screens/home/widgets/home_balance_btn.dart';
import 'package:flutter/material.dart';

import 'home_balance_label.dart';
import 'home_balance_value.dart';

class HomeExpandedAppBar extends StatelessWidget {
  const HomeExpandedAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12.0)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                spacing: 2.0,
                children: [
                  HomeSaldoLabel(),
                  HomeBalanceValue(balance: '1.248,53'),
                  HomeBalanceBtn(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
