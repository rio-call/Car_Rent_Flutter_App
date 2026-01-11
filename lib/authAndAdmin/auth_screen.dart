import 'package:carrental/services/auth_services.dart';
import 'package:flutter/material.dart';

import 'sign-in-sign-up-widgets/auth_buttons.dart';
import 'sign-in-sign-up-widgets/auth_form_Inputs.dart';
import 'sign-in-sign-up-widgets/auth_layout_widgets.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, required this.initialIsSignIn});
  // i use this to determine whether to show sign-in or sign-up form
  // and keep it short cut
  final bool initialIsSignIn;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const Color _kBrand = Color(0xFF00C2A8);
  static const Color _kScaffoldBg = Color(0xFF0B1628);
  static const Color _kFieldFill = Color(0xFF142742);
  static const Color _kMuted = Colors.white;
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  late bool isSignIn;
  bool isBusy = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    // here is the short cut
    isSignIn = widget.initialIsSignIn;
  }

  @override
  void dispose() {
    // to avoid memory leaks
    emailCtrl.dispose();
    passwordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v) {
    if (v == null || v.trim().isEmpty) {
      return 'Required';
    } else {
      return null;
    }
  }

  String? _emailValidator(String? v) {
    final requiredError = _required(v);
    if (requiredError != null) {
      return requiredError;
    }
    final email = v!.trim();
    if (!email.contains('@') || !email.contains('.')) {
      return 'Invalid email';
    }
    return null;
  }

  String? _passwordValidator(String? v) {
    final requiredError = _required(v);
    if (requiredError != null) {
      return requiredError;
    }
    if ((v ?? '').trim().length < 6) {
      return 'Min 6 characters';
    }
    return null;
  }

  String? _confirmPasswordValidator(String? v) {
    if (isSignIn) {
      return null;
    }
    final requiredError = _required(v);
    if (requiredError != null) {
      return requiredError;
    }
    if (v!.trim() != passwordCtrl.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  // submit the form
  Future<void> _submit() async {
    // in state of form is not valid do not proceed
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => isBusy = true);
    try {
      final email = emailCtrl.text.trim();
      final password = passwordCtrl.text.trim();
      //
      if (isSignIn) {
        await AuthService().signIn(email: email, password: password);
      } else {
        await AuthService().register(email: email, password: password);
      }
      // if the user navigated away from this widget then do not do anything
      if (!mounted) return;
      // Return to the root auth gate so it can swap to HomeScreen.
      // If we try to pop when there's nothing to pop,
      // we show a snackbar instead.

      //  AuthGate is listening to auth changes using StreamBuilder (authStateChanges()).
      // so when the user is signed in or registered successfully
      // the AuthGate will rebuild and show HomeScreen
      // the pop here is just to close the auth screen if it was pushed onto the stack
      //  we use this to not let auth screen remain in the navigation stack
      // and the user can not go back to it using back button
      // if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
      // } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isSignIn ? 'Signed in' : 'Account created')),
      );
      // }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Auth failed')));
    } finally {
      if (mounted)
        setState(
          // this is even if there was an error the screen will not be busy anymore]
          () => isBusy = false,
        );
    }
  }

  // to toggle between sign-in and sign-up modes
  void _toggleMode() {
    setState(() {
      isSignIn = !isSignIn;
      confirmPasswordCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = isSignIn ? 'Sign in' : 'Create account';
    final subtitle = isSignIn
        ? 'Use your email and password'
        : 'Create your account to book cars';

    final heroImage = isSignIn
        ? 'assets/images/sign-in.png'
        : 'assets/images/sign-up.png';

    InputDecoration decoration(String label, {Widget? suffixIcon}) {
      return InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: _kMuted,
          fontWeight: FontWeight.w700,
        ),
        floatingLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
        hintStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
        suffixIconColor: Colors.white,
        filled: true,
        fillColor: _kFieldFill,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF263A60)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _kBrand, width: 2),
        ),
        suffixIcon: suffixIcon,
      );
    }

    return Scaffold(
      backgroundColor: _kScaffoldBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: AuthCardContainer(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AuthHeroImage(imageAsset: heroImage),
                    const SizedBox(height: 14),
                    AuthHeader(
                      title: title,
                      subtitle: subtitle,
                      subtitleColor: _kMuted,
                    ),
                    const SizedBox(height: 16),
                    AuthEmailField(
                      controller: emailCtrl,
                      decoration: decoration,
                      cursorColor: _kBrand,
                      validator: _emailValidator,
                    ),
                    const SizedBox(height: 12),
                    AuthPasswordField(
                      label: 'Password',
                      controller: passwordCtrl,
                      obscureText: hidePassword,
                      onToggleVisibility: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      decoration: decoration,

                      validator: (value) {
                        return _passwordValidator(value);
                      },
                    ),
                    // spread operator ... is used to conditionally add widgets more than one
                    if (!isSignIn) ...[
                      const SizedBox(height: 12),
                      AuthPasswordField(
                        label: 'Confirm password',
                        controller: confirmPasswordCtrl,
                        obscureText: hideConfirmPassword,
                        onToggleVisibility: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        },
                        decoration: decoration,

                        validator: _confirmPasswordValidator,
                      ),
                    ],

                    const SizedBox(height: 18),
                    AuthPrimaryButton(
                      isBusy: isBusy,
                      isSignIn: isSignIn,
                      onPressed: isBusy ? null : _submit,
                      brandColor: _kBrand,
                    ),
                    const SizedBox(height: 12),
                    AuthModeToggle(
                      isBusy: isBusy,
                      isSignIn: isSignIn,
                      onPressed: _toggleMode,
                      brandColor: _kBrand,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
