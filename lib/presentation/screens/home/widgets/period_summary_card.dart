import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../config/routes.dart';
import '../../../../data/models/helpers/home_period_summary.dart';
import '../../../../domain/models/period_spending_analysis.dart';
import '../../period/period_screen.dart';
import '../bloc/home_bloc.dart';

class PeriodSummaryCard extends StatelessWidget {
  const PeriodSummaryCard({super.key, required this.summary});

  final HomePeriodSummary summary;

  BorderRadius get _borderRadius => BorderRadius.circular(16.0);

  @override
  Widget build(BuildContext context) {
    final dateRange =
        '${DateFormat('dd/MM/yyyy').format(summary.startsAt)} a ${DateFormat('dd/MM/yyyy').format(summary.endsAt)}';
    final percentage = summary.progress.clamp(0.0, 100.0);
    final barProgress = (percentage / 100).clamp(0.0, 1.0);
    final statusColor = _statusColor(summary.analysis?.status);

    final currency = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    final labelDays = summary.daysLeft == 1
        ? '1 dia'
        : '${summary.daysLeft} dias';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Material(
        borderRadius: _borderRadius,
        elevation: .5,
        child: InkWell(
          onTap: () => _onPressed(context),
          borderRadius: _borderRadius,
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: _borderRadius,
              border: const Border(
                bottom: BorderSide(color: CustomColors.border),
                top: BorderSide(color: CustomColors.border),
                right: BorderSide(color: CustomColors.border),
              ),
            ),
            child: IntrinsicHeight(
              child: ClipRRect(
                borderRadius: _borderRadius,
                child: Row(
                  children: [
                    Container(width: 6.0, color: statusColor),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    summary.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1B1B1B),
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withAlpha(26),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'Faltam $labelDays',
                                    style: TextStyle(
                                      color: statusColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    dateRange,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: CustomColors.cinza2,
                                          fontWeight: .w600,
                                        ),
                                  ),
                                ),
                                // if (summary.analysis != null)
                                //   Container(
                                //     margin: const EdgeInsets.only(left: 8),
                                //     padding: const EdgeInsets.symmetric(
                                //       horizontal: 8,
                                //       vertical: 4,
                                //     ),
                                //     decoration: BoxDecoration(
                                //       color: statusColor.withAlpha(26),
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //     child: Text(
                                //       statusLabel,
                                //       style: TextStyle(
                                //         color: statusColor,
                                //         fontSize: 11,
                                //         fontWeight: FontWeight.w700,
                                //       ),
                                //     ),
                                //   ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            Row(
                              spacing: 12.0,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: Container(
                                      height: 20,
                                      color: statusColor.withAlpha(26),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: barProgress,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: statusColor,
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${percentage.round()}%',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF1B1B1B),
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _SummaryMetric(
                                    label: 'Limite',
                                    value: currency.format(summary.limit),
                                  ),
                                ),
                                Expanded(
                                  child: _SummaryMetric(
                                    label: 'Gasto',
                                    value: currency.format(summary.spent),
                                  ),
                                ),
                                Expanded(
                                  child: _SummaryMetric(
                                    label: 'Restante',
                                    value: currency.format(summary.remaining),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _statusColor(PeriodSpendingStatus? status) {
    switch (status) {
      case PeriodSpendingStatus.exceeded:
        return const Color(0xFFB3261E);
      case PeriodSpendingStatus.danger:
        return const Color(0xFFB95F00);
      case PeriodSpendingStatus.warning:
        return const Color(0xFFE9A100);
      case PeriodSpendingStatus.onTrack:
      default:
        return CustomColors.verde;
    }
  }

  void _onPressed(BuildContext context) async {
    await Navigator.of(context).pushNamed(
      AppRoutes.period.route,
      arguments: PeriodArguments(id: summary.id),
    );

    if (context.mounted) {
      context.read<HomeBloc>().add(const HomeLoad());
    }
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: CustomColors.cinza1,
            fontWeight: .w600,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B1B1B),
          ),
        ),
      ],
    );
  }
}
