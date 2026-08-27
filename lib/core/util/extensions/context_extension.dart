import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  void showSuccessSnackBar(String message, {int seconds = 2}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: seconds),
      ),
    );
  }

  void showCustomSnackBar(
    String message, {
    required Color backgroundColor,
    required Color textColor,
    int seconds = 2,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: textColor)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: seconds),
      ),
    );
  }

  void showFailSnackBar(String message, {int seconds = 5}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: seconds),
      ),
    );
  }

  EdgeInsetsGeometry paddingETE({EdgeInsets padding = EdgeInsets.zero}) {
    return MediaQuery.of(this).padding.add(padding);
  }

  EdgeInsetsGeometry paddingETEHorizontal({
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    final leftPadding = MediaQuery.of(this).padding.left;
    final rightPadding = MediaQuery.of(this).padding.right;

    return EdgeInsets.fromLTRB(
      leftPadding + padding.left,
      padding.top,
      rightPadding + padding.right,
      padding.bottom,
    );
  }
}
