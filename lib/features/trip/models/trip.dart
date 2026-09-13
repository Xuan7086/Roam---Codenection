enum TripPrivacy { private, inviteOnly, public }

extension TripPrivacyLabel on TripPrivacy {
  String get label => switch (this) {
    TripPrivacy.private => 'Private',
    TripPrivacy.inviteOnly => 'Invite only',
    TripPrivacy.public => 'Public',
  };

  String get description => switch (this) {
    TripPrivacy.private => 'Only invited members can access this trip.',
    TripPrivacy.inviteOnly => 'Join with an invitation or trip code.',
    TripPrivacy.public => 'Discoverable by other travellers in future updates.',
  };
}

class Trip {
  const Trip({
    required this.id,
    required this.name,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.privacy,
    this.description = '',
    this.budget,
    this.travellerCount = 1,
    this.memberCount = 1,
    this.progress = 0.18,
    this.code = 'ROAM2026',
  });

  final String id;
  final String name;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final TripPrivacy privacy;
  final String description;
  final double? budget;
  final int travellerCount;
  final int memberCount;
  final double progress;
  final String code;

  Trip copyWith({
    String? id,
    String? name,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    TripPrivacy? privacy,
    String? description,
    double? budget,
    int? travellerCount,
    int? memberCount,
    double? progress,
    String? code,
  }) {
    return Trip(
      id: id ?? this.id,
      name: name ?? this.name,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      privacy: privacy ?? this.privacy,
      description: description ?? this.description,
      budget: budget ?? this.budget,
      travellerCount: travellerCount ?? this.travellerCount,
      memberCount: memberCount ?? this.memberCount,
      progress: progress ?? this.progress,
      code: code ?? this.code,
    );
  }
}
