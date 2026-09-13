import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';

class CurrencyCheckerPage extends StatefulWidget {
  const CurrencyCheckerPage({super.key});

  @override
  State<CurrencyCheckerPage> createState() => _CurrencyCheckerPageState();
}

class _CurrencyCheckerPageState extends State<CurrencyCheckerPage> {
  final _amountController = TextEditingController(text: '100');
  String _from = 'MYR';
  String _to = 'USD';

  static const _ratesToMyr = {'MYR': 1.0, 'USD': 4.66, 'SGD': 3.45, 'THB': .13};

  double get _amount => double.tryParse(_amountController.text) ?? 0;
  double get _converted => _amount * _ratesToMyr[_from]! / _ratesToMyr[_to]!;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Return to profile',
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text('Currency checker'),
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.ink,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TRIP EXCHANGE',
                  style: TextStyle(
                    color: Color(0xFFE7F0E2),
                    fontSize: 11,
                    letterSpacing: .8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '${_format(_amount)} $_from',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Icon(Icons.south_rounded, color: AppColors.amber),
                ),
                Text(
                  '${_format(_converted)} $_to',
                  style: const TextStyle(
                    color: AppColors.amber,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 26),
          Text('Convert', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 14),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Amount',
              prefixText: '$_from  ',
              prefixIcon: const Icon(Icons.payments_outlined),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CurrencyMenu(
                  value: _from,
                  onChanged: (value) => setState(() => _from = value),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: IconButton.filledTonal(
                  onPressed: () => setState(() {
                    final previous = _from;
                    _from = _to;
                    _to = previous;
                  }),
                  icon: const Icon(Icons.swap_horiz_rounded),
                ),
              ),
              Expanded(
                child: _CurrencyMenu(
                  value: _to,
                  onChanged: (value) => setState(() => _to = value),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppColors.blush,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.terracottaDark,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '1 $_to = ${_format(_ratesToMyr[_to]! / _ratesToMyr[_from]!)} $_from · Reference rate',
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Popular quick checks',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _QuickRate('RM 50', '≈ USD 10.73'),
              _QuickRate('RM 100', '≈ USD 21.46'),
              _QuickRate('RM 500', '≈ USD 107.30'),
            ],
          ),
        ],
      ),
    ),
  );

  String _format(double value) =>
      value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2);
}

class _CurrencyMenu extends StatelessWidget {
  const _CurrencyMenu({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(
    key: ValueKey(value),
    initialValue: value,
    decoration: const InputDecoration(labelText: 'Currency'),
    items: const [
      'MYR',
      'USD',
      'SGD',
      'THB',
    ].map((code) => DropdownMenuItem(value: code, child: Text(code))).toList(),
    onChanged: (value) {
      if (value != null) onChanged(value);
    },
  );
}

class _QuickRate extends StatelessWidget {
  const _QuickRate(this.amount, this.value);

  final String amount;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: AppColors.parchment,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(11),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(amount, style: const TextStyle(fontWeight: FontWeight.w800)),
        Text(
          value,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    ),
  );
}
