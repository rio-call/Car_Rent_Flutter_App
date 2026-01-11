import 'package:flutter/material.dart';

class AuthCardContainer extends StatelessWidget {
  Widget child;

  AuthCardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: const Color(0xFF142742),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }
}

class AuthHeroImage extends StatelessWidget {
  final String imageAsset;

  const AuthHeroImage({super.key, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),

      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(imageAsset, fit: BoxFit.cover),
      ),
    );
  }
}

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color subtitleColor;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(color: subtitleColor, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
