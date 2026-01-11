import 'package:flutter/material.dart';

import 'package:carrental/models/car.dart';
import 'package:carrental/screens/home/widgets/Homewidgets/CarPreviewCard.dart';

/// Reusable horizontal scroller for car preview cards.
///
/// Used by the Home screen sections like “Mountain Cars” and “Luxury Cars”.
/// Keeps those sections consistent and avoids duplicated ListView.builder code.
class CarHorizontalScroller extends StatelessWidget {
  final List<Car> cars;
  final ValueChanged<Car> onCarTap;
  final double height;
  final double width;

  const CarHorizontalScroller({
    super.key,
    required this.cars,
    required this.onCarTap,
    this.height = 350,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    Car car;
    return SizedBox(
      height: height,
      width: width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cars.length,
        itemBuilder: (context, index) {
          car = cars[index];
          return CarPreviewCard(car: car, onTap: () => onCarTap(car));
        },
      ),
    );
  }
}
