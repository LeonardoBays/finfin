import 'package:flutter/material.dart';

/// Abre uma tela através da navegação, de baixo para cima.
class ModalPageRoute extends PageRouteBuilder {
  ModalPageRoute({this.modalSettings, required this.builder})
    : super(
        pageBuilder: (context, _, _) => builder(context),
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        settings: modalSettings,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );

  final WidgetBuilder builder;
  final RouteSettings? modalSettings;
}
