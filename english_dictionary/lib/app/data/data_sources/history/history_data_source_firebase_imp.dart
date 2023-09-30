import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_dictionary/app/data/data_sources/history/history_data_source.dart';

import '../../../core/constants.dart';
import '../../../core/helpers/session_helper.dart';

class HistoryDataSourceFirebaseImp implements HistoryDataSource {
  final FirebaseFirestore _firestore;
  final SessionHelper _sessionHelper;

  HistoryDataSourceFirebaseImp(this._firestore, this._sessionHelper);

  @override
  Future<void> addHistoryWord(String word) async {
    var user = _sessionHelper.actualSession;
    if (user != null) {
      var documentReference =
          _firestore.collection(Constants.historyCollection).doc(user.id);
      var document = await documentReference.get();
      if (!document.exists) document = await _createDoc(user.id!);

      var favorites = List<String>.from(document['words']);
      if (favorites.contains(word)) return;
      favorites.add(word);

      await documentReference.update({'words': favorites});
    }
  }

  @override
  Future<void> deleteHistory(String word) async {
    var user = _sessionHelper.actualSession;
    if (user != null) {
      var documentReference =
          _firestore.collection(Constants.historyCollection).doc(user.id);
      var document = await documentReference.get();
      if (!document.exists) document = await _createDoc(user.id!);

      await documentReference.update({'words': []});
    }
  }

  @override
  Future<void> deleteHistoryWord(String word) async {
    var user = _sessionHelper.actualSession;
    if (user != null) {
      var documentReference =
          _firestore.collection(Constants.historyCollection).doc(user.id);
      var document = await documentReference.get();
      if (!document.exists) document = await _createDoc(user.id!);
      var favorites = List<String>.from(document['words']);

      favorites.remove(word);

      await documentReference.update({'words': favorites});
    }
  }

  @override
  Future<List<String>> getHistoryWords() async {
    var user = _sessionHelper.actualSession;
    if (user != null) {
      var documentReference =
          _firestore.collection(Constants.historyCollection).doc(user.id);
      var document = await documentReference.get();
      if (!document.exists) document = await _createDoc(user.id!);
      var favorites = List<String>.from(document['words']);
      return favorites;
    }

    return [];
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _createDoc(String doc) async {
    var documentReference =
        _firestore.collection(Constants.historyCollection).doc(doc);
    await documentReference.set({});
    await _setWordsField(documentReference);
    return documentReference.get();
  }

  Future<void> _setWordsField(DocumentReference ref) {
    return ref.set({'words': []});
  }
}
