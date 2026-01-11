import 'package:flutter/material.dart';

class AuthPrimaryButton extends StatelessWidget {
  final bool isBusy;
  final bool isSignIn;
  final VoidCallback? onPressed;
  final Color brandColor;

  const AuthPrimaryButton({
    super.key,
    required this.isBusy,
    required this.isSignIn,
    required this.onPressed,
    required this.brandColor,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: brandColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
      ),
      child: isBusy
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            )
          : Text(isSignIn ? 'Sign in' : 'Create account'),
    );
  }
}

class AuthModeToggle extends StatelessWidget {
  final bool isBusy;
  final bool isSignIn;
  final VoidCallback? onPressed;
  final Color brandColor;

  const AuthModeToggle({
    super.key,
    required this.isBusy,
    required this.isSignIn,
    required this.onPressed,
    required this.brandColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isBusy ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: brandColor,
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
      child: Text(
        isSignIn
            ? "Don't have an account? Sign up"
            : 'Already have an account? Sign in',
      ),
    );
  }
}
