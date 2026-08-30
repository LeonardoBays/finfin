import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';

class HomeBalanceValue extends StatelessWidget {
  const HomeBalanceValue({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final value = (state is HomeLoaded) ? state.balance : '0,00';
        return Text.rich(
          TextSpan(
            text: 'R\$ ',
            children: [
              TextSpan(text: value, style: const TextStyle(fontSize: 40)),
            ],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
