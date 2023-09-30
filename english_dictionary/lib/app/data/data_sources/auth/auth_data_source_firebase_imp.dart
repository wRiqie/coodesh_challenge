import 'package:english_dictionary/app/core/constants.dart';
import 'package:english_dictionary/app/data/data_sources/auth/auth_data_source.dart';
import 'package:english_dictionary/app/data/models/error_model.dart';
import 'package:english_dictionary/app/data/models/session_model.dart';
import 'package:english_dictionary/app/data/models/register_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSourceFirebaseImp implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthDataSourceFirebaseImp(this._firebaseAuth);

  @override
  Future<SessionModel> signIn(String email, String password) async {
    try {
      var response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return SessionModel(
        id: response.user?.uid,
        email: response.user?.email,
        name: response.user?.displayName,
        photoUrl: response.user?.photoURL,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'ERROR_USER_NOT_FOUND') {
        throw ErrorModel('No user found for that email.');
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw ErrorModel('Incorrect email and/or password');
      }
      throw ErrorModel(Constants.defaultError);
    }
  }

  @override
  Future<SessionModel> signUp(RegisterModel registerInfo) async {
    try {
      var response = await _firebaseAuth.createUserWithEmailAndPassword(
        email: registerInfo.email,
        password: registerInfo.password,
      );
      var user = response.user;

      if (user != null) {
        // TODO adicionar foto de usuário

        await user.updateDisplayName(registerInfo.name);

        return SessionModel(
          id: user.uid,
          email: user.email,
          name: user.displayName,
          photoUrl: user.photoURL,
        );
      } else {
        throw ErrorModel(Constants.defaultError);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw ErrorModel('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ErrorModel('The account already exists for that email.');
      }
      throw ErrorModel(Constants.defaultError);
    }
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
