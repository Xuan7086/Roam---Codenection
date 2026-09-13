import 'package:flutter/material.dart';

import '../features/hub/trip_hub_page.dart';
import '../features/itinerary/itinerary_page.dart';
import '../features/profile/profile_page.dart';
import '../features/studio/studio_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _pages = [
    TripHubPage(),
    ItineraryPage(showBackButton: false),
    StudioPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Hub',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            selectedIcon: Icon(Icons.calendar_today),
            label: 'Itinerary',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_border_rounded),
            selectedIcon: Icon(Icons.star_rounded),
            label: 'Studio',
          ),
          NavigationDestination(
            icon: _ProfileNavAvatar(),
            selectedIcon: _ProfileNavAvatar(selected: true),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ProfileNavAvatar extends StatelessWidget {
  const _ProfileNavAvatar({this.selected = false});

  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
    width: 26,
    height: 26,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: selected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        width: 2,
      ),
      image: const DecorationImage(
        image: AssetImage('assets/images/profile_avatar.jpg'),
        fit: BoxFit.cover,
      ),
    ),
  );
}
