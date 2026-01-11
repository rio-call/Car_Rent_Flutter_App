import 'package:flutter/material.dart';
import 'package:carrental/models/car.dart';
import 'ScreenDetailswidgets/stat_tile.dart';
import 'ScreenDetailswidgets/info_card.dart';
import 'ScreenDetailswidgets/section.dart';
import 'ScreenDetailswidgets/spec_tile.dart';
import 'ScreenDetailswidgets/key_value_row.dart';
import 'ScreenDetailswidgets/car_image_card.dart';

class CarDetailsScreen extends StatelessWidget {
  final Car car;
  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: const Color(0xFF0B1628),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.model,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            car.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF142742),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${car.make} • ${car.year}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Car Image card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CarImageCard(imageAsset: car.imageAsset),
              ),
              const SizedBox(height: 16),
              // Stats cards row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    StatTile(
                      title: 'Rating',
                      value: '${car.rating.toStringAsFixed(1)} ★',
                      subtitle: '${car.reviewCount} reviews',
                      color: Colors.white,
                    ),
                    const SizedBox(width: 12),
                    StatTile(
                      title: 'Price / day',
                      value: '\$${car.pricePerDayUsd}',
                      subtitle: 'Pickup • ${car.locationName}',
                      color: const Color(0xFF00C2A8),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InfoCard(
                  leading: const Icon(
                    Icons.location_city,
                    size: 36,
                    color: Colors.white,
                  ),
                  title: 'Pickup location',
                  subtitle: car.locationName,
                  caption: 'Host • ${car.ownerName}',
                ),
              ),
              const SizedBox(height: 12),
              // Quick specs grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Section(
                  height: 220,
                  title: 'Specifications',

                  child: GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 80,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3.6,
                        ),
                    children: [
                      SpecTile(
                        icon: Icons.flash_on,
                        label: 'Power',
                        value: '${car.horsepower} hp',
                      ),
                      SpecTile(
                        icon: Icons.person,
                        label: 'Seats',
                        value: '${car.seats} persons',
                      ),
                      SpecTile(
                        icon: Icons.speed,
                        label: 'Bags',
                        value: '${car.bags} bags',
                      ),
                      SpecTile(
                        icon: Icons.thermostat,
                        label: 'Transmission',
                        value: car.transmission,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Pricing and ownership
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Section(
                  height: 140,
                  title: 'Rental',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KeyValueRow(label: 'Host', value: car.ownerName),
                      const SizedBox(height: 8),
                      KeyValueRow(label: 'Category', value: car.category),
                      const SizedBox(height: 8),
                      KeyValueRow(label: 'Pickup', value: car.locationName),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),

              // Contact / action
            ],
          ),
        ),
      ),
    );
  }
}
