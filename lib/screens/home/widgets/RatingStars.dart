import 'package:flutter/material.dart';

/// Reusable star rating widget (0..5).
///
/// Renders full/half/empty stars based on [rating].
class RatingStars extends StatelessWidget {
  final double rating;
  final int starCount;
  final Color color;
  final double size;
  final MainAxisAlignment mainAxisAlignment;

  const RatingStars({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.color = Colors.yellow,
    this.size = 18,
    this.mainAxisAlignment = MainAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    // clamp(min, max)
    IconData icon;
    final clamped = rating.clamp(0.0, starCount.toDouble());

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: List.generate(starCount, (index) {
        final diff = clamped - index;
        if (diff >= 1) {
          icon = Icons.star;
        } else if (diff >= 0.5) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, color: color, size: size);
      }),
    );
  }
}
