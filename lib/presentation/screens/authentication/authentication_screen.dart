import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes.dart';
import '../home/home_screen.dart';
import 'bloc/authentication_bloc.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key, required this.authenticationBloc});

  final AuthenticationBloc authenticationBloc;

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    _authenticationBloc = widget.authenticationBloc;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: _listener,
      bloc: _authenticationBloc,
      builder: (context, state) {
        return const HomeScreen();
      },
    );
  }

  void _listener(BuildContext context, AuthenticationState state) async {
    if (state.isUnauthenticated) {
      if (context.mounted) {
        Navigator.of(
          context,
        ).popUntil(ModalRoute.withName(AppRoutes.root.route));
      }
    }
  }
}
