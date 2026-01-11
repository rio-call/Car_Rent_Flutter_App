import 'package:flutter/material.dart';

class CarImageCard extends StatelessWidget {
  final String imageAsset;
  final double borderRadius;
  final double aspectRatio;
  const CarImageCard({
    super.key,
    required this.imageAsset,
    this.borderRadius = 20,
    this.aspectRatio = 16 / 9,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(color: Colors.white),
            Image.asset(imageAsset, fit: BoxFit.cover),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 89),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
