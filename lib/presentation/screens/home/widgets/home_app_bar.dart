import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';

import 'home_colapsed_app_bar.dart';
import 'home_expanded_app_bar.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      pinned: true,
      floating: true,
      stretch: true,
      snap: true,
      expandedHeight: 190,
      collapsedHeight: kToolbarHeight,
      backgroundColor: CustomColors.azul,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isCollapsed =
              constraints.maxHeight <= kToolbarHeight + topPadding;

          return SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isCollapsed
                  ? CollapsedAppBar(topPadding: topPadding)
                  : const HomeExpandedAppBar(),
            ),
          );
        },
      ),
    );
  }
}
