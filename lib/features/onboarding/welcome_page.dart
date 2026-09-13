import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/primary_button.dart';
import 'create_join_trip_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F4F1), AppColors.sand, Color(0xFFF8E8D8)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RoamWordmark(size: 22),
                const Spacer(),
                const Text(
                  AppConstants.tagline,
                  style: TextStyle(
                    fontSize: 36,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  AppConstants.description,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _Pill(icon: Icons.map_outlined, label: 'Itineraries'),
                    _Pill(
                      icon: Icons.account_balance_wallet_outlined,
                      label: 'Group wallet',
                    ),
                    _Pill(icon: Icons.groups_outlined, label: 'Shared trips'),
                  ],
                ),
                const Spacer(),
                PrimaryButton(
                  label: 'Get Started',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: () {
                    AppScope.of(context).startPrototype();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const CreateJoinTripPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.teal),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
