import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_page.dart';

class TourPage extends StatelessWidget {
  const TourPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Tours',
      subtitle: 'Guided ideas and booked tours will appear here.',
      icon: Icons.tour_outlined,
      items: [
        MockTile(
          title: 'George Town heritage walk',
          detail: 'Morning · 2 hours · mock listing',
        ),
        MockTile(
          title: 'Balik Pulau food trail',
          detail: 'Afternoon · 3 hours · mock listing',
        ),
      ],
    );
  }
}
