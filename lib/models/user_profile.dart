class UserProfile {
  final String uid;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? language;
  final String? themeMode;

  UserProfile({
    required this.uid,
    this.email,
    this.name,
    this.photoUrl,
    this.language,
    this.themeMode,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'name': name,
    'photoUrl': photoUrl,
    'language': language,
    'themeMode': themeMode,
  };

  static UserProfile fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'],
      email: map['email'],
      name: map['name'],
      photoUrl: map['photoUrl'],
      language: map['language'],
      themeMode: map['themeMode'],
    );
  }
}
