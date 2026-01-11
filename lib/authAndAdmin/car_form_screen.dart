import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../models/car.dart';
import '../services/database_serves.dart';

const _kBrandColor = Color(0xFF142742);
const _kScaffoldBg = Color(0xFF0B1628);
const _kAccent = Color(0xFF00C2A8);

class CarFormScreen extends StatefulWidget {
  final Car? initialCar;
  final bool initialIsRented;

  const CarFormScreen({
    super.key,
    this.initialCar,
    this.initialIsRented = false,
  });

  @override
  State<CarFormScreen> createState() => _CarFormScreenState();
}

class _CarFormScreenState extends State<CarFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseService();
  final DatabaseReference _carsRef = FirebaseDatabase.instance.ref('cars');

  late final TextEditingController ownerCtrl;
  late final TextEditingController makeCtrl;
  late final TextEditingController modelCtrl;
  late final TextEditingController yearCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController ratingCtrl;
  late final TextEditingController reviewCountCtrl;
  late final TextEditingController locationCtrl;
  late final TextEditingController latitudeCtrl;
  late final TextEditingController longitudeCtrl;
  late final TextEditingController categoryCtrl;
  late final TextEditingController imageAssetCtrl;
  late final TextEditingController overviewCtrl;

  bool isRented = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final car = widget.initialCar;

    ownerCtrl = TextEditingController(text: car?.ownerName ?? '');
    makeCtrl = TextEditingController(text: car?.make ?? '');
    modelCtrl = TextEditingController(text: car?.model ?? '');
    yearCtrl = TextEditingController(text: car == null ? '' : '${car.year}');
    priceCtrl = TextEditingController(
      text: car == null ? '' : '${car.pricePerDayUsd}',
    );
    ratingCtrl = TextEditingController(
      text: car == null ? '' : '${car.rating}',
    );
    reviewCountCtrl = TextEditingController(
      text: car == null ? '0' : '${car.reviewCount}',
    );
    locationCtrl = TextEditingController(text: car?.locationName ?? '');
    latitudeCtrl = TextEditingController(
      text: car?.latitude == null ? '' : '${car?.latitude}',
    );
    longitudeCtrl = TextEditingController(
      text: car?.longitude == null ? '' : '${car?.longitude}',
    );
    categoryCtrl = TextEditingController(text: car?.category ?? 'Sedan');
    imageAssetCtrl = TextEditingController(
      text: car?.imageAsset ?? 'assets/images/car1.jpg',
    );
    overviewCtrl = TextEditingController(text: car?.overview ?? '');

    isRented = widget.initialIsRented;
  }

  @override
  void dispose() {
    ownerCtrl.dispose();
    makeCtrl.dispose();
    modelCtrl.dispose();
    yearCtrl.dispose();
    priceCtrl.dispose();
    ratingCtrl.dispose();
    reviewCountCtrl.dispose();
    locationCtrl.dispose();
    latitudeCtrl.dispose();
    longitudeCtrl.dispose();
    categoryCtrl.dispose();
    imageAssetCtrl.dispose();
    overviewCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  int _asInt(String v, {int fallback = 0}) =>
      int.tryParse(v.trim()) ?? fallback;
  double _asDouble(String v, {double fallback = 0}) =>
      double.tryParse(v.trim()) ?? fallback;

  double? _asNullableDouble(String v) {
    final trimmed = v.trim();
    if (trimmed.isEmpty) return null;
    return double.tryParse(trimmed);
  }

  Map<String, dynamic> _carToDbMap(Car car) {
    return {
      'category': car.category,
      'make': car.make,
      'model': car.model,
      'year': car.year,
      'rating': car.rating,
      'reviewCount': car.reviewCount,
      'imageAsset': car.imageAsset,
      'seats': car.seats,
      'horsepower': car.horsepower,
      'topSpeedKmh': car.topSpeedKmh,
      'transmission': car.transmission,
      'bags': car.bags,
      'overview': car.overview,
      'pricePerDayUsd': car.pricePerDayUsd,
      'ownerName': car.ownerName,
      'locationName': car.locationName,
      'latitude': car.latitude,
      'longitude': car.longitude,
    };
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => isSaving = true);
    try {
      final existingId = widget.initialCar?.id;

      final String carId = (existingId == null || existingId.isEmpty)
          ? _carsRef.push().key!
          : existingId;

      final car = Car(
        id: carId,
        status: isRented ? 'rented' : 'available',
        category: categoryCtrl.text.trim(),
        make: makeCtrl.text.trim(),
        model: modelCtrl.text.trim(),
        year: _asInt(yearCtrl.text),
        rating: _asDouble(ratingCtrl.text),
        reviewCount: _asInt(reviewCountCtrl.text, fallback: 0),
        imageAsset: imageAssetCtrl.text.trim(),
        seats: widget.initialCar?.seats ?? 5,
        horsepower: widget.initialCar?.horsepower ?? 150,
        topSpeedKmh: widget.initialCar?.topSpeedKmh ?? 200,
        transmission: widget.initialCar?.transmission ?? 'Automatic',
        bags: widget.initialCar?.bags ?? 2,
        overview: overviewCtrl.text.trim(),
        pricePerDayUsd: _asInt(priceCtrl.text),
        ownerName: ownerCtrl.text.trim(),
        locationName: locationCtrl.text.trim(),
        latitude: _asNullableDouble(latitudeCtrl.text),
        longitude: _asNullableDouble(longitudeCtrl.text),
      );

      final data = <String, dynamic>{
        ..._carToDbMap(car),
        // Legacy + compatibility
        'isRented': isRented,
        // New field used by the main app
        'status': car.status,
      };

      await _db.saveData('cars/$carId', data);

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialCar != null;

    InputDecoration fieldDecoration(String label, {String? helperText}) {
      return InputDecoration(
        hintText: label,
        helperText: helperText,
        helperStyle: const TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.w600,
        ),
        errorStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _kAccent, width: 2),
        ),
      );
    }

    Widget section({required String title, required List<Widget> children}) {
      return Card(
        elevation: 3,
        color: _kBrandColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: _kScaffoldBg,
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Car' : 'Add Car',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: _kBrandColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              section(
                title: 'Basic Information',
                children: [
                  TextFormField(
                    controller: ownerCtrl,
                    validator: _required,
                    decoration: fieldDecoration('Owner Name'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: makeCtrl,
                          validator: _required,
                          decoration: fieldDecoration('Make'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: modelCtrl,
                          validator: _required,
                          decoration: fieldDecoration('Model'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: categoryCtrl,
                    validator: _required,
                    decoration: fieldDecoration('Category'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              section(
                title: 'Pricing & Rating',
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: yearCtrl,
                          keyboardType: TextInputType.number,
                          validator: _required,
                          decoration: fieldDecoration('Year'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          validator: _required,
                          decoration: fieldDecoration('Price / day'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: ratingCtrl,
                          keyboardType: TextInputType.number,
                          validator: _required,
                          decoration: fieldDecoration('Rating (0..5)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: reviewCountCtrl,
                          keyboardType: TextInputType.number,
                          decoration: fieldDecoration('Reviews'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'On Rent',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Switch(
                        value: isRented,
                        onChanged: (v) => setState(() => isRented = v),
                        activeThumbColor: Colors.white,
                        activeTrackColor: Colors.white54,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.white24,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              section(
                title: 'Location',
                children: [
                  TextFormField(
                    controller: locationCtrl,
                    validator: _required,
                    decoration: fieldDecoration('Location'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: latitudeCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: fieldDecoration('Latitude (optional)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: longitudeCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                          decoration: fieldDecoration('Longitude (optional)'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              section(
                title: 'Media & Overview',
                children: [
                  TextFormField(
                    controller: imageAssetCtrl,
                    validator: _required,
                    decoration: fieldDecoration(
                      'Image Path',
                      helperText: 'Example: assets/images/car1.jpg',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: overviewCtrl,
                    maxLines: 4,
                    decoration: fieldDecoration('Overview'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: isSaving ? null : _save,
                  style: FilledButton.styleFrom(
                    backgroundColor: _kAccent,
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(isEdit ? Icons.save : Icons.add),
                  label: Text(isEdit ? 'Save Changes' : 'Add Car'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
