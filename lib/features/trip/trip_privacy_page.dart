import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/primary_button.dart';
import 'models/trip.dart';

class TripPrivacyPage extends StatefulWidget {
  const TripPrivacyPage({super.key, required this.draft});

  final Trip draft;

  @override
  State<TripPrivacyPage> createState() => _TripPrivacyPageState();
}

class _TripPrivacyPageState extends State<TripPrivacyPage> {
  late TripPrivacy _privacy = widget.draft.privacy;

  void _create() {
    AppScope.of(context).createTrip(widget.draft.copyWith(privacy: _privacy));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AppShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.draft;

    return Scaffold(
      appBar: AppBar(title: const Text('Trip privacy')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          const Text(
            'Who can access this trip?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            '${trip.name} · ${trip.destination}\n${DateFmt.range(trip.startDate, trip.endDate)}',
            style: const TextStyle(color: AppColors.muted, height: 1.45),
          ),
          const SizedBox(height: 22),
          ...TripPrivacy.values.map((option) {
            final selected = _privacy == option;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                  side: BorderSide(
                    color: selected ? AppColors.teal : AppColors.line,
                    width: selected ? 1.6 : 1,
                  ),
                ),
                child: InkWell(
                  onTap: () => setState(() => _privacy = option),
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selected ? AppColors.teal : AppColors.muted,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                option.label,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                option.description,
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          PrimaryButton(label: 'Create trip', onPressed: _create),
        ],
      ),
    );
  }
}
