import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../core/constants/app_constants.dart';
import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/roam_text_field.dart';

class JoinTripPage extends StatefulWidget {
  const JoinTripPage({super.key});

  @override
  State<JoinTripPage> createState() => _JoinTripPageState();
}

class _JoinTripPageState extends State<JoinTripPage> {
  final _code = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  void _join() {
    final ok = AppScope.of(context).joinTrip(_code.text);
    if (!ok) {
      setState(
        () => _error = 'No trip found. Try ${AppConstants.sampleJoinCode}.',
      );
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AppShell()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join a trip')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          const Text(
            'Enter an invite',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use a trip code, invite code, or trip link from your group.',
            style: TextStyle(color: AppColors.muted, height: 1.45),
          ),
          const SizedBox(height: 24),
          RoamTextField(
            label: 'Trip code or link',
            controller: _code,
            hint: AppConstants.sampleJoinCode,
            prefixIcon: Icons.vpn_key_outlined,
            onChanged: (_) => setState(() => _error = null),
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.line),
            ),
            child: const Text(
              'Demo: join with PENANG26 or MELAKA88 to open the sample Penang trip.',
              style: TextStyle(color: AppColors.muted, height: 1.4),
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(label: 'Join trip', onPressed: _join),
        ],
      ),
    );
  }
}
