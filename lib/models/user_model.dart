class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? provider;
  final DateTime createdAt;
  final DateTime lastLogin;
  final Map<String, dynamic> preferences;

  UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.provider,
    required this.createdAt,
    required this.lastLogin,
    this.preferences = const {},
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      provider: map['provider'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastLogin: (map['lastLogin'] as Timestamp).toDate(),
      preferences: map['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'provider': provider,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? provider,
    DateTime? createdAt,
    DateTime? lastLogin,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      provider: provider ?? this.provider,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      preferences: preferences ?? this.preferences,
    );
  }
}