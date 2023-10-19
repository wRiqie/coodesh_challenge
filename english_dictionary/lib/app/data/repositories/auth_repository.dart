import '../data_sources/auth/auth_data_source.dart';
import '../models/default_response_model.dart';
import '../models/register_model.dart';
import '../models/session_model.dart';
import '../services/execute_service.dart';

class AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepository(this._authDataSource);

  Future<DefaultResponseModel<SessionModel>> signIn(
      String email, String password) {
    return ExecuteService.tryExecuteAsync(
        () => _authDataSource.signIn(email, password));
  }

  Future<DefaultResponseModel<SessionModel>> signUp(
      RegisterModel registerInfo) {
    return ExecuteService.tryExecuteAsync(
        () => _authDataSource.signUp(registerInfo));
  }

  Future<void> signOut() {
    return _authDataSource.signOut();
  }
}
