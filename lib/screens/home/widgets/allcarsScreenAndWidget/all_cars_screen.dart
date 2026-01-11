import 'package:flutter/material.dart';

import 'package:carrental/screens/detailscreens/mainDetail.dart';
import 'package:carrental/models/car.dart';
import 'package:carrental/screens/home/widgets/allcarsScreenAndWidget/CarListCard.dart';
import 'package:carrental/services/cars_repository.dart';

class AllCarsScreen extends StatelessWidget {
  final List<Car>? cars;
  final String title;

  const AllCarsScreen({super.key, this.cars, this.title = 'All Cars'});

  @override
  Widget build(BuildContext context) {
    final providedCars = cars;

    Widget buildBody(List<Car> carsToShow) {
      final availableCars = carsToShow.where((c) => c.isAvailable).toList();

      return availableCars.isEmpty
          ? const Center(
              child: Text(
                'No cars found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              itemCount: availableCars.length,
              itemBuilder: (context, index) {
                final car = availableCars[index];
                return CarListCard(
                  car: car,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainDetail(car: car),
                      ),
                    );
                  },
                );
              },
            );
    }










    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF142742),
      ),
      backgroundColor: const Color(0xFF0B1628),
      body: providedCars != null
          ? buildBody(providedCars)
          : StreamBuilder<List<Car>>(
              stream: CarsRepository().watchCars(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to load cars: ${snapshot.error}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }
                return buildBody(snapshot.data ?? const <Car>[]);
              },
            ),
    );
  }
}
