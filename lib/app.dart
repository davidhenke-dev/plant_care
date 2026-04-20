import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glass_liquid_navbar/glass_liquid_navbar.dart';
import 'features/home/presentation/home_screen.dart';
import 'features/plants/presentation/plants_screen.dart';
import 'features/locations/presentation/locations_screen.dart';
import 'package:flutter/material.dart' show Scaffold;

class PlantCareApp extends ConsumerWidget {
  const PlantCareApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CupertinoApp(
      title: 'PlantCare',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF4CAF50),
      ),
      home: MainTabView(),
    );
  }
}

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PlantsScreen(),
    LocationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Wichtig: Content scrollt hinter die NavBar
      body: _screens[_currentIndex],
      bottomNavigationBar: LiquidGlassNavbar(
  currentIndex: _currentIndex,
  onTap: (i) => setState(() => _currentIndex = i),
  theme: MediaQuery.of(context).platformBrightness == Brightness.dark
    ? LiquidGlassTheme.dark().copyWith(
        selectedColor: const Color(0xFF4CAF50),
        indicatorColor: const Color(0x334CAF50),
      )
    : LiquidGlassTheme.light().copyWith(
        selectedColor: const Color(0xFF4CAF50),
        indicatorColor: const Color(0x334CAF50),
      ),
  items: const [
    LiquidNavItem(icon: CupertinoIcons.house_fill, label: 'Home'),
    LiquidNavItem(icon: CupertinoIcons.leaf_arrow_circlepath, label: 'Pflanzen'),
    LiquidNavItem(icon: CupertinoIcons.map_fill, label: 'Standorte'),
  ],
),
    );
  }
}