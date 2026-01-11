import 'package:carrental/screens/home/widgets/Homewidgets/drawer.dart';
import 'package:flutter/material.dart';
import 'home/widgets/bookedscreen.dart';
import 'package:carrental/screens/home/widgets/HomeStartUp.dart';
import 'package:carrental/screens/home/widgets/Homewidgets/home_bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = const [HomeStartUp(), BookedScreen()];
  int _selectedIndex = 0;

  static const _bg = Color(0xFF0B1628);
  static const _surface = Color(0xFF142742);

  // 0xFF1E293B
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(backgroundColor: _surface, child: const Dr()),
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),

      // body section
      backgroundColor: _bg,
      body: _pages[_selectedIndex],
    );
  }
}
