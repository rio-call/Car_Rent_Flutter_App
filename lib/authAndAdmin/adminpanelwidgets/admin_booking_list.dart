import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../models/booking.dart';
import 'admin_booking_card.dart';

class AdminBookingList extends StatelessWidget {
  final Stream<DatabaseEvent> stream;
  final Set<String> busyBookingIds;
  final Color cardColor;
  final Color brandColor;
  final Future<void> Function({
    required String bookingId,
    required String status,
  })
  setBookingStatus;
  final Future<void> Function({required String bookingId}) deleteBooking;

  const AdminBookingList({
    super.key,
    required this.stream,
    required this.busyBookingIds,
    required this.cardColor,
    required this.brandColor,
    required this.setBookingStatus,
    required this.deleteBooking,
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
                'Failed to load bookings:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        }

        final raw = snapshot.data?.snapshot.value;
        if (raw == null) {
          return const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: Text(
                'No bookings yet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          );
        }

        if (raw is! Map) {
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

        final entries = raw.entries.toList();
        entries.sort((a, b) {
          final aMap = a.value is Map
              ? Map<dynamic, dynamic>.from(a.value as Map)
              : const <dynamic, dynamic>{};
          final bMap = b.value is Map
              ? Map<dynamic, dynamic>.from(b.value as Map)
              : const <dynamic, dynamic>{};
          final aCreated = (aMap['createdAt'] is int)
              ? (aMap['createdAt'] as int)
              : int.tryParse('${aMap['createdAt']}') ?? 0;
          final bCreated = (bMap['createdAt'] is int)
              ? (bMap['createdAt'] as int)
              : int.tryParse('${bMap['createdAt']}') ?? 0;
          return bCreated.compareTo(aCreated);
        });

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: entries.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final bookingId = entries[index].key.toString();
            final value = entries[index].value;
            if (value is! Map) return const SizedBox.shrink();

            final booking = Booking.fromDbMap(
              id: bookingId,
              map: Map<dynamic, dynamic>.from(value),
            );
            final isBusy = busyBookingIds.contains(booking.id);

            return AdminBookingCard(
              booking: booking,
              isBusy: isBusy,
              cardColor: cardColor,
              brandColor: brandColor,
              onApprove: () =>
                  setBookingStatus(bookingId: booking.id, status: 'approved'),
              onReject: () =>
                  setBookingStatus(bookingId: booking.id, status: 'rejected'),
              onSetPending: () =>
                  setBookingStatus(bookingId: booking.id, status: 'pending'),
              onDelete: () => deleteBooking(bookingId: booking.id),
            );
          },
        );
      },
    );
  }
}
