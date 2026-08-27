import 'package:fin/presentation/screens/home/widgets/period_summary_card.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/helpers/home_period_summary.dart';

class HomePeriods extends StatelessWidget {
  const HomePeriods({super.key, required this.periods});

  final List<HomePeriodSummary> periods;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: periods.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final summary = periods[index];

        return PeriodSummaryCard(summary: summary);
      },
      separatorBuilder: (_, _) {
        return const SizedBox(height: 16);
      },
    );
  }
}
