class SessionModel {
  final String? name;
  final String? photoUrl;
  final String? email;
  final DateTime? expirationDate;

  SessionModel({
    this.name,
    this.photoUrl,
    this.email,
    this.expirationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'expirationDate': expirationDate,
      'photoUrl': photoUrl,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      name: map['name'],
      email: map['email'],
      expirationDate: map['expirationDate'],
      photoUrl: map['photoUrl'],
    );
  }

  SessionModel copyWith({
    String? name,
    String? photoUrl,
    String? email,
    DateTime? expirationDate,
    String? refreshToken,
  }) {
    return SessionModel(
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      expirationDate: expirationDate ?? this.expirationDate,
    );
  }
}
