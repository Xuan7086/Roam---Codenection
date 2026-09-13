import 'package:flutter/material.dart';

import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand_mark.dart';
import '../scanner/scanner_page.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = AppScope.of(context).currentTrip;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          key: const Key('wallet-scroll'),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Return to itinerary',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 2),
                const RoamWordmark(),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Group wallet',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${trip?.destination ?? 'Trip'} · Synced',
                        style: const TextStyle(
                          color: AppColors.sage,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            const Text(
              'TRIP TREASURY',
              style: TextStyle(
                color: AppColors.muted,
                fontWeight: FontWeight.w800,
                letterSpacing: .8,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              runSpacing: 8,
              children: [
                Text(
                  'Group Split-Wallet',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const _RatePill(),
              ],
            ),
            const SizedBox(height: 16),
            const _BudgetCard(),
            const SizedBox(height: 16),
            const _LedgerCard(),
            const SizedBox(height: 26),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.document_scanner_outlined,
                      color: AppColors.terracottaDark,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Smart Receipt Extract',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Align(
                  alignment: Alignment.centerRight,
                  child: _SmallLabel('Scanned 1h ago'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const _ReceiptCard(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ScannerPage())),
                icon: const Icon(Icons.document_scanner_outlined),
                label: const Text('Scan Receipt with AI'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard();
  @override
  Widget build(BuildContext context) => _WalletSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            const Icon(Icons.circle, size: 11, color: AppColors.sage),
            const Text(
              'Expense Budget Tracker',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const _GreenLabel('On budget (41% left)'),
          ],
        ),
        const SizedBox(height: 17),
        const Text(
          'EXPENSES BUDGET REMAINING',
          style: TextStyle(
            fontSize: 10,
            color: AppColors.muted,
            letterSpacing: .6,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 3),
        const Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 7,
          runSpacing: 2,
          children: [
            Text(
              'RM 1,840.00',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 31,
                height: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 7),
            Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Text(
                'MYR',
                style: TextStyle(
                  color: AppColors.muted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          '≈ \$394.85 USD remaining across all categories',
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        const SizedBox(height: 16),
        const Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            SizedBox(
              width: 132,
              child: _GhostAction(
                icon: Icons.analytics_outlined,
                label: 'View breakdown',
              ),
            ),
            SizedBox(
              width: 132,
              child: _GhostAction(
                icon: Icons.file_upload_outlined,
                label: 'Export summary',
                accent: true,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _LedgerCard extends StatelessWidget {
  const _LedgerCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.blush,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 6,
          children: [
            Text(
              'OVERALL TRIP LEDGER',
              style: TextStyle(
                color: AppColors.muted,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: .6,
              ),
            ),
            Text(
              'Total: RM 3,420.00',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 13),
        const Row(
          children: [
            Expanded(
              child: _Metric(
                label: 'AMOUNT OWED TO YOU',
                value: '+RM 185.00',
                detail: 'Collect from 2 members',
                green: true,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _Metric(
                label: 'NEED TO RETURN',
                value: 'RM 0.00',
                detail: 'All dues fully settled',
              ),
            ),
          ],
        ),
        const SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: AppColors.parchment,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: AppColors.line),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                runSpacing: 6,
                children: [
                  Text(
                    'SETTLEMENT BREAKDOWN',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: .7,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  _SettleButton(),
                ],
              ),
              SizedBox(height: 11),
              _Settlement(name: 'Marcus Lim owes you', amount: '+RM 115.00'),
              Divider(),
              _Settlement(name: 'Chloe Tan owes you', amount: '+RM 70.00'),
            ],
          ),
        ),
        const SizedBox(height: 11),
        const Text(
          'ⓘ Micro-transfers auto-offset; no pending debt to pay back.',
          style: TextStyle(color: AppColors.muted, fontSize: 12, height: 1.35),
        ),
      ],
    ),
  );
}

class _ReceiptCard extends StatelessWidget {
  const _ReceiptCard();
  @override
  Widget build(BuildContext context) => _WalletSurface(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hameediyah Restaurant',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            SizedBox(height: 3),
            Text(
              'Dinner · Group table',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
            SizedBox(height: 9),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'RECEIPT TOTAL',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'RM 128.70',
                    style: TextStyle(
                      color: AppColors.terracottaDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 13),
          child: Divider(),
        ),
        const _ReceiptLine(
          item: '2x Nasi Briyani Ayam',
          amount: 'RM 38.00',
          split: 'Claimed: Chloe · Marcus',
        ),
        const _ReceiptLine(
          item: '1x Lamb Shank Masala',
          amount: 'RM 45.00',
          split: 'Claimed: Kenji',
        ),
        const _ReceiptLine(
          item: '1x Murtabak Special',
          amount: 'RM 18.00',
          split: 'Split: Shared by all (RM 4.50 ea)',
        ),
        const _ReceiptLine(
          item: '4x Teh Tarik & Lime Ice',
          amount: 'RM 16.00',
          split: 'Split: Shared by all (RM 4.00 ea)',
        ),
        Container(
          margin: const EdgeInsets.only(top: 6),
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: AppColors.blush,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Text(
                '10% Service & Gov Tax\nAuto-distributed proportionally',
                style: TextStyle(color: AppColors.muted, fontSize: 11),
              ),
              Text('RM 11.70', style: TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 11,
                    backgroundColor: AppColors.blushStrong,
                    child: Text('M', style: TextStyle(fontSize: 10)),
                  ),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      'Card paid by Marcus Lim',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Confirm splits',
                  style: TextStyle(
                    color: AppColors.terracottaDark,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _WalletSurface extends StatelessWidget {
  const _WalletSurface({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.parchment,
      borderRadius: BorderRadius.circular(17),
      border: Border.all(color: AppColors.line),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0B2C2623),
          blurRadius: 15,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

class _RatePill extends StatelessWidget {
  const _RatePill();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.blush,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppColors.line),
    ),
    child: const Text(
      '↻ 1 USD ≈ 4.66 MYR',
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
    ),
  );
}

class _GreenLabel extends StatelessWidget {
  const _GreenLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.sageLight,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: AppColors.sage,
        fontSize: 10,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _SmallLabel extends StatelessWidget {
  const _SmallLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.blushStrong,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: const TextStyle(
        color: AppColors.muted,
        fontSize: 10,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class _GhostAction extends StatelessWidget {
  const _GhostAction({
    required this.icon,
    required this.label,
    this.accent = false,
  });
  final IconData icon;
  final String label;
  final bool accent;
  @override
  Widget build(BuildContext context) => Container(
    height: 43,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.blush,
      border: Border.all(color: AppColors.line),
      borderRadius: BorderRadius.circular(11),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 16,
          color: accent ? AppColors.terracottaDark : AppColors.ink,
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: accent ? AppColors.terracottaDark : AppColors.ink,
            ),
          ),
        ),
      ],
    ),
  );
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    required this.detail,
    this.green = false,
  });
  final String label;
  final String value;
  final String detail;
  final bool green;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: AppColors.parchment,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: AppColors.line),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: green ? AppColors.sage : AppColors.ink,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          detail,
          style: const TextStyle(color: AppColors.muted, fontSize: 10),
        ),
      ],
    ),
  );
}

class _SettleButton extends StatelessWidget {
  const _SettleButton();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: AppColors.sage,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text(
      'Settle up',
      style: TextStyle(
        color: Colors.white,
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _Settlement extends StatelessWidget {
  const _Settlement({required this.name, required this.amount});
  final String name;
  final String amount;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.circle, color: AppColors.sage, size: 8),
      const SizedBox(width: 8),
      Expanded(child: Text(name, style: const TextStyle(fontSize: 12))),
      Text(
        amount,
        style: const TextStyle(
          color: AppColors.sage,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    ],
  );
}

class _ReceiptLine extends StatelessWidget {
  const _ReceiptLine({
    required this.item,
    required this.amount,
    required this.split,
  });
  final String item;
  final String amount;
  final String split;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  split,
                  style: const TextStyle(color: AppColors.muted, fontSize: 10),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
