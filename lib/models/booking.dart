import 'package:flutter/foundation.dart';

@immutable
class Booking {
  final String id;
  final String carId;
  final String carName;

  /// Price per day at time of booking.
  final int pricePerDayUsd;

  /// Total price for the booking.
  final int totalPriceUsd;

  final String userId;
  final String userEmail;

  final String fullName;
  final String phone;

  /// ISO-8601 date string (yyyy-mm-dd)
  final String startDate;

  /// ISO-8601 date string (yyyy-mm-dd)
  final String endDate;

  /// Epoch millis
  final int createdAt;

  /// Simple status to support admin visibility.
  /// Expected values: pending | approved | rejected
  final String status;

  const Booking({
    required this.id,
    required this.carId,
    required this.carName,
    required this.pricePerDayUsd,
    required this.totalPriceUsd,
    required this.userId,
    required this.userEmail,
    required this.fullName,
    required this.phone,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    this.status = 'pending',
  });

  Map<String, dynamic> toDbMap() {
    return {
      'carId': carId,
      'carName': carName,
      'pricePerDayUsd': pricePerDayUsd,
      'totalPriceUsd': totalPriceUsd,
      'userId': userId,
      'userEmail': userEmail,
      'fullName': fullName,
      'phone': phone,
      'startDate': startDate,
      'endDate': endDate,
      'createdAt': createdAt,
      'status': status,
    };
  }

  static Booking fromDbMap({
    required String id,
    required Map<dynamic, dynamic> map,
  }) {
    String asString(dynamic v, {String fallback = ''}) =>
        (v == null) ? fallback : v.toString();

    int asInt(dynamic v, {int fallback = 0}) {
      if (v is int) return v;
      if (v is double) return v.toInt();
      if (v is String) return int.tryParse(v) ?? fallback;
      return fallback;
    }

    return Booking(
      id: id,
      carId: asString(map['carId']),
      carName: asString(map['carName']),
      pricePerDayUsd: asInt(map['pricePerDayUsd']),
      totalPriceUsd: asInt(map['totalPriceUsd']),
      userId: asString(map['userId']),
      userEmail: asString(map['userEmail']),
      fullName: asString(map['fullName']),
      phone: asString(map['phone']),
      startDate: asString(map['startDate']),
      endDate: asString(map['endDate']),
      createdAt: asInt(map['createdAt']),
      status: asString(map['status'], fallback: 'pending'),
    );
  }
}
