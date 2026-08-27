import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'injector.dart';

class App extends StatelessWidget {
  const App({super.key, required this.injector});

  final Injector injector;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Fin",
      debugShowCheckedModeBanner: false,
      theme: theme(),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      onGenerateRoute: (settings) => Routes.router(settings, injector),
    );
  }
}
