import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class IntervaloContainer extends StatelessWidget {
  const IntervaloContainer({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
    required this.enable,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;
  final bool enable;

  BorderRadius get _borderRadius => BorderRadius.circular(12.0);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        borderRadius: _borderRadius,
        color: selected ? CustomColors.azulinho : Colors.white,
        child: InkWell(
          borderRadius: _borderRadius,
          onTap: enable ? onPressed : null,
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              borderRadius: _borderRadius,
              border: Border.all(
                color: selected ? CustomColors.azul : CustomColors.border,
                width: 2.0,
              ),
            ),
            child: Column(
              spacing: 4.0,
              children: [
                Icon(
                  icon,
                  size: 32.0,
                  color: selected ? CustomColors.azul : CustomColors.pretoTexto,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: .w600,
                    color: selected
                        ? CustomColors.azul
                        : CustomColors.pretoTexto,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
