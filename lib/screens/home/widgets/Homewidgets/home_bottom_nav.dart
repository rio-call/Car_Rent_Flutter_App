import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeBottomNav extends StatelessWidget {
  final int selectedIndex;
  // Callback when a tab is selected and passes the new index
  final ValueChanged<int> onTabChange;

  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    const surface = Color(0xFF142742);
    const active = Color(0xFF00C2A8);
    const icon = Colors.white;
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 120),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: GNav(
        gap: 8,
        activeColor: active,
        backgroundColor: surface,
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
        duration: Duration(milliseconds: 400),
        color: icon,
        selectedIndex: selectedIndex,
        onTabChange: onTabChange,
        iconSize: 24,
        tabs:  [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.bookmark, text: 'Booked'),
        ],
      ),
    );
  }
}
