import 'package:flutter/material.dart';

import '../../features/trip/models/trip.dart';
import '../../features/trip/models/user_profile.dart';

/// In-memory session state for the frontend prototype.
/// Swap this later for persistence / API services.
class AppState extends ChangeNotifier {
  static const _prototypeUser = UserProfile(
    name: 'Synthesize',
    email: 'synthesize@roam.local',
  );

  UserProfile? user = _prototypeUser;
  Trip? currentTrip;
  bool isLoggedIn = true;
  EmergencyContact emergencyContact = const EmergencyContact(
    name: 'Aina Rahman',
    relationship: 'Sister',
    phone: '+60 12-668 4210',
  );

  static final Trip sampleTrip = Trip(
    id: 'sample-penang',
    name: 'Penang Heritage Escape',
    destination: 'George Town, Penang',
    startDate: DateTime(2026, 10, 18),
    endDate: DateTime(2026, 10, 23),
    privacy: TripPrivacy.inviteOnly,
    description: 'Hawker food, heritage lanes, and a slow island weekend.',
    budget: 1800,
    travellerCount: 4,
    memberCount: 4,
    progress: 0.42,
    code: 'PENANG26',
  );

  void signUp({required String name, required String email}) {
    user = UserProfile(name: name, email: email);
    isLoggedIn = true;
    notifyListeners();
  }

  void logIn({required String email}) {
    user = UserProfile(
      name: email.split('@').first,
      email: email,
      bio: 'Always packing one extra day.',
      interests: const ['Food', 'Culture', 'Photography'],
    );
    isLoggedIn = true;
    notifyListeners();
  }

  void updateProfile(UserProfile profile) {
    user = profile;
    notifyListeners();
  }

  void updateEmergencyContact(EmergencyContact contact) {
    emergencyContact = contact;
    notifyListeners();
  }

  void startPrototype() {
    user = _prototypeUser;
    isLoggedIn = true;
    notifyListeners();
  }

  void createTrip(Trip trip) {
    currentTrip = trip;
    notifyListeners();
  }

  bool joinTrip(String code) {
    final normalised = code.trim().toUpperCase();
    if (normalised == sampleTrip.code ||
        normalised == 'MELAKA88' ||
        normalised.contains('PENANG')) {
      currentTrip = sampleTrip;
      notifyListeners();
      return true;
    }
    return false;
  }

  void clearTrip() {
    currentTrip = null;
    notifyListeners();
  }

  void logOut() {
    user = null;
    currentTrip = null;
    isLoggedIn = false;
    notifyListeners();
  }
}

class EmergencyContact {
  const EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  final String name;
  final String relationship;
  final String phone;
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
    return scope!.notifier!;
  }
}
