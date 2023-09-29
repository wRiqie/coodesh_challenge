class AppHelpers {
  AppHelpers._();

  static bool isValidEmail(String? email) {
    if (email == null) {
      return false;
    }

    final regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$');
    return regex.hasMatch(email);
  }
}
