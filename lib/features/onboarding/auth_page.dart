import 'package:flutter/material.dart';

import '../../core/storage/app_state.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/brand_mark.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/roam_text_field.dart';
import 'profile_setup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.initialSignUp = true});

  final bool initialSignUp;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late bool _signUp = widget.initialSignUp;
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final state = AppScope.of(context);
    if (_signUp) {
      state.signUp(name: _name.text.trim(), email: _email.text.trim());
    } else {
      state.logIn(email: _email.text.trim());
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const ProfileSetupPage()));
  }

  String? _emailValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty || !text.contains('@') || !text.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          children: [
            const RoamWordmark(),
            const SizedBox(height: 20),
            Text(
              _signUp ? 'Create your account' : 'Welcome back',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.6,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _signUp
                  ? 'Sign up to start planning trips with friends.'
                  : 'Log in to continue your travel plans.',
              style: const TextStyle(color: AppColors.muted, height: 1.4),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  if (_signUp) ...[
                    RoamTextField(
                      label: 'Name',
                      controller: _name,
                      hint: 'Alex Rivera',
                      prefixIcon: Icons.person_outline,
                      textInputAction: TextInputAction.next,
                      validator: (v) => (v == null || v.trim().length < 2)
                          ? 'Enter your name'
                          : null,
                    ),
                    const SizedBox(height: 14),
                  ],
                  RoamTextField(
                    label: 'Email',
                    controller: _email,
                    hint: 'you@email.com',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.mail_outline,
                    textInputAction: TextInputAction.next,
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 14),
                  RoamTextField(
                    label: 'Password',
                    controller: _password,
                    obscureText: true,
                    prefixIcon: Icons.lock_outline,
                    textInputAction: _signUp
                        ? TextInputAction.next
                        : TextInputAction.done,
                    validator: (v) => (v == null || v.length < 6)
                        ? 'Use at least 6 characters'
                        : null,
                  ),
                  if (_signUp) ...[
                    const SizedBox(height: 14),
                    RoamTextField(
                      label: 'Confirm password',
                      controller: _confirm,
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      validator: (v) =>
                          v != _password.text ? 'Passwords do not match' : null,
                    ),
                  ],
                  if (!_signUp) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Password reset is a placeholder in this prototype.',
                              ),
                            ),
                          );
                        },
                        child: const Text('Forgot password?'),
                      ),
                    ),
                  ] else
                    const SizedBox(height: 20),
                  PrimaryButton(
                    label: _signUp ? 'Sign Up' : 'Log In',
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 12),
                  SecondaryButton(
                    label: 'Continue with Google',
                    icon: Icons.g_mobiledata_rounded,
                    onPressed: () {
                      AppScope.of(context)
                          .signUp(name: 'Alex Rivera', email: 'alex@roam.app');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfileSetupPage(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => setState(() => _signUp = !_signUp),
                    child: Text(
                      _signUp
                          ? 'Already have an account? Log In'
                          : "Don't have an account? Sign Up",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
