import 'package:flutter/material.dart';

import 'package:carrental/models/car.dart';

import 'car_details_screen.dart';
import 'Map.dart';
import '../booking/booking_form_screen.dart';

class MainDetail extends StatefulWidget {
  final Car car;
  const MainDetail({super.key, required this.car});

  @override
  State<MainDetail> createState() => _MainDetailState();
}

class _MainDetailState extends State<MainDetail> {
  // 0: details, 1: location
  int index = 0; // 0: details, 1: location

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    const double barBottom = 16;
    const double barHeight = 72;
    const double fabHeight = 52;

    // Two-tab shell:
    // - CarDetailsScreen uses the full Car model
    // - CarLocationMap derives coordinates from the same Car model
    final pages = [
      CarDetailsScreen(car: car),
      CarLocationMap.fromCar(car: car),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1628),
      body: Stack(
        children: [
          // Active page
          Positioned.fill(child: pages[index]),

          // Curved dark bottom bar like reference - sticky two tabs
          Positioned(
            left: 16,
            right: 16,
            bottom: barBottom,
            child: _BottomBar(
              index: index,
              onTap: (i) {
                setState(() {
                  index = i;
                });
              },
              twoTabsOnly: true,
            ),
          ),

          // Center CTA button (kept as-is), positioned inside the bar.
          // Placed after the bar so it renders on top.
          Positioned(
            left: 0,
            right: 0,
            bottom: barBottom + (barHeight - fabHeight) / 2,
            child: Center(
              child: _BookNowFab(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => BookingFormScreen(car: car),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;
  final bool twoTabsOnly;
  const _BottomBar({
    required this.index,
    required this.onTap,
    this.twoTabsOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF101418),
        borderRadius: BorderRadius.circular(36),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 64),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: twoTabsOnly
            ? [
                _NavIcon(
                  icon: Icons.directions_car_filled,
                  selected: index == 0,
                  onTap: () => onTap(0),
                ),
                const SizedBox(width: 48), // space for center FAB
                _NavIcon(
                  icon: Icons.map,
                  selected: index == 1,
                  onTap: () => onTap(1),
                ),
              ]
            : [
                _NavIcon(
                  icon: Icons.directions_car_filled,
                  selected: index == 0,
                  onTap: () => onTap(0),
                ),
                _NavIcon(
                  icon: Icons.map,
                  selected: index == 1,
                  onTap: () => onTap(1),
                ),
                const SizedBox(width: 100),
                _NavIcon(icon: Icons.bolt, selected: false, onTap: () {}),
                _NavIcon(icon: Icons.settings, selected: false, onTap: () {}),
              ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          icon,
          color: selected ? const Color(0xFF00C2A8) : Colors.white,
        ),
      ),
    );
  }
}

class _BookNowFab extends StatelessWidget {
  final VoidCallback onPressed;
  const _BookNowFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,

      child: FloatingActionButton.extended(
        elevation: 6,
        onPressed: onPressed,
        backgroundColor: const Color(0xFF00C2A8),
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        label: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Book Now',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
