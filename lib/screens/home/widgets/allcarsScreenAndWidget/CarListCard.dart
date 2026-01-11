import 'package:flutter/material.dart';

import 'package:carrental/models/car.dart';

/// Vertical list card used by the All Cars screen.
///
/// Important: all displayed values are read from the provided [car]
/// (which typically comes from `kCars` in `lib/data/cars_data.dart`).
class CarListCard extends StatelessWidget {
  final Car car;
  final VoidCallback? onTap;

  const CarListCard({super.key, required this.car, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: InkWell(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          color: const Color(0xFF142742),
          elevation: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Clickable hero image
              InkWell(
                onTap: onTap,
                child: Image.asset(
                  car.imageAsset,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),

              // Name + price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      car.fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Text(
                      '\$${car.pricePerDayUsd}/day',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Quick specs
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Model: ${car.year}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Bags: ${car.bags}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Seats: ${car.seats}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Transmission + top speed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Transmission: ${car.transmission}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Top speed: ${car.topSpeedKmh} km/h',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
