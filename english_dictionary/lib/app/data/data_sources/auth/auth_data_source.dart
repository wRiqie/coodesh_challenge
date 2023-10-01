import '../../models/register_model.dart';
import '../../models/session_model.dart';

abstract class AuthDataSource {
  Future<SessionModel> signIn(String email, String password);
  Future<SessionModel> signUp(RegisterModel registerInfo);
  Future<void> signOut();
}
