import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/malaysia_footprint_map.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: canPop,
        title: const Text('Map'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          AspectRatio(
            aspectRatio: 1.15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: const MalaysiaFootprintMap(),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Your Malaysia footprint is shown with local prototype pins: Langkawi, Penang, Kuala Lumpur, Melaka, and Sabah.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
        ],
      ),
    );
  }
}
