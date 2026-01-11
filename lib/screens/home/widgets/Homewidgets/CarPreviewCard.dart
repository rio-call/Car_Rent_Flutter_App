import 'package:flutter/material.dart';

import 'package:carrental/models/car.dart';
import '../RatingStars.dart';

/// Small preview card used in horizontal car lists on the home screen.
///
/// Important: all displayed values are read from the provided [car]
/// (which typically comes from `kCars` in `lib/data/cars_data.dart`).
class CarPreviewCard extends StatelessWidget {
  final Car car;
  final double width;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const CarPreviewCard({
    super.key,
    required this.car,
    this.width = 300,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            // Background + fixed sizing to match existing UI.
            color: const Color(0xFF142742),
            height: 320,
            width: width,
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Car photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    car.imageAsset,
                    fit: BoxFit.fill,
                    width: 300,
                    height: 160,
                  ),
                ),
                const SizedBox(height: 20),

                // Name + price
                Text(
                  car.fullName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '\$${car.pricePerDayUsd}/day',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Rating derived from car.rating (0..5)
                // you can add stars here
                SizedBox(
                  width: 170,
                  child: RatingStars(
                    rating: car.rating,
                   
                    size: 20,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
