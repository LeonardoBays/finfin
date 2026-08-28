import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';

class CutomDatePicker extends StatelessWidget {
  const CutomDatePicker({
    super.key,
    required this.value,
    required this.enable,
    required this.onPressed,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final String value;
  final bool enable;
  final Function(DateTime? date) onPressed;

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  BorderRadius get _borderRadius => BorderRadius.circular(12.0);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pickDate(context),
      borderRadius: _borderRadius,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: CustomColors.border, width: 2.0),
          borderRadius: _borderRadius,
        ),
        child: Row(
          spacing: 12.0,
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: CustomColors.pretoTexto,
            ),
            Text(value, style: const TextStyle(color: CustomColors.pretoTexto)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked == null) return;

    onPressed(picked);
    return;
  }
}
