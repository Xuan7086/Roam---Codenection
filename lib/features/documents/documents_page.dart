import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final _checks = {
    'Visa preparation': true,
    'Vaccination requirements': false,
    'Hotel / accommodation': true,
    'Travel documents': true,
    'Travel insurance': false,
    'Currency / cards': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Travel checklist')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const Text(
            'Prep before you fly',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          const Text(
            'Visa links are placeholders pointing to official guidance later. Toggles are local only.',
            style: TextStyle(color: AppColors.muted, height: 1.4),
          ),
          const SizedBox(height: 12),
          ..._checks.entries.map(
            (entry) => CheckboxListTile(
              value: entry.value,
              onChanged: (value) =>
                  setState(() => _checks[entry.key] = value ?? false),
              title: Text(entry.key),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.open_in_new, color: AppColors.teal),
            title: const Text('Official visa information'),
            subtitle: const Text(
              'Opens a mock note — no web scraping in this prototype.',
            ),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Would open the relevant government visa site.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
