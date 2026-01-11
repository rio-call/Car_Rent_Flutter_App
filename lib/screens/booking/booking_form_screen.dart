import 'package:carrental/screens/MainScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/booking.dart';
import '../../models/car.dart';
import '../../services/bookings_repository.dart';

const _kBrandColor = Color(0xFF0F1B33);
const _kScaffoldBg = Color(0xFF070D18);

class BookingFormScreen extends StatefulWidget {
  final Car car;

  const BookingFormScreen({super.key, required this.car});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = BookingsRepository();

  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final startDateCtrl = TextEditingController();
  final endDateCtrl = TextEditingController();

  bool isSaving = false;

  @override
  void dispose() {
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    startDateCtrl.dispose();
    endDateCtrl.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  int? _daysCount() {
    final start = startDateCtrl.text.trim();
    final end = endDateCtrl.text.trim();
    if (start.isEmpty || end.isEmpty) return null;
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      if (e.isBefore(s)) return null;
      // if it is chooses the same day it counts as 1 day
      //counts days
      return e.difference(s).inDays + 1;
      //
    } catch (e) {
      return null;
    }
  }

  int? _totalPriceUsd() {
    final days = _daysCount();
    //if days is null return null
    if (days == null) return null;
    // calculate total price
    return widget.car.pricePerDayUsd * days;
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    final initial = DateTime(now.year, now.month, now.day);
    // this shows the date picker dialog
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: initial,
      // allow picking dates up to 2 years in the future
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) return;
    //  to-string in yyyy-MM-dd format
    final value = picked.toIso8601String().split('T').first;
    setState(() {
      controller.text = value;
    });
  }

  bool _isEndAfterStart({required String start, required String end}) {
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      return !e.isBefore(s);
    } catch (_) {
      return false;
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    // get current user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // in case the user is not signed in
      // and somehow reached this screen
      // future enhancement: navigate to auth screen
      // if (!mounted) return;
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('Please sign in first.')));
      // Navigator.pop(context);
      return;
    }

    final start = startDateCtrl.text.trim();
    final end = endDateCtrl.text.trim();
    if (!_isEndAfterStart(start: start, end: end)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date.')),
      );
      return;
    }

// calculate days and total price
    final days = _daysCount();
    final totalPrice = _totalPriceUsd();
    if (days == null || totalPrice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose valid dates.')),
      );
      return;
    }

    setState(() => isSaving = true);
    try {
      final booking = Booking(
        id: '',
        carId: widget.car.id,
        carName: widget.car.fullName,
        pricePerDayUsd: widget.car.pricePerDayUsd,
        totalPriceUsd: totalPrice,
        userId: user.uid,
        userEmail: user.email ?? '',
        fullName: fullNameCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
        startDate: start,
        endDate: end,
        // from 1970 to now in milliseconds
        createdAt: DateTime.now().millisecondsSinceEpoch,
        status: 'pending',
      );
      // create booking in the database
      await _repo.createBooking(booking);
      // if (!mounted) return;
      // Safety check: if the screen was closed while the code was running, don’t use context (prevents errors).
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking submitted.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Booking failed')));
    } finally {
      // to do not set state and get stuck
      if (mounted) setState(() => isSaving = false);
    }
  }

  Widget _carImageHeader() {
    final path = widget.car.imageAsset.trim();

    return Card(
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 180,
          child: path.isEmpty
              ? const ColoredBox(
                  color: Color(0xFFE2E8F0),
                  child: Center(
                    child: Icon(
                      Icons.directions_car,
                      size: 54,
                      color: _kBrandColor,
                    ),
                  ),
                )
              : Image.asset(
                  path,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: Color(0xFFE2E8F0),
                      child: Center(
                        child: Icon(
                          Icons.broken_image_outlined,
                          size: 54,
                          color: _kBrandColor,
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration fieldDecoration(String label, {Widget? suffixIcon}) {
      return InputDecoration(
        labelText: label,
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
          borderSide: const BorderSide(color: _kBrandColor, width: 2),
        ),
        suffixIcon: suffixIcon,
      );
    }

    return Scaffold(
      backgroundColor: _kScaffoldBg,
      appBar: AppBar(
        backgroundColor: _kBrandColor,
        foregroundColor: Colors.white,
        title: const Text(
          'Booking',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _carImageHeader(),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                color: _kBrandColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.car.fullName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.car.locationName,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 3,
                color: _kBrandColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Price per day: \$${widget.car.pricePerDayUsd}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Days: ${_daysCount() ?? '-'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Total: \$${_totalPriceUsd() ?? '-'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: fullNameCtrl,
                decoration: fieldDecoration('Full name'),
                validator: _required,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneCtrl,
                decoration: fieldDecoration('Phone number'),
                keyboardType: TextInputType.phone,
                validator: _required,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: startDateCtrl,
                readOnly: true,
                decoration: fieldDecoration(
                  'Start date',
                  suffixIcon: IconButton(
                    onPressed: () => _pickDate(startDateCtrl),
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
                validator: _required,
                onTap: () => _pickDate(startDateCtrl),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: endDateCtrl,
                readOnly: true,
                decoration: fieldDecoration(
                  'End date',
                  suffixIcon: IconButton(
                    onPressed: () => _pickDate(endDateCtrl),
                    icon: const Icon(Icons.calendar_month),
                  ),
                ),
                validator: _required,
                onTap: () => _pickDate(endDateCtrl),
              ),
              const SizedBox(height: 16),

              FilledButton(
                onPressed: isSaving ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: _kBrandColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Confirm booking',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
