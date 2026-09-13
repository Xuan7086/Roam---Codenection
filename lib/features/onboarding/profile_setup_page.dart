import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/roam_text_field.dart';
import '../../features/trip/models/user_profile.dart';
import 'create_join_trip_page.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _name = TextEditingController();
  final _bio = TextEditingController();
  String _style = 'Group';
  final Set<String> _interests = {};
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final user = AppScope.of(context).user;
    _name.text = user?.name ?? '';
    _bio.text = user?.bio ?? '';
    _style = user?.travelStyle ?? 'Group';
    _interests.addAll(user?.interests ?? const []);
  }

  @override
  void dispose() {
    _name.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _continue() {
    final state = AppScope.of(context);
    final current =
        state.user ??
        const UserProfile(name: 'Traveller', email: 'hello@roam.app');
    if (_name.text.trim().length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a display name.')),
      );
      return;
    }
    state.updateProfile(
      current.copyWith(
        name: _name.text.trim(),
        bio: _bio.text.trim(),
        travelStyle: _style,
        interests: _interests.toList(),
      ),
    );
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const CreateJoinTripPage()));
  }

  @override
  Widget build(BuildContext context) {
    final initials = (_name.text.trim().isEmpty ? 'R' : _name.text.trim()[0])
        .toUpperCase();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile setup')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        children: [
          const Text(
            'Tell us how you travel',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'This helps Roam tailor trip ideas. You can change it later.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 24),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.teal,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.coral,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Profile photo is mocked for this prototype',
              style: TextStyle(color: AppColors.muted, fontSize: 12),
            ),
          ),
          const SizedBox(height: 20),
          RoamTextField(
            label: 'Display name',
            controller: _name,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 14),
          RoamTextField(
            label: 'Short bio',
            controller: _bio,
            hint: 'Weekend hiker. Always hunting for good coffee.',
            maxLines: 3,
          ),
          const SizedBox(height: 22),
          const Text(
            'Preferred travel style',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.travelStyles.map((style) {
              final selected = _style == style;
              return ChoiceChip(
                label: Text(style),
                selected: selected,
                onSelected: (_) => setState(() => _style = style),
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          const Text(
            'Travel interests',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            'Select as many as you like.',
            style: TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.travelInterests.map((interest) {
              final selected = _interests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: selected,
                onSelected: (value) {
                  setState(() {
                    if (value) {
                      _interests.add(interest);
                    } else {
                      _interests.remove(interest);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          PrimaryButton(label: 'Continue', onPressed: _continue),
        ],
      ),
    );
  }
}
