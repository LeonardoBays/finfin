import 'package:fin/presentation/screens/home/bloc/home_bloc.dart';
import 'package:fin/presentation/screens/home/widgets/home_body.dart';
import 'package:fin/presentation/screens/home/widgets/home_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_app_bar.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              const HomeAppBar(),

              // if (state is HomeLoading || state is HomeInitial)
              //   const Center(child: CircularProgressIndicator()),
              //
              // if (state is HomeError)
              //   Center(child: Text('Error: ${state.message}')),

              HomeBody(state: state),
            ],
          );
        },
      ),
      floatingActionButton: const HomeFab(),
    );
  }
}
