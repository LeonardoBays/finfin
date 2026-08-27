import 'package:flutter/material.dart';

import '../../../../core/constants/custom_colors.dart';

class HomeIconAppBar extends StatelessWidget {
  const HomeIconAppBar({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(99.0),
      splashColor: CustomColors.cinzaSplash,
      child: Ink(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: CustomColors.azulClaro,
          borderRadius: BorderRadius.circular(99.0),
        ),
        child: Icon(icon, color: Colors.white, size: 22.0),
      ),
    );
  }
}
