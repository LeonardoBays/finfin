import 'package:flutter/material.dart';

import 'home_balance_label.dart';
import 'home_icon_app_bar.dart';

class CollapsedAppBar extends StatelessWidget {
  const CollapsedAppBar({super.key, required this.topPadding});

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight + topPadding,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const HomeSaldoLabel(balance: '1.248,53'),
            HomeIconAppBar(
              onPressed: () => _onPresed(context),
              icon: Icons.account_balance_wallet_outlined,
            ),
          ],
        ),
      ),
    );
  }

  void _onPresed(BuildContext context) {}
}
