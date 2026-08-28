import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    required this.hint,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String value)? onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        fillColor: Colors.white,
        border: _border(CustomColors.border, 2.0),
        enabledBorder: _border(CustomColors.border, 2.0),
        disabledBorder: _border(CustomColors.border, 2.0),
        focusedBorder: _border(CustomColors.azul, 2.0),
        focusedErrorBorder: _border(CustomColors.vermelho, 2.0),
        errorBorder: _border(CustomColors.vermelho, 2.0),
      ),
    );
  }

  OutlineInputBorder _border(Color borderColor, double borderWidth) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.circular(12.0),
    );
  }
}
