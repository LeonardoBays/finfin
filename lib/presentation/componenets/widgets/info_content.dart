import 'package:flutter/material.dart';

import '../../../core/constants/custom_colors.dart';

class InfoContent extends StatelessWidget {
  const InfoContent._({
    super.key,
    required this.label,
    required this.iconColor,
    required this.backgroundColor,
    required this.fontColor,
  });

  const InfoContent.warning({required String label, final Key? key})
    : this._(
        label: label,
        backgroundColor: CustomColors.azulinho,
        fontColor: CustomColors.pretoTexto,
        iconColor: CustomColors.azul,
        key: key,
      );

  const InfoContent.error({required String label, final Key? key})
    : this._(
        label: label,
        backgroundColor: CustomColors.vermelhinho,
        fontColor: CustomColors.pretoTexto,
        iconColor: CustomColors.vermelho,
        key: key,
      );

  final String label;

  final Color iconColor;
  final Color backgroundColor;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IntrinsicHeight(
        child: Row(
          spacing: 12.0,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Icon(Icons.info_outline, color: iconColor, size: 24),
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: fontColor,
                  fontWeight: .w600,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
