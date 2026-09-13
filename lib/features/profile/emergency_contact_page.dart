import 'package:flutter/material.dart';

import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';

class EmergencyContactPage extends StatefulWidget {
  const EmergencyContactPage({super.key, required this.contact});

  final EmergencyContact contact;

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _relationshipController = TextEditingController(
      text: widget.contact.relationship,
    );
    _phoneController = TextEditingController(text: widget.contact.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        tooltip: 'Return to profile',
        onPressed: () => Navigator.of(context).maybePop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text('Emergency contact'),
    ),
    body: SafeArea(
      top: false,
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.blush,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.terracotta,
                    child: Icon(Icons.emergency_outlined, color: Colors.white),
                  ),
                  SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A person to reach quickly',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Keep these details current for your trip group.',
                          style: TextStyle(color: AppColors.muted, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'Contact details',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a contact name'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _relationshipController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Relationship',
                hintText: 'e.g. Parent, sibling, friend',
                prefixIcon: Icon(Icons.people_outline_rounded),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter a relationship'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                hintText: '+60 12-345 6789',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: (value) => value == null || value.trim().length < 7
                  ? 'Enter a valid phone number'
                  : null,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save emergency contact'),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    AppScope.of(context).updateEmergencyContact(
      EmergencyContact(
        name: _nameController.text.trim(),
        relationship: _relationshipController.text.trim(),
        phone: _phoneController.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }
}
