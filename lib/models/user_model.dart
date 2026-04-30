class UserModel {
  final String name;
  final List<String> skills;
  final String experience;
  final String education;
  final String interests;
  final String language;
  final bool isOnboardingCompleted; // ✅ added

  UserModel({
    required this.name,
    required this.skills,
    required this.experience,
    required this.education,
    required this.interests,
    required this.language,
    this.isOnboardingCompleted = false, // ✅ default value
  });

  // ✅ FROM FIREBASE
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      experience: map['experience'] ?? '',
      education: map['education'] ?? '',
      interests: map['interests'] ?? '',
      language: map['language'] ?? 'en',
      isOnboardingCompleted: map['isOnboardingCompleted'] ?? false, // ✅ important
    );
  }

  // ✅ TO FIREBASE
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "skills": skills,
      "experience": experience,
      "education": education,
      "interests": interests,
      "language": language,
      "isOnboardingCompleted": isOnboardingCompleted, // ✅ important
    };
  }
}