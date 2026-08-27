import 'package:flutter/material.dart';

import '../injector.dart';
import '../presentation/componenets/animation/modal_page_route.dart';
import '../presentation/screens/authentication/authentication_screen.dart';
import '../presentation/screens/authentication/bloc/authentication_bloc.dart';
import '../presentation/screens/period/period_screen.dart';

enum NavigationFlow { simple, modalBottomUp }

enum AppRoutes {
  root('/', NavigationFlow.simple),
  period('/period', NavigationFlow.modalBottomUp);

  const AppRoutes(this.route, this.flow);

  final String route;
  final NavigationFlow flow;

  static AppRoutes fromName(String? screenName) {
    return AppRoutes.values.firstWhere(
      (e) => e.route == screenName,
      orElse: () => root,
    );
  }
}

class Routes {
  static PageRoute router(RouteSettings settings, Injector injector) {
    final appRoute = AppRoutes.fromName(settings.name);

    final screen = switch (appRoute) {
      AppRoutes.root => AuthenticationScreen(
        authenticationBloc: injector.getIt.get<AuthenticationBloc>(),
      ),
      AppRoutes.period => PeriodScreen(
        arguments: settings.arguments as PeriodArguments,
      ),
    };

    return switch (appRoute.flow) {
      NavigationFlow.modalBottomUp => ModalPageRoute(
        builder: (context) => screen,
        modalSettings: settings,
      ),
      NavigationFlow.simple => MaterialPageRoute(
        builder: (context) => screen,
        settings: settings,
      ),
    };
  }
}
