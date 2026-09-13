import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'join_trip_page.dart';
import '../trip/trip_details_page.dart';

class CreateJoinTripPage extends StatelessWidget {
  const CreateJoinTripPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your next trip')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          const Text(
            'Create or join a trip',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Start a new adventure or hop into a trip your friends already planned.',
            style: TextStyle(color: AppColors.muted, height: 1.45),
          ),
          const SizedBox(height: 24),
          _ChoiceCard(
            icon: Icons.add_location_alt_outlined,
            title: 'Create a trip',
            body: 'Set the destination, dates, and privacy, then invite your group.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TripDetailsPage()),
              );
            },
          ),
          const SizedBox(height: 14),
          _ChoiceCard(
            icon: Icons.group_add_outlined,
            title: 'Join a trip',
            body: 'Enter a trip code, invite code, or paste a trip link.',
            accent: AppColors.coral,
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const JoinTripPage()));
            },
          ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  const _ChoiceCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
    this.accent = AppColors.teal,
  });

  final IconData icon;
  final String title;
  final String body;
  final VoidCallback onTap;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      body,
                      style: const TextStyle(
                        color: AppColors.muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
