import 'package:flutter/material.dart';

import 'package:carrental/screens/home/widgets/Homewidgets/formWidget.dart';
import 'package:carrental/screens/detailscreens/mainDetail.dart';
import 'package:carrental/models/car.dart';
import 'package:carrental/screens/home/widgets/allcarsScreenAndWidget/all_cars_screen.dart';
import 'package:carrental/services/cars_repository.dart';

import 'HomeCategoriesSection.dart';
import 'HomeHorizontalCarSection.dart';
import 'HomeRatedCarsSection.dart';
import 'HomeTopBar.dart';
import 'show_booking_sheet.dart';

class HomeStartUp extends StatefulWidget {
  const HomeStartUp({super.key});

  @override
  State<HomeStartUp> createState() => _HomeStartUpState();
}

class _HomeStartUpState extends State<HomeStartUp> {
  // for scrolling to contact form for the list view

  final ScrollController _scrollController = ScrollController();
  final CarsRepository _carsRepository = CarsRepository();

  // filter the cars by category and navigate to AllCarsScreen

  void _openCategoryCars({required String category, required List<Car> cars}) {
    final filtered = cars.where((c) => c.category == category).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AllCarsScreen(cars: filtered, title: '$category Cars'),
      ),
    );
  }

  void _openCarDetails(Car car) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MainDetail(car: car)),
    );
  }

  void _scrollToContact() {
    _scrollController.animateTo(
      1400,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Car>>(
      // for streaming the list of cars from the repository
      stream: _carsRepository.watchCars(),
      builder: (context, snapshot) {
        // Permission denied (Firebase rules)
        // Invalid query
        // Wrong path (cars doesn’t exist due to typo)
        // Parsing / mapping errors
        // Server-side exceptions
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to load cars',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          );
        }

        final cars = snapshot.data ?? const <Car>[];
        final availableCars = cars.where((c) => c.isAvailable).toList();

        return Builder(
          builder: (context) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ListView(
                controller: _scrollController,
                children: [
                  HomeTopBar(
                    onMenuTap: () => Scaffold.of(context).openDrawer(),
                    onContactTap: _scrollToContact,
                  ),
                  SizedBox(height: 30),
                  HomeCategoriesSection(
                    onCategorySelected: (category) {
                      _openCategoryCars(
                        category: category,
                        cars: availableCars,
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  HomeRatedCarsSection(
                    cars: availableCars,
                    onCarTap: _openCarDetails,
                    onCarLongPress: (car) =>
                        showBookingSheet(context, car: car),
                  ),
                  SizedBox(height: 30),
                  HomeHorizontalCarSection(
                    title: 'Mountain Cars',
                    cars: availableCars,
                    onCarTap: _openCarDetails,
                  ),
                  SizedBox(height: 30),
                  HomeHorizontalCarSection(
                    title: 'Luxury Cars',
                    cars: availableCars,
                    onCarTap: _openCarDetails,
                  ),
                  SizedBox(height: 20),
                  ContactFormScreen(),
                  SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
