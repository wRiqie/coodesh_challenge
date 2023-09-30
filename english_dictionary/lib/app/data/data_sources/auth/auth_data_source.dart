import 'package:english_dictionary/app/data/models/register_model.dart';
import 'package:english_dictionary/app/data/models/session_model.dart';

abstract class AuthDataSource {
  Future<SessionModel> signin(String email, String password);
  Future<SessionModel> signup(RegisterModel registerInfo);
  Future<void> signout();
}
