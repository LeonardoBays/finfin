import 'package:flutter/material.dart';

import '../../../core/constants/custom_colors.dart';

class LabelForField extends StatelessWidget {
  const LabelForField({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: CustomColors.pretoTexto,
        ),
      ),
    );
  }
}
