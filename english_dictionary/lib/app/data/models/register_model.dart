class RegisterModel {
  final String name;
  final String email;
  final String password;
  final String photoUrl;

  RegisterModel(this.name, this.email, this.password, this.photoUrl);

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
    };
  }
}
