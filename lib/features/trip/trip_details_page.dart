import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/roam_text_field.dart';
import 'models/trip.dart';
import 'trip_privacy_page.dart';

class TripDetailsPage extends StatefulWidget {
  const TripDetailsPage({super.key});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController(text: 'Penang Heritage Escape');
  final _destination = TextEditingController(text: 'George Town, Penang');
  final _description = TextEditingController();
  final _budget = TextEditingController();
  final _travellers = TextEditingController(text: '4');
  late DateTime _start;
  late DateTime _end;

  @override
  void initState() {
    super.initState();
    final today = DateUtils.dateOnly(DateTime.now());
    _start = today.add(const Duration(days: 30));
    _end = _start.add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _name.dispose();
    _destination.dispose();
    _description.dispose();
    _budget.dispose();
    _travellers.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool start}) async {
    final firstDate = start ? DateTime(2024) : _start;
    final suggested = start ? _start : _end;
    final initial = suggested.isBefore(firstDate) ? firstDate : suggested;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: DateTime(2032),
    );
    if (picked == null) return;
    setState(() {
      if (start) {
        _start = picked;
        if (_end.isBefore(picked)) {
          _end = picked;
        }
      } else {
        _end = picked;
      }
    });
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) return;
    final budgetText = _budget.text.trim();
    final draft = Trip(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      destination: _destination.text.trim(),
      startDate: _start,
      endDate: _end,
      privacy: TripPrivacy.inviteOnly,
      description: _description.text.trim(),
      budget: budgetText.isEmpty ? null : double.tryParse(budgetText),
      travellerCount: int.tryParse(_travellers.text.trim()) ?? 1,
      memberCount: int.tryParse(_travellers.text.trim()) ?? 1,
      code: 'RM${DateTime.now().millisecond.toString().padLeft(3, '0')}',
    );
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => TripPrivacyPage(draft: draft)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trip details')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            const Text(
              'Where are you going?',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add the basics. You can refine the itinerary later in the trip hub.',
              style: TextStyle(color: AppColors.muted, height: 1.45),
            ),
            const SizedBox(height: 22),
            RoamTextField(
              label: 'Trip name',
              controller: _name,
              hint: 'Penang Heritage Escape',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter a trip name' : null,
            ),
            const SizedBox(height: 14),
            RoamTextField(
              label: 'Destination',
              controller: _destination,
              hint: 'George Town, Penang',
              prefixIcon: Icons.place_outlined,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Enter a destination'
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DateTile(
                    label: 'Start date',
                    value: DateFmt.short(_start),
                    onTap: () => _pickDate(start: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DateTile(
                    label: 'End date',
                    value: DateFmt.short(_end),
                    onTap: () => _pickDate(start: false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${_destination.text.trim().isEmpty ? 'Destination' : _destination.text.trim()} · ${DateFmt.range(_start, _end)} · ${DateFmt.nights(_start, _end)} nights',
              style: const TextStyle(
                color: AppColors.tealDark,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),
            RoamTextField(
              label: 'Short description (optional)',
              controller: _description,
              hint: 'Hawker food, heritage lanes, and an island sunset.',
              maxLines: 3,
            ),
            const SizedBox(height: 14),
            RoamTextField(
              label: 'Estimated budget (optional)',
              controller: _budget,
              hint: '3200',
              keyboardType: TextInputType.number,
              prefixIcon: Icons.payments_outlined,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return null;
                final budget = double.tryParse(text);
                if (budget == null || budget < 0) {
                  return 'Enter a valid non-negative budget';
                }
                return null;
              },
            ),
            const SizedBox(height: 14),
            RoamTextField(
              label: 'Number of travellers (optional)',
              controller: _travellers,
              keyboardType: TextInputType.number,
              prefixIcon: Icons.groups_outlined,
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) return null;
                final travellers = int.tryParse(text);
                if (travellers == null || travellers < 1) {
                  return 'Enter at least one traveller';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),
            PrimaryButton(label: 'Continue', onPressed: _continue),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
