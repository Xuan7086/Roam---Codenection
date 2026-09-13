import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_page.dart';

class FootprintPage extends StatelessWidget {
  const FootprintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Travel footprint',
      subtitle:
          'Track places you have visited. Data is mocked for the prototype.',
      icon: Icons.hiking,
      items: [
        MockTile(
          title: 'George Town, Penang',
          detail: 'Visited · 12 heritage spots saved',
        ),
        MockTile(
          title: 'Melaka City',
          detail: 'Visited · Riverside walk and night market saved',
        ),
      ],
    );
  }
}
