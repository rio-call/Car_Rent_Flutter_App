import 'package:flutter/material.dart';

import 'package:carrental/screens/home/widgets/Homewidgets/Modelswidget.dart';

import 'home_styles.dart';

class HomeCategoriesSection extends StatelessWidget {
  final void Function(String category) onCategorySelected;

  const HomeCategoriesSection({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Categories", style: homeSectionTitleStyle),
        SizedBox(height: 20),
        Container(
          height: 125,
          padding: EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF142742),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF263A60), width: 2.0),
            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 20.2)],
          ),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 15),
              _CategoryItem(
                label: 'Toyota',
                imageAsset: 'assets/images/images.png',
                onTap: () => onCategorySelected('Toyota'),
              ),
              const SizedBox(width: 25),
              _CategoryItem(
                label: 'Mercedes',
                imageAsset: 'assets/images/Mercedes-Logo.svg.png',
                onTap: () => onCategorySelected('Mercedes'),
              ),
              const SizedBox(width: 25),
              _CategoryItem(
                label: 'BMW',
                imageAsset:
                    'assets/images/bmw-car-logo-735811696610457s9siw7ivja.png',
                onTap: () => onCategorySelected('BMW'),
              ),
              const SizedBox(width: 25),
              _CategoryItem(
                label: 'Audi',
                imageAsset: 'assets/images/download.png',
                onTap: () => onCategorySelected('Audi'),
              ),
              const SizedBox(width: 15),
              _CategoryItem(
                label: 'Toyota',
                imageAsset: 'assets/images/images.png',
                onTap: () => onCategorySelected('Toyota'),
              ),
              const SizedBox(width: 25),
              _CategoryItem(
                label: 'Mercedes',
                imageAsset: 'assets/images/Mercedes-Logo.svg.png',
                onTap: () => onCategorySelected('Mercedes'),
              ),
              const SizedBox(width: 25),
              _CategoryItem(
                label: 'BMW',
                imageAsset:
                    'assets/images/bmw-car-logo-735811696610457s9siw7ivja.png',
                onTap: () => onCategorySelected('BMW'),
              ),
              const SizedBox(width: 25),
              _CategoryItem(
                label: 'Audi',
                imageAsset: 'assets/images/download.png',
                onTap: () => onCategorySelected('Audi'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String label;
  final String imageAsset;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.label,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Modelswidget(label, imageAsset, onTap: onTap);
  }
}
