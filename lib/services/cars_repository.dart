import 'package:firebase_database/firebase_database.dart';

import '../models/car.dart';
// convert events from Firebase Realtime Database
//into a list of Car objects for use in the app.
// This function transforms the raw Firebase
//data for all cars into a clean,
//sorted list of Car objects for your app to use.

class CarsRepository {
  final DatabaseReference _carsRef;

  CarsRepository({DatabaseReference? carsRef})
    // if no reference is provided, use the 'cars' node in the database
    // as the default reference this used by watchCars()
    : _carsRef = carsRef ?? FirebaseDatabase.instance.ref('cars');

  // streaming the list of cars from the database
  // whenever there is a change in the cars data, i]
  // Listens for any changes
  // (add, update, delete) at the cars node in  database.
  Stream<List<Car>> watchCars() {
    // listen to changes at the 'cars' node
    // .onValue is a property of
    //a Firebase Realtime Database reference that returns
    //a stream of events for the data at that location
    // Every time the data changes, it emits a new DatabaseEvent
    //containing the latest data snapshot.

    return _carsRef.onValue.asBroadcastStream().map(
      (event) => _parseCars(event.snapshot),
    );
  }

  // catch only map data and convert it to list of Car objects
  List<Car> _parseCars(DataSnapshot snapshot) {
    // data type is dynamic
    final data = snapshot.value;
    if (data == null) return const <Car>[];

    if (data is! Map) return const <Car>[];
    // Firebase automatically converts JSON objects to Dart Map objects
    // so we need to cast the dynamic data
    // data.entries  =  Iterable<MapEntry<dynamic, dynamic>> and must be sorted by key
    // change to List<MapEntry<dynamic, dynamic>>
    // becouse Map does not guarantee order of entries
    final entries = data.entries.toList();
    // sort entries by key to have consistent order
    // key is dynamic so convert to string for comparison
    // sort in place based on the string representation of the keys
    entries.sort((a, b) => a.key.toString().compareTo(b.key.toString()));

    final cars = <Car>[];
    for (final entry in entries) {
      final id = entry.key.toString();
      final raw = entry.value;
      if (raw is! Map) continue;
      final map = Map<dynamic, dynamic>.from(raw);
      cars.add(_mapToCar(id: id, map: map));
    }
    return cars;
  }

  bool _toBool(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v != 0;
    if (v is String) return v.toLowerCase() == 'true' || v == '1';
    return false;
  }

  int _toInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  double _toDouble(dynamic v, {double fallback = 0.0}) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? fallback;
    return fallback;
  }

  double? _toNullableDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  Car _mapToCar({required String id, required Map<dynamic, dynamic> map}) {
    final status = map['status']?.toString().trim() ?? 'available';

    return Car(
      id: id,
      status: status,
      category: (map['category'] ?? 'Sedan').toString(),
      make: (map['make'] ?? '').toString(),
      model: (map['model'] ?? '').toString(),
      year: _toInt(map['year']),
      rating: _toDouble(map['rating']),
      reviewCount: _toInt(map['reviewCount'], fallback: 0),
      imageAsset: (map['imageAsset'] ?? 'assets/images/car1.jpg').toString(),
      seats: _toInt(map['seats'], fallback: 5),
      horsepower: _toInt(map['horsepower'], fallback: 150),
      topSpeedKmh: _toInt(map['topSpeedKmh'], fallback: 200),
      transmission: (map['transmission'] ?? 'Automatic').toString(),
      bags: _toInt(map['bags'], fallback: 2),
      overview: (map['overview'] ?? '').toString(),
      pricePerDayUsd: _toInt(map['pricePerDayUsd']),
      ownerName: (map['ownerName'] ?? '').toString(),
      locationName: (map['locationName'] ?? '').toString(),
      latitude: _toNullableDouble(map['latitude']),
      longitude: _toNullableDouble(map['longitude']),
    );
  }
}
