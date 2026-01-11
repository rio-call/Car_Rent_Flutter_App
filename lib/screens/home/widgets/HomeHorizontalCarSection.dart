import 'package:flutter/material.dart';

import 'package:carrental/models/car.dart';
import 'package:carrental/screens/home/widgets/Homewidgets/CarHorizontalScroller.dart';

import 'home_styles.dart';

class HomeHorizontalCarSection extends StatelessWidget {
  final String title;
  final List<Car> cars;
  final ValueChanged<Car> onCarTap;

  const HomeHorizontalCarSection({
    super.key,
    required this.title,
    required this.cars,
    required this.onCarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: homeSectionTitleStyle),
        SizedBox(height: 20),
        CarHorizontalScroller(cars: cars, onCarTap: onCarTap),
      ],
    );
  }
}
