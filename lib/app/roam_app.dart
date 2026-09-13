import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/storage/app_state.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/welcome_page.dart';

class RoamApp extends StatefulWidget {
  const RoamApp({super.key});

  @override
  State<RoamApp> createState() => _RoamAppState();
}

class _RoamAppState extends State<RoamApp> {
  final AppState _state = AppState();

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const WelcomePage(),
      ),
    );
  }
}
