import 'package:flutter/material.dart';

import '../../models/booking.dart';

class AdminBookingCard extends StatelessWidget {
  final Booking booking;
  final bool isBusy;
  final Color cardColor;
  final Color brandColor;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onSetPending;
  final VoidCallback onDelete;

  const AdminBookingCard({
    super.key,
    required this.booking,
    required this.isBusy,
    required this.cardColor,
    required this.brandColor,
    required this.onApprove,
    required this.onReject,
    required this.onSetPending,
    required this.onDelete,
  });

  int _bookingDays() {
    try {
      final start = DateTime.tryParse(booking.startDate);
      final end = DateTime.tryParse(booking.endDate);
      if (start == null || end == null) return 0;
      final d = end.difference(start).inDays + 1;
      return d < 0 ? 0 : d;
    } catch (_) {
      return 0;
    }
  }

  String _statusNormalized() {
    final s = booking.status.trim();
    return s.isEmpty ? 'pending' : s;
  }

  Color _statusColor() {
    final s = _statusNormalized().toLowerCase();
    if (s == 'approved') return Colors.greenAccent;
    if (s == 'rejected') return Colors.redAccent;
    return Colors.amberAccent;
  }

  String _statusLabel() {
    final s = _statusNormalized().toLowerCase();
    if (s == 'approved') return 'Approved';
    if (s == 'rejected') return 'Rejected';
    return 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    final days = _bookingDays();
    final computedTotal = (booking.totalPriceUsd > 0)
        ? booking.totalPriceUsd
        : (days > 0 ? booking.pricePerDayUsd * days : 0);

    final statusColor = _statusColor();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                color: statusColor,
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
                    overflow: TextOverflow.ellipsis,
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
                    'Total: \$$computedTotal',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (booking.pricePerDayUsd > 0 && days > 0)
                    Text(
                      '\$${booking.pricePerDayUsd}/day • $days day${days == 1 ? '' : 's'}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    booking.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    booking.userEmail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    booking.phone,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.30),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _statusLabel(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isBusy)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    else
                      PopupMenuButton<String>(
                        enabled: !isBusy,
                        tooltip: 'Booking actions',
                        color: Colors.white,
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'approve') {
                            onApprove();
                          } else if (value == 'reject') {
                            onReject();
                          } else if (value == 'pending') {
                            onSetPending();
                          } else if (value == 'delete') {
                            onDelete();
                          }
                        },
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem(
                              value: 'approve',
                              child: Row(
                                children: [
                                  Icon(Icons.check, color: Colors.green),
                                  SizedBox(width: 10),
                                  Text('Approve'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'reject',
                              child: Row(
                                children: [
                                  Icon(Icons.close, color: Colors.orange),
                                  SizedBox(width: 10),
                                  Text('Reject'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'pending',
                              child: Row(
                                children: [
                                  Icon(Icons.hourglass_top, color: brandColor),
                                  const SizedBox(width: 10),
                                  const Text('Set pending'),
                                ],
                              ),
                            ),
                            const PopupMenuDivider(),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 10),
                                  Text('Delete'),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
