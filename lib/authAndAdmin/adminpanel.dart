import 'package:carrental/services/database_serves.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carrental/firebase_options.dart';
import '../models/car.dart';
import '../services/bookings_repository.dart';

import 'adminpanelwidgets/admin_booking_list.dart';
import 'adminpanelwidgets/admin_car_list.dart';
import 'adminpanelwidgets/admin_section_title.dart';

import 'car_form_screen.dart';

const _kBrandColor = Color(0xFF142742);
const _kScaffoldBg = Color(0xFF0B1628);
const _kAccent = Color(0xFF00C2A8);

class CarPanelScreen extends StatefulWidget {
  const CarPanelScreen({super.key});

  @override
  State<CarPanelScreen> createState() => _CarPanelScreenState();
}

class _CarPanelScreenState extends State<CarPanelScreen> {
  final _db = DatabaseService();
  final DatabaseReference _carsRef = FirebaseDatabase.instance.ref('cars');
  final _bookingsRepo = BookingsRepository();
  late final Stream<DatabaseEvent> _carsStream;
  late final Stream<DatabaseEvent> _bookingsStream;
  final Set<String> _busyBookingIds = <String>{};

  @override
  void initState() {
    super.initState();
    _carsStream = _carsRef.onValue.asBroadcastStream();
    _bookingsStream = _bookingsRepo.watchBookings();
  }

  bool _readBool(dynamic v) {
    if (v is bool) return v;
    if (v is int) return v != 0;
    if (v is String) return v.toLowerCase() == 'true' || v == '1';
    return false;
  }

  ImageProvider _imageProvider(String path) {
    final p = path.trim();
    if (p.startsWith('http://') || p.startsWith('https://')) {
      return NetworkImage(p);
    }
    return AssetImage(p);
  }

  int _asInt(dynamic v, {int fallback = 0}) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  double _asDouble(dynamic v, {double fallback = 0.0}) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? fallback;
    return fallback;
  }

  double? _asNullableDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }

  Car _carFromDbMap({required String id, required Map<dynamic, dynamic> map}) {
    final status = map['status']?.toString().trim() ?? 'available';

    return Car(
      id: id,
      status: status,
      category: (map['category'] ?? 'Sedan').toString(),
      make: (map['make'] ?? '').toString(),
      model: (map['model'] ?? '').toString(),
      year: _asInt(map['year']),
      rating: _asDouble(map['rating']),
      reviewCount: _asInt(map['reviewCount'], fallback: 0),
      imageAsset: (map['imageAsset'] ?? 'assets/images/car1.jpg').toString(),
      seats: _asInt(map['seats'], fallback: 5),
      horsepower: _asInt(map['horsepower'], fallback: 150),
      topSpeedKmh: _asInt(map['topSpeedKmh'], fallback: 200),
      transmission: (map['transmission'] ?? 'Automatic').toString(),
      bags: _asInt(map['bags'], fallback: 2),
      overview: (map['overview'] ?? '').toString(),
      pricePerDayUsd: _asInt(map['pricePerDayUsd']),
      ownerName: (map['ownerName'] ?? '').toString(),
      locationName: (map['locationName'] ?? '').toString(),
      latitude: _asNullableDouble(map['latitude']),
      longitude: _asNullableDouble(map['longitude']),
    );
  }

  Future<void> _confirmAndDelete(BuildContext context, Car car) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete car?'),
          content: const Text('This will remove the car from the database.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (ok != true) return;
    await _db.deleteData('cars/${car.id}');
  }

  Future<void> _setBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    setState(() => _busyBookingIds.add(bookingId));
    try {
      await _bookingsRepo.updateBookingStatus(
        bookingId: bookingId,
        status: status,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking set to "$status"')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update booking: $e')));
    } finally {
      if (mounted) {
        setState(() => _busyBookingIds.remove(bookingId));
      }
    }
  }

  Future<void> _confirmAndDeleteBooking({required String bookingId}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Delete booking?'),
          content: const Text(
            'This will remove the booking from the database.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (ok != true) return;

    setState(() => _busyBookingIds.add(bookingId));
    try {
      await _bookingsRepo.deleteBooking(bookingId: bookingId);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking deleted')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete booking: $e')));
    } finally {
      if (mounted) {
        setState(() => _busyBookingIds.remove(bookingId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kScaffoldBg,
      appBar: AppBar(
        title: const Text(
          'Admin Panel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: _kBrandColor,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const CarFormScreen()),
          );
        },
        backgroundColor: _kAccent,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AdminSectionTitle(title: 'Cars'),
            AdminCarList(
              stream: _carsStream,
              readBool: _readBool,
              carFromDbMap: (id, map) => _carFromDbMap(id: id, map: map),
              imageProvider: _imageProvider,
              cardColor: _kBrandColor,
              onEdit: (context, car, isRented) async {
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CarFormScreen(
                      initialCar: car,
                      initialIsRented: isRented,
                    ),
                  ),
                );
              },
              onDelete: (context, car) => _confirmAndDelete(context, car),
            ),

            const AdminSectionTitle(title: 'Bookings'),
            AdminBookingList(
              stream: _bookingsStream,
              busyBookingIds: _busyBookingIds,
              cardColor: _kBrandColor,
              brandColor: _kBrandColor,
              setBookingStatus: _setBookingStatus,
              deleteBooking: ({required bookingId}) =>
                  _confirmAndDeleteBooking(bookingId: bookingId),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MaterialApp(home: CarPanelScreen()));
}
