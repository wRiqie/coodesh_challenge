class SessionModel {
  final String? id;
  final String? name;
  final String? photoUrl;
  final String? email;

  SessionModel({
    this.id,
    this.name,
    this.photoUrl,
    this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      photoUrl: map['photoUrl'],
    );
  }

  SessionModel copyWith({
    String? id,
    String? name,
    String? photoUrl,
    String? email,
  }) {
    return SessionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
    );
  }
}
