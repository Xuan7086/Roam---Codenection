abstract final class AppConstants {
  static const String appName = 'Roam';
  static const String tagline = 'Plan better. Travel together.';
  static const String description =
      'An all-in-one travel planner for itineraries, group expenses, '
      'shared places, and trip prep — for solo travellers and groups.';

  static const List<String> travelInterests = [
    'Food',
    'Nature',
    'Shopping',
    'Adventure',
    'Culture',
    'Photography',
    'Beaches',
    'City exploration',
  ];

  static const List<String> travelStyles = [
    'Solo',
    'Couple',
    'Group',
    'Budget',
    'Comfort',
    'Luxury',
  ];

  static const String sampleJoinCode = 'PENANG26';
}

abstract final class MockPlaces {
  static const List<Map<String, String>> featured = [
    {
      'name': 'Chew Jetty',
      'city': 'George Town, Penang',
      'note': 'Clan-jetty boardwalk and a sunset sea view.',
    },
    {
      'name': 'Kek Lok Si Temple',
      'city': 'Air Itam, Penang',
      'note': 'A hilltop temple with city views.',
    },
    {
      'name': 'The Blue Mansion',
      'city': 'George Town, Penang',
      'note': 'A heritage stay and guided-house visit.',
    },
  ];
}
