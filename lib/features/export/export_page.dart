import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_page.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Export',
      subtitle: 'Share itineraries as PDF or links once backend export exists.',
      icon: Icons.ios_share_outlined,
      items: [
        MockTile(
          title: 'Share trip code',
          detail: 'Members can join with the code from the hub.',
        ),
        MockTile(
          title: 'Export PDF',
          detail: 'Placeholder action for a later service.',
        ),
      ],
    );
  }
}
