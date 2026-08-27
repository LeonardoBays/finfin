import 'package:fin/presentation/screens/period/bloc/period_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PeriodHome extends StatefulWidget {
  const PeriodHome({super.key, required this.state});

  final PeriodState state;

  @override
  State<PeriodHome> createState() => _PeriodHomeState();
}

class _PeriodHomeState extends State<PeriodHome> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _startController;
  late final TextEditingController _endController;

  DateTime? _selectedStart;
  DateTime? _selectedEnd;
  int _periodTypeId = 0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _amountController = TextEditingController();
    _startController = TextEditingController();
    _endController = TextEditingController();
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
      _startController.text = DateFormat('dd/MM/yyyy').format(nextStart);
    }

    if (nextEnd != null && _selectedEnd != nextEnd) {
      _selectedEnd = nextEnd;
      _endController.text = DateFormat('dd/MM/yyyy').format(nextEnd);
    }

    _periodTypeId = nextType;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, {required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart
        ? (_selectedStart ?? now.add(const Duration(days: 30)))
        : (_selectedEnd ?? _selectedStart ?? now.add(const Duration(days: 60)));

    final pickerMinDate = now.subtract(const Duration(days: 30));
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: pickerMinDate,
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStart) {
        _selectedStart = picked;
        _startController.text = DateFormat('dd/MM/yyyy').format(picked);
        if (_selectedEnd == null || _selectedEnd!.isBefore(picked)) {
          _selectedEnd = picked.add(const Duration(days: 30));
          _endController.text = DateFormat('dd/MM/yyyy').format(_selectedEnd!);
        }
      } else {
        _selectedEnd = picked;
        _endController.text = DateFormat('dd/MM/yyyy').format(picked);
      }
    });
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

    if (name.isEmpty || startsAt == null || endsAt == null || amount <= 0) {
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

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (error != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFECEC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  error,
                  style: const TextStyle(color: Color(0xFFB00020)),
                ),
              ),
            const _FieldLabel(label: 'Nome do intervalo'),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Ex.: Mercado Julho',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const _FieldLabel(label: 'Tipo de intervalo'),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Dias'),
                    selected: _periodTypeId == 0,
                    onSelected: (_) => setState(() => _periodTypeId = 0),
                    selectedColor: const Color(0xFF2051C9),
                    labelStyle: TextStyle(
                      color: _periodTypeId == 0
                          ? Colors.white
                          : const Color(0xFF2051C9),
                      fontWeight: FontWeight.w600,
                    ),
                    avatar: const Icon(Icons.calendar_today, size: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Semanas'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Meses'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _FieldLabel(label: 'Data de início'),
            TextFormField(
              controller: _startController,
              readOnly: true,
              onTap: () => _pickDate(context, isStart: true),
              decoration: const InputDecoration(
                hintText: '25/07/2026',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const _FieldLabel(label: 'Data de término'),
            TextFormField(
              controller: _endController,
              readOnly: true,
              onTap: () => _pickDate(context, isStart: false),
              decoration: const InputDecoration(
                hintText: '31/07/2026',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today_outlined),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const _FieldLabel(label: 'Valor planejado'),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (value) {
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
                    selection: TextSelection.collapsed(
                      offset: formatted.length,
                    ),
                  );
                }
              },
              decoration: const InputDecoration(
                hintText: 'R\$ 1.000,00',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF2051C9), size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Este é o valor total que você pode gastar neste período.',
                      style: TextStyle(color: Color(0xFF2051C9), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: isSubmitting ? null : () => _submit(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2051C9),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Salvar intervalo',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1B1B1B),
        ),
      ),
    );
  }
}
