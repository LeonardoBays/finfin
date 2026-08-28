import 'package:flutter/material.dart';

import '../../../core/constants/custom_colors.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.enable,
    required this.isVisible,
    required this.onPressed,
  });

  final bool enable;
  final bool isVisible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: IconButton(
        icon: const Icon(Icons.delete_outline, color: CustomColors.azul),
        onPressed: enable && isVisible ? onPressed : null,
      ),
    );
  }
}
