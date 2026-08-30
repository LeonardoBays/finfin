import 'package:fin/presentation/screens/transaction/bloc/transaction_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../componenets/widgets/custom_elevated_button.dart';
import '../../../componenets/widgets/custom_text_field.dart';
import '../../../componenets/widgets/info_content.dart';
import '../../../componenets/widgets/label_for_field.dart';

class TransactionHome extends StatefulWidget {
  const TransactionHome({super.key, required this.state});

  final TransactionState state;

  @override
  State<TransactionHome> createState() => _TransactionHomeState();
}

class _TransactionHomeState extends State<TransactionHome> {
  late final TextEditingController _descriptionController;
  late final TextEditingController _amountController;
  String? _selectedPeriodId;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    _syncFromState(widget.state.form);
  }

  @override
  void didUpdateWidget(covariant TransactionHome oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.form != oldWidget.state.form) {
      _syncFromState(widget.state.form);
    }
  }

  void _syncFromState(TransactionFormData? form) {
    final nextDesc = form?.description ?? '';
    final nextAmount = form?.amount ?? 0;
    final nextPeriod = form?.periodId;

    if (_descriptionController.text != nextDesc) {
      _descriptionController.text = nextDesc;
      _descriptionController.selection = TextSelection.collapsed(
        offset: _descriptionController.text.length,
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

    _selectedPeriodId = nextPeriod;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
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
    final description = _descriptionController.text.trim();
    final amount = _parseCurrency(_amountController.text);

    if (description.isEmpty || amount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos obrigatórios.')),
      );
      return;
    }

    context.read<TransactionBloc>().add(
      TransactionSubmitted(
        id: widget.state.form?.id ?? '',
        description: description,
        amount: amount,
        periodId: _selectedPeriodId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = widget.state is TransactionSubmitting;
    final error = widget.state is TransactionError
        ? (widget.state as TransactionError).message
        : null;

    final periods = widget.state.periods;

    return SingleChildScrollView(
      padding: MediaQuery.of(
        context,
      ).padding.add(const EdgeInsets.fromLTRB(16, 12, 16, 28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) InfoContent.error(label: error),
          const LabelForField(label: 'Descrição'),
          CustomTextField(
            controller: _descriptionController,
            hint: 'Ex.: Almoço, Combustível, Mercado...',
          ),
          const SizedBox(height: 18),
          const LabelForField(label: 'Valor (despesa)'),
          CustomTextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            hint: 'R\$ 0,00',
            onChanged: _onAmountChanged,
          ),
          const SizedBox(height: 18),
          const LabelForField(label: 'Intervalo'),
          DropdownButtonFormField<String>(
            initialValue: _selectedPeriodId,
            items: [
              const DropdownMenuItem(child: Text('Selecione um intervalo')),
              ...periods.map(
                (p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.name.isNotEmpty ? p.name : 'Período atual'),
                ),
              ),
            ],
            onChanged: (v) => setState(() => _selectedPeriodId = v),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          const InfoContent.warning(
            label:
                'Todos os lançamentos são despesas e serão registrados como valores negativos.',
          ),
          const SizedBox(height: 24),
          CustomElevatedButton(
            enable: !isSubmitting,
            isLoading: isSubmitting,
            onPressed: () => _submit(context),
            label: 'Salvar lançamento',
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
}
