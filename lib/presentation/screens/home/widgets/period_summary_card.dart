import 'package:fin/core/constants/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../config/routes.dart';
import '../../../../data/models/helpers/home_period_summary.dart';
import '../../period/period_screen.dart';

class PeriodSummaryCard extends StatelessWidget {
  const PeriodSummaryCard({super.key, required this.summary});

  final HomePeriodSummary summary;

  BorderRadius get _borderRadius => BorderRadius.circular(16.0);

  @override
  Widget build(BuildContext context) {
    final dateRange =
        '${DateFormat('dd/MM/yyyy').format(summary.startsAt)} a ${DateFormat('dd/MM/yyyy').format(summary.endsAt)} • ${summary.periodTypeLabel}';
    final percentage = summary.progress.clamp(0.0, 1.0);

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
                    Container(width: 6.0, color: CustomColors.verde),
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
                                    color: CustomColors.verdeClaro,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    'Faltam $labelDays',
                                    style: const TextStyle(
                                      color: CustomColors.verde,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dateRange,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: CustomColors.cinza2,
                                    fontWeight: .w600,
                                  ),
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
                                      color: CustomColors.verdeClaro,
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: percentage.clamp(0.0, 1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: CustomColors.verde,
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

  void _onPressed(BuildContext context) {
    Navigator.of(context).pushNamed(
      AppRoutes.period.route,
      arguments: PeriodArguments(id: summary.id),
    );
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
