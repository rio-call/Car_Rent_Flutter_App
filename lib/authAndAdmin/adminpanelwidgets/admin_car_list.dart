import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../models/car.dart';
import 'admin_car_card.dart';

class AdminCarList extends StatelessWidget {
  final Stream<DatabaseEvent> stream;
  final bool Function(dynamic value) readBool;
  final Car Function(String id, Map<dynamic, dynamic> map) carFromDbMap;
  final ImageProvider Function(String path) imageProvider;
  final Color cardColor;
  final Future<void> Function(BuildContext context, Car car, bool isRented)
  onEdit;
  final Future<void> Function(BuildContext context, Car car) onDelete;

  const AdminCarList({
    super.key,
    required this.stream,
    required this.readBool,
    required this.carFromDbMap,
    required this.imageProvider,
    required this.cardColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                'Failed to load cars: ${snapshot.error}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }

        final data = snapshot.data?.snapshot.value;
        if (data == null) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text(
                'No cars yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        if (data is! Map) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text(
                'Unexpected data format',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        final entries = data.entries.toList();
        entries.sort((a, b) => a.key.toString().compareTo(b.key.toString()));

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: entries.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final carId = entries[index].key.toString();
            final raw = entries[index].value;
            if (raw is! Map) return const SizedBox.shrink();

            final map = Map<dynamic, dynamic>.from(raw);
            final isRented = readBool(map['isRented']);
            final car = carFromDbMap(carId, map);

            return AdminCarCard(
              car: car,
              isRented: isRented,
              cardColor: cardColor,
              carImage: imageProvider(car.imageAsset),
              onEdit: () => onEdit(context, car, isRented),
              onDelete: () => onDelete(context, car),
            );
          },
        );
      },
    );
  }
}
