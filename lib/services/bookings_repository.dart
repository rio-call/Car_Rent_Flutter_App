import 'package:firebase_database/firebase_database.dart';

import '../models/booking.dart';

class BookingsRepository {
  final DatabaseReference _bookingsRef;
  late  Stream<DatabaseEvent> _bookingsStream;

  BookingsRepository({DatabaseReference? bookingsRef})
    : _bookingsRef = bookingsRef ?? FirebaseDatabase.instance.ref('bookings') {
    _bookingsStream = _bookingsRef.onValue.asBroadcastStream();
  }

  Future<String> createBooking(Booking booking) async {
    final String bookingId = booking.id.isEmpty
        ? _bookingsRef.push().key!
        : booking.id;

    await _bookingsRef.child(bookingId).set(booking.toDbMap());
    return bookingId;
  }

  Future<void> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    await _bookingsRef.child(bookingId).update({'status': status});
  }

  Future<void> deleteBooking({required String bookingId}) async {
    await _bookingsRef.child(bookingId).remove();
  }

  Stream<DatabaseEvent> watchBookings() {
    return _bookingsStream;
  }

  //  query that filters bookings where the userId field matches the given user Id
  Stream<DatabaseEvent> watchBookingsForUser(String userId) {
    //  to filter in order  by id
    // It tells Firebase to sort the data b
    //y the value of the userId field in each booking.
    // the .equalTo(userId) method further filters the sorted data
    // this code is a server-side filter
    final query = _bookingsRef.orderByChild('userId').equalTo(userId);
    return query.onValue.asBroadcastStream();
  }
  // .asBroadcastStream() allows multiple parts 
  //of app to listen to this stream at the same time.
}
