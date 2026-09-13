class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    this.bio = '',
    this.travelStyle = 'Group',
    this.interests = const [],
  });

  final String name;
  final String email;
  final String bio;
  final String travelStyle;
  final List<String> interests;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return 'R';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? bio,
    String? travelStyle,
    List<String>? interests,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      travelStyle: travelStyle ?? this.travelStyle,
      interests: interests ?? this.interests,
    );
  }
}
