import 'package:flutter/material.dart';

import '../../core/widgets/placeholder_page.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderPage(
      title: 'Receipt scanner',
      subtitle: 'AI receipt reading is planned. This screen is a frontend placeholder.',
      icon: Icons.document_scanner_outlined,
      items: [
        MockTile(
          title: 'Upload a photo',
          detail: 'Camera and gallery will connect later.',
        ),
        MockTile(
          title: 'Split suggestion',
          detail: 'Equal split among trip members by default.',
        ),
      ],
    );
  }
}
