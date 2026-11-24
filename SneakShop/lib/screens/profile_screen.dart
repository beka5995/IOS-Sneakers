import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../database/local_auth.dart';
import '../state/auth_cubit.dart';
import '../models/account.dart';
import '../state/store_controller.dart';
import '../state/photo_journal_store.dart';
import '../widgets/journal_entries.dart';

class ProfileScreen extends StatefulWidget {
  final StoreController store;

  const ProfileScreen({
    super.key,
    required this.store,
    this.journal,
    this.onOpenJournal,
    this.onSignedIn,
  });

  final PhotoJournalStore? journal;
  final VoidCallback? onOpenJournal;

  final VoidCallback? onSignedIn;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  bool _registerMode = false;
  bool _acceptTerms = false;
  bool _termsError = false;
  bool _hidePassword = true;
  bool _signingOut = false;
  String _role = 'Shopper';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  void _switchMode() {
    FocusScope.of(context).unfocus();

    setState(() {
      _registerMode = !_registerMode;
      _termsError = false;
      _password.clear();
      _confirm.clear();
    });

    _formKey.currentState?.reset();
  }

  void _submit(BuildContext context) {
    final fieldsValid = _formKey.currentState!.validate();
    setState(() => _termsError = _registerMode && !_acceptTerms);
    if (!fieldsValid || _termsError) return;

    final cubit = context.read<AuthCubit>();
    if (_registerMode) {
      cubit.register(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        role: _role,
      );
    } else {
      cubit.login(_email.text, _password.text);
    }
  }

  void _onAuthState(BuildContext context, AuthState state) {
    if (state is AuthError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red.shade800,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    if (state is AuthSuccess) {
      widget.store.register(state.account);
      _password.clear();
      _confirm.clear();
      widget.onSignedIn?.call();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Welcome to SneakShop!')));
    }
  }

  Future<void> _logout() async {
    setState(() => _signingOut = true);
    try {
      await LocalAuth.instance.logout();

      if (!mounted) return;

      widget.store.signOut();
      _password.clear();
      _confirm.clear();

      setState(() {
        _registerMode = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Could not sign out')));
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
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
            child: account == null
                ? BlocProvider(
                    create: (_) => AuthCubit(),
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: _onAuthState,
                      builder: (context, state) =>
                          _authForm(context, state is AuthLoading),
                    ),
                  )
                : _accountProfile(account),
          ),
        );
      },
    );
  }

  Widget _authForm(BuildContext context, bool busy) {
    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              children: [
                const SizedBox(height: 10),
                Text(
                  _registerMode ? 'Create account' : 'Welcome back',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _registerMode
                      ? 'Create your SneakShop account'
                      : 'Sign in to your account',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 25),
                if (_registerMode) ...[
                  TextFormField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                ],
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = (value ?? '').trim();

                    if (!RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                        .hasMatch(email)) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _password,
                  obscureText: _hidePassword,
                  onChanged: (_) {
                    if (_registerMode && _confirm.text.isNotEmpty) {
                      _formKey.currentState?.validate();
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your password';
                    }

                    if (_registerMode && value.length < 6) {
                      return 'Minimum 6 characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 14),
                if (_registerMode) ...[
                  TextFormField(
                    controller: _confirm,
                    obscureText: _hidePassword,
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock_reset_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password';
                      }

                      if (value != _password.text) {
                        return 'Passwords do not match';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: _role,
                    decoration: const InputDecoration(
                      labelText: 'Account type',
                    ),
                    items: ['Shopper', 'Sneaker collector', 'Streetwear fan']
                        .map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _role = value ?? 'Shopper';
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    value: _acceptTerms,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'I accept the Terms and Conditions',
                      style: TextStyle(fontSize: 13),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _acceptTerms = value ?? false;
                        _termsError = false;
                      });
                    },
                  ),
                  if (_termsError)
                    const Text(
                      'Please accept the Terms and Conditions',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: busy
                      ? const Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : FilledButton(
                          onPressed: () => _submit(context),
                          child: Text(
                            _registerMode ? 'Create account' : 'Sign in',
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
            child: SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: busy ? null : _switchMode,
                child: Text(
                  _registerMode
                      ? 'Already have an account? Sign in'
                      : 'New to SneakShop? Create account',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _accountProfile(Account account) {
    final journal = widget.journal;
    return DefaultTabController(
      length: journal == null ? 2 : 3,
      child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondaryContainer,
                    child: Icon(
                      Icons.person_outline,
                      size: 34,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    account.fullName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              tabs: [
                const Tab(text: 'Profile Info'),
                const Tab(text: 'Account'),
                if (journal != null) const Tab(text: 'Photo Journal'),
              ],
            ),
          ),
        ],
        body: TabBarView(
          children: [
            ListView(
              key: const PageStorageKey('profile-info'),
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Name'),
                  subtitle: Text(account.fullName),
                ),
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Account type'),
                  subtitle: Text(account.role),
                ),
              ],
            ),
            ListView(
              key: const PageStorageKey('profile-account'),
              padding: const EdgeInsets.all(16),
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Name'),
                  subtitle: Text(account.fullName),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Email'),
                  subtitle: Text(account.email),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _signingOut ? null : _logout,
                  icon: const Icon(Icons.logout),
                  label: Text(_signingOut ? 'Signing out…' : 'Sign out'),
                ),
              ],
            ),
            if (journal != null)
              ListView(
                key: const PageStorageKey('profile-journal'),
                padding: const EdgeInsets.all(16),
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: widget.onOpenJournal,
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: const Text('Open Photo Journal'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  JournalEntries(journal: journal),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
