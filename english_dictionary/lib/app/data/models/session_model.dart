class SessionModel {
  final String? name;
  final String? photoUrl;
  final String? email;
  final String? accessToken;

  SessionModel({
    this.name,
    this.photoUrl,
    this.email,
    this.accessToken,
  });

  bool get isFirebase => email == null;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'accessToken': accessToken,
      'photoUrl': photoUrl,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      name: map['name'],
      email: map['email'],
      accessToken: map['accessToken'],
      photoUrl: map['photoUrl'],
    );
  }

  SessionModel copyWith({
    String? name,
    String? photoUrl,
    String? email,
    String? accessToken,
    String? refreshToken,
  }) {
    return SessionModel(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}
