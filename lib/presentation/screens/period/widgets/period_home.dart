import 'package:fin/presentation/screens/period/bloc/period_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../componenets/widgets/custom_elevated_button.dart';
import '../../../componenets/widgets/custom_text_field.dart';
import '../../../componenets/widgets/cutom_date_picker.dart';
import '../../../componenets/widgets/info_content.dart';
import '../../../componenets/widgets/intervalo_container.dart';
import '../../../componenets/widgets/label_for_field.dart';

class PeriodHome extends StatefulWidget {
  const PeriodHome({super.key, required this.state});

  final PeriodState state;

  @override
  State<PeriodHome> createState() => _PeriodHomeState();
}

class _PeriodHomeState extends State<PeriodHome> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;

  late DateTime _selectedStart;
  late DateTime _selectedEnd;
  int _periodTypeId = 0;

  @override
  void initState() {
    super.initState();

    final dtNow = DateTime.now();
    _selectedStart = dtNow;

    _selectedEnd = dtNow.add(const Duration(days: 1));

    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _syncFromState(widget.state.form);
  }

  @override
  void didUpdateWidget(covariant PeriodHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.form != oldWidget.state.form) {
      _syncFromState(widget.state.form);
    }
  }

  void _syncFromState(PeriodFormData? form) {
    final nextName = form?.name ?? '';
    final nextAmount = form?.amount ?? 0;
    final nextStart = form?.startsAt;
    final nextEnd = form?.endsAt;
    final nextType = form?.periodTypeId ?? 0;

    if (_nameController.text != nextName) {
      _nameController.text = nextName;
      _nameController.selection = TextSelection.collapsed(
        offset: _nameController.text.length,
      );
    }

    if (nextAmount > 0 &&
        _amountController.text != _formatCurrency(nextAmount)) {
      _amountController.text = _formatCurrency(nextAmount);
      _amountController.selection = TextSelection.collapsed(
        offset: _amountController.text.length,
      );
    } else if (nextAmount <= 0 && _amountController.text.isNotEmpty) {
      _amountController.clear();
    }

    if (nextStart != null && _selectedStart != nextStart) {
      _selectedStart = nextStart;
    }

    if (nextEnd != null && _selectedEnd != nextEnd) {
      _selectedEnd = nextEnd;
    }

    _periodTypeId = nextType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String _formatCurrency(double value) {
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  double _parseCurrency(String text) {
    final digits = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return 0;
    return int.parse(digits) / 100;
  }

  void _submit(BuildContext context) {
    final name = _nameController.text.trim();
    final startsAt = _selectedStart;
    final endsAt = _selectedEnd;
    final amount = _parseCurrency(_amountController.text);

    if (name.isEmpty || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    context.read<PeriodBloc>().add(
      PeriodSubmitted(
        id: widget.state.form?.id ?? '',
        name: name,
        startsAt: startsAt,
        endsAt: endsAt,
        amount: amount,
        periodTypeId: _periodTypeId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = widget.state is PeriodSubmitting;
    final error = widget.state is PeriodError
        ? (widget.state as PeriodError).message
        : null;

    return SingleChildScrollView(
      padding: MediaQuery.of(
        context,
      ).padding.add(const EdgeInsets.fromLTRB(16, 12, 16, 28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) InfoContent.error(label: error),
          const LabelForField(label: 'Nome do intervalo'),
          CustomTextField(
            controller: _nameController,
            hint: 'Ex.: Mercado Julho',
          ),
          const SizedBox(height: 18),
          const LabelForField(label: 'Tipo de intervalo'),
          Row(
            spacing: 12.0,
            children: [
              IntervaloContainer(
                icon: Icons.calendar_month_outlined,
                label: 'Dias',
                onPressed: () {},
                enable: true,
                selected: true,
              ),
            ],
          ),
          const SizedBox(height: 18),
          const LabelForField(label: 'Data de início'),
          CutomDatePicker(
            value: DateFormat('dd/MM/yyyy').format(_selectedStart),
            enable: true,
            initialDate: _selectedStart,
            firstDate: DateTime(2026),
            lastDate: _selectedEnd.subtract(const Duration(days: 1)),
            onPressed: _onStartDateChange,
          ),
          const SizedBox(height: 18),
          const LabelForField(label: 'Data de término'),
          CutomDatePicker(
            value: DateFormat('dd/MM/yyyy').format(_selectedEnd),
            enable: true,
            initialDate: _selectedEnd,
            firstDate: _selectedStart.add(const Duration(days: 1)),
            lastDate: DateTime(2100),
            onPressed: _onEndDateChange,
          ),
          const SizedBox(height: 18),
          const LabelForField(label: 'Valor planejado'),
          CustomTextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            hint: 'R\$ 1.000,00',
            onChanged: _onAmountChanged,
          ),
          const SizedBox(height: 12),
          const InfoContent.warning(
            label:
                'Este é o valor total que você planeja gastar neste período.',
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            enable: !isSubmitting,
            isLoading: isSubmitting,
            onPressed: () => _submit(context),
            label: 'Salvar intervalo',
          ),
        ],
      ),
    );
  }

  void _onAmountChanged(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      _amountController.value = const TextEditingValue(
        selection: TextSelection.collapsed(offset: 0),
      );
      return;
    }

    final cents = int.parse(digits);
    final formatted = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(cents / 100);

    if (_amountController.text != formatted) {
      _amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _onStartDateChange(DateTime? date) {
    if (date != null) {
      setState(() {
        _selectedStart = date;
      });
    }
  }

  void _onEndDateChange(DateTime? date) {
    if (date != null) {
      setState(() {
        _selectedEnd = date;
      });
    }
  }
}
