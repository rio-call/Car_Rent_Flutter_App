import 'package:flutter/material.dart';

class Modelswidget extends StatelessWidget {
  final String name;
  final String imagePath;

  final VoidCallback? onTap;

  const Modelswidget(this.name, this.imagePath, {this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          // tap only on the circle image
          borderRadius: BorderRadius.circular(35),
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF142742),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
