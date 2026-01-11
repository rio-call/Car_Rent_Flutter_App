import 'package:flutter/material.dart';

class HomeTopBar extends StatelessWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onContactTap;

  const HomeTopBar({
    super.key,
    required this.onMenuTap,
    required this.onContactTap,
  });

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFE7EEF9);
    const surface = Color(0xFF142742);
    const border = Color(0xFF263A60);
    const muted = Colors.white;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu, size: 34, color: brand),
            splashRadius: 22,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: onContactTap,
            icon: const Icon(
              Icons.contact_mail_outlined,
              size: 28,
              color: brand,
            ),

            padding: const EdgeInsets.all(8),
          ),

          const SizedBox(width: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1, right: 6),
              child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: muted,
                    fontWeight: FontWeight.w700,
                  ),
                  filled: true,
                  fillColor: surface,
                  prefixIcon: const Icon(Icons.search, color: brand),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 3,
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: brand, width: 2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
