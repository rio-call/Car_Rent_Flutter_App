import 'package:flutter/material.dart';

import 'package:carrental/models/car.dart';
import 'package:carrental/screens/home/widgets/Homewidgets/CarPreviewCard.dart';

import 'home_styles.dart';

class HomeRatedCarsSection extends StatelessWidget {
  final List<Car> cars;
  final void Function(Car) onCarTap;
  final void Function(Car) onCarLongPress;

  const HomeRatedCarsSection({
    super.key,
    required this.cars,
    required this.onCarTap,
    required this.onCarLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("⭐ Rated Cars", style: homeSectionTitleStyle),
        SizedBox(height: 20),
        SizedBox(
          height: 320,
          child: ListWheelScrollView(
            itemExtent: 330,
            children: cars
                .map(
                  (car) => CarPreviewCard(
                    car: car,
                    width: 500,
                    onTap: () => onCarTap(car),
                    onLongPress: () => onCarLongPress(car),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
