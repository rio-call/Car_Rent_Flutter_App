import 'package:flutter/material.dart';

import 'auth_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _kBrand = Color(0xFF00C2A8);
  static const Color _kGold = Color(0xFFC9A24A);
  static const Color _kTextMuted = Colors.white;

  void _openAuth(BuildContext context, {required bool signIn}) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AuthScreen(initialIsSignIn: signIn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image to fill the entire screen it is the same
          // as R=0,B=0,L=0,T=0
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcompageimg.jpeg',
              fit: BoxFit.cover,
            ),
          ),

          // A gradient overlay to darken the bottom part of the image
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF0B1628).withValues(alpha: 0.25),
                    const Color(0xFF0B1628).withValues(alpha: 0.70),
                    const Color(0xFF0B1628).withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // spacer to push the content to the bottom
                  const Spacer(),
                  Text(
                    'Rent the right car\nfor every trip',
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 34,
                      height: 1.05,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Browse, book, and manage rentals in minutes.',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _kTextMuted,
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: () => _openAuth(context, signIn: true),
                    style: FilledButton.styleFrom(
                      backgroundColor: _kBrand,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    child: const Text('Sign in'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => _openAuth(context, signIn: false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _kGold,
                      side: const BorderSide(color: _kGold, width: 1.4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    child: const Text('Create account'),
                  ),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
