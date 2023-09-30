import 'package:english_dictionary/app/data/models/register_model.dart';
import 'package:english_dictionary/app/data/models/session_model.dart';

abstract class AuthDataSource {
  Future<SessionModel> signIn(String email, String password);
  Future<SessionModel> signUp(RegisterModel registerInfo);
  Future<void> signOut();
}
