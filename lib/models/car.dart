import 'package:flutter/foundation.dart';

@immutable
class Car {
  final String id;

  /// Availability status controlled by the database.
  /// Expected values: "available" | "rented".
  final String status;
  final String category; 
  final String make;
  final String model;
  final int year;
  final double rating; // 0..5
  final int reviewCount;
  final String imageAsset; // local asset path

  // Basic specs
  final int seats;
  final int horsepower;
  final int topSpeedKmh;
  final String transmission; // e.g., Auto, Manual, CVT
  final int bags; // luggage capacity

  // Description & pricing
  final String overview;
  final int pricePerDayUsd;

  // Owner
  final String ownerName;

  // Location
  final String locationName; // e.g., address or area
  final double? latitude;
  final double? longitude;

  const Car({
    required this.id,
    this.status = 'available',
    required this.category,
    required this.make,
    required this.model,
    required this.year,
    required this.rating,
    required this.reviewCount,
    required this.imageAsset,
    required this.seats,
    required this.horsepower,
    required this.topSpeedKmh,
    required this.transmission,
    required this.bags,
    required this.overview,
    required this.pricePerDayUsd,
    required this.ownerName,
    required this.locationName,
    this.latitude,
    this.longitude,
  });

  String get fullName => '$make $model';

  bool get isAvailable => status.toLowerCase() == 'available';
}
