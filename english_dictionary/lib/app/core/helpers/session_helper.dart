import 'dart:convert';

import '../../data/models/session_model.dart';
import '../../data/stores/session_store.dart';
import '../constants.dart';
import 'preferences_helper.dart';

class SessionHelper {
  final PreferencesHelper _preferencesHelper;
  final SessionStore _sessionStore;

  SessionHelper(this._preferencesHelper, this._sessionStore);

  Future<void> init() async {
    final sessionString = _preferencesHelper.getString(Constants.actualSession);
    if (sessionString != null) {
      _sessionStore.actualSession =
          SessionModel.fromMap(jsonDecode(sessionString));
    }
  }

  Future<void> saveSession(SessionModel session,
      {bool rememberMe = false}) async {
    _sessionStore.actualSession = session;
    if (rememberMe) {
      _preferencesHelper.setString(
          Constants.actualSession, jsonEncode(session.toMap()));
    }
  }

  bool get isSignedIn => _sessionStore.actualSession != null;

  SessionModel? get actualSession => _sessionStore.actualSession;

  Future<void> signout() async {
    await _preferencesHelper.remove(Constants.actualSession);
    _sessionStore.actualSession = null;
  }
}
