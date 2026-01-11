import 'package:carrental/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../models/booking.dart';
import '../../../services/bookings_repository.dart';

const _kBrandColor = Color(0xFF142742);
const _kScaffoldBg = Color(0xFF0B1628);

class BookedScreen extends StatefulWidget {
  const BookedScreen({super.key});

  @override
  State<BookedScreen> createState() => _BookedScreenState();
}

class _BookedScreenState extends State<BookedScreen> {
  final _repo = BookingsRepository();

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser!;

    // if (user == null) {
    //   return const Center(
    //     child: Text(
    //       'Please sign in to view your bookings.',
    //       style: TextStyle(
    //         fontSize: 16,
    //         fontWeight: FontWeight.w700,
    //         color: Colors.white,
    //       ),
    //     ),
    //   );
    // }

    Color statusColor(String status) {
      final s = status.toLowerCase();
      if (s == 'approved') return Colors.greenAccent;
      if (s == 'rejected') return Colors.redAccent;
      return Colors.amberAccent;
    }

    String statusLabel(String status) {
      final s = status.toLowerCase();
      if (s == 'approved') return 'Approved';
      if (s == 'rejected') return 'Rejected';
      return 'Pending';
    }

    int bookingDays(Booking b) {
      try {
        final start = DateTime.tryParse(b.startDate);
        final end = DateTime.tryParse(b.endDate);
        if (start == null || end == null) return 0;
        final d = end.difference(start).inDays + 1;
        return d < 0 ? 0 : d;
      } catch (_) {
        return 0;
      }
    }

    return Scaffold(
      backgroundColor: _kScaffoldBg,
      appBar: AppBar(
        backgroundColor: _kBrandColor,
        foregroundColor: Colors.white,
        title: const Text(
          'My Bookings',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: _repo.watchBookingsForUser(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load bookings: ${snapshot.error}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            );
          }

          final raw = snapshot.data?.snapshot.value;
          if (raw == null) {
            return const Center(
              child: Text(
                'No bookings yet.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            );
          }

          if (raw is! Map) {
            return const Center(
              child: Text(
                'Unexpected data format.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            );
          }
          //
          final entries = raw.entries.toList();
          entries.sort((a, b) {
            final aMap = a.value as Map?;
            final bMap = b.value as Map?;
            final aCreated = int.tryParse('${aMap?['createdAt'] ?? 0}') ?? 0;
            final bCreated = int.tryParse('${bMap?['createdAt'] ?? 0}') ?? 0;
            return bCreated.compareTo(aCreated);
          });

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final bookingId = entries[index].key.toString();
              final value = entries[index].value;
              // if (value is! Map) return const SizedBox.shrink();
              // parse booking from map
              final booking = Booking.fromDbMap(
                id: bookingId,
                map: Map<dynamic, dynamic>.from(value),
              );

              final status = booking.status.trim().isEmpty
                  ? 'pending'
                  : booking.status.trim();

              final days = bookingDays(booking);
              // final total = (booking.totalPriceUsd > 0)
              //     ? booking.totalPriceUsd
              //     : (days > 0 ? booking.pricePerDayUsd * days : 0);
              final total = booking.totalPriceUsd;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: _kBrandColor,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          color: statusColor(status),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.carName,
                              maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${booking.startDate} → ${booking.endDate}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Total: \$$total',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            if (booking.pricePerDayUsd > 0 && days > 0) ...[
                              const SizedBox(height: 4),
                              Text(
                                '\$${booking.pricePerDayUsd}/day • $days day${days == 1 ? '' : 's'}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor(status).withValues(alpha: 0.30),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          statusLabel(status),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
