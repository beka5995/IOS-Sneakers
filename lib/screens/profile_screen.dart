import 'package:flutter/material.dart';

import '../models/account.dart';
import '../state/store_controller.dart';

class ProfileScreen extends StatefulWidget {
  final StoreController store;

  const ProfileScreen({super.key, required this.store});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _acceptTerms = false;
  bool _showTermsError = false;
  bool _hidePassword = true;
  String _role = 'Student';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final validFields = _formKey.currentState!.validate();
    setState(() => _showTermsError = !_acceptTerms);
    if (!validFields || !_acceptTerms) return;

    final account = Account(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      role: _role,
    );
    // Don't log passwords to the console.
    debugPrint('Registered: ${account.fullName}, ${account.email}, ${account.role}');
    widget.store.register(account);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Account created successfully!'),
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final account = widget.store.account;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 550),
            child: account == null ? _registrationForm() : _accountProfile(account),
          ),
        );
      },
    );
  }

  Widget _accountProfile(Account account) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 20),
        const CircleAvatar(
          radius: 36,
          backgroundColor: Color(0xFFFFE0DB),
          child: Icon(Icons.person, size: 40, color: Color(0xFFE25448)),
        ),
        const SizedBox(height: 16),
        Center(child: Text(account.fullName, style: const TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold,
        ))),
        const SizedBox(height: 5),
        Center(child: Text(account.email, style: const TextStyle(color: Colors.grey))),
        const SizedBox(height: 22),
        Card(
          color: Colors.white,
          child: ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('Account type'),
            subtitle: Text(account.role),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.logout),
          onPressed: widget.store.signOut,
          label: const Text('Sign out'),
        ),
      ],
    );
  }

  Widget _registrationForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        children: [
          const Text('Create account', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Make an account to keep your details in one place.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 22),
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)),
            textCapitalization: TextCapitalization.words,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Enter your full name' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
            validator: (value) {
              final email = (value ?? '').trim();
              if (email.isEmpty) return 'Email is required';
              if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _passwordController,
            obscureText: _hidePassword,
            onChanged: (_) {
              if (_confirmController.text.isNotEmpty) {
                _formKey.currentState?.validate();
              }
            },
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _hidePassword = !_hidePassword),
                icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Password is required';
              if (value.length < 6) return 'Use at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _confirmController,
            obscureText: _hidePassword,
            decoration: const InputDecoration(
              labelText: 'Confirm password', prefixIcon: Icon(Icons.lock_reset_outlined),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Please confirm your password';
              if (value != _passwordController.text) return 'Passwords do not match';
              return null;
            },
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            initialValue: _role,
            decoration: const InputDecoration(labelText: 'Account type'),
            items: ['Student', 'Teacher', 'Developer'].map((role) {
              return DropdownMenuItem(value: role, child: Text(role));
            }).toList(),
            onChanged: (value) => setState(() => _role = value ?? 'Student'),
          ),
          const SizedBox(height: 6),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _acceptTerms,
            title: const Text('I accept the Terms and Conditions',
                style: TextStyle(fontSize: 13)),
            onChanged: (value) => setState(() {
              _acceptTerms = value ?? false;
              _showTermsError = false;
            }),
          ),
          if (_showTermsError)
            const Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10),
              child: Text('Please accept the Terms and Conditions',
                  style: TextStyle(color: Color(0xFFB3261E), fontSize: 12)),
            ),
          const SizedBox(height: 8),
          SizedBox(
            height: 50,
            child: FilledButton(onPressed: _submit, child: const Text('Create account')),
          ),
          const SizedBox(height: 12),
          const Text('This demo account is stored only while the app is running.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }
}
