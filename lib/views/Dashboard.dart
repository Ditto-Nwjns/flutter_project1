import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class SabdaNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const SabdaNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: _NavPalette.navBg, boxShadow: [
        BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.25)),
      ]),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: GNav(
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            duration: const Duration(milliseconds: 300),
            backgroundColor: const Color.fromARGB(255, 1, 0, 30),
            color: _NavPalette.navInactive,
            activeColor: _NavPalette.navActive,
            tabBackgroundColor: const Color.fromARGB(255, 15, 0, 58),
            iconSize: 24,
            tabs: const [
              GButton(icon: Icons.home, text: 'Beranda'),
              GButton(icon: Icons.person, text: 'Profil'),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}

class _NavPalette {
  static const navBg = Color(0xFF0E0E0E);
  static const navTabBg = Color(0xFF1F1F1F);
  static const navActive = Colors.white;
  static const navInactive = Colors.white70;
}