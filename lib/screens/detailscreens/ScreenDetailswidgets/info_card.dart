import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String? caption;
  final Widget? trailing;
  const InfoCard({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    this.caption,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF142742),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                if (caption != null) ...[
                  const SizedBox(height: 2),
                  Text(caption!, style: const TextStyle(color: Colors.white)),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
        ],
      ),
    );
  }
}
