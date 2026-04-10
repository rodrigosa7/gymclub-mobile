class UserProfile {
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.preferredWeightUnit,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String preferredWeightUnit;
  final DateTime createdAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      preferredWeightUnit: json['preferredWeightUnit'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
