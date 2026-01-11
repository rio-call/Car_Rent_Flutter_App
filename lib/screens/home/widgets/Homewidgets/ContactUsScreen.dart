import 'package:carrental/screens/home/widgets/Homewidgets/formWidget.dart';
import 'package:flutter/material.dart';

class Contactusscreen extends StatelessWidget {
  const Contactusscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF142742),
        title: const Text('Contact Us', style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: const Color(0xFF0B1628),
      body: const ContactFormScreen(),
    );
  }
}
