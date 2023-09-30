import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_dictionary/app/core/constants.dart';
import 'package:english_dictionary/app/core/helpers/session_helper.dart';
import 'package:english_dictionary/app/data/data_sources/favorite/favorite_data_source.dart';

class FavoriteDataSourceFirebaseImp implements FavoriteDataSource {
  final FirebaseFirestore _firestore;
  final SessionHelper _sessionHelper;

  FavoriteDataSourceFirebaseImp(this._firestore, this._sessionHelper);

  @override
  Future<void> addFavoriteWord(String word) async {
    var user = _sessionHelper.actualSession;
    if (user != null) {
      var documentReference =
          _firestore.collection(Constants.favoritesCollection).doc(user.id);
      var document = await documentReference.get();
      if (!document.exists) document = await _createDoc(user.id!);

      var favorites = List<String>.from(document['words']);
      if (favorites.contains(word)) return;
      favorites.add(word);

      await documentReference.update({'words': favorites});
    }
  }

  @override
  Future<void> deleteFavoriteWord(String word) async {
    var user = _sessionHelper.actualSession;
    if (user != null) {
      var documentReference =
          _firestore.collection(Constants.favoritesCollection).doc(user.id);
      var document = await documentReference.get();
      if (!document.exists) document = await _createDoc(user.id!);
      var favorites = List<String>.from(document['words']);

      favorites.remove(word);

      await documentReference.update({'words': favorites});
    }
  }

  @override
  Future<List<String>> getFavoriteWords() async {
    var user = _sessionHelper.actualSession;
    if (user != null) {
      var documentReference =
          _firestore.collection(Constants.favoritesCollection).doc(user.id);
      var document = await documentReference.get();
      if (!document.exists) document = await _createDoc(user.id!);
      var favorites = List<String>.from(document['words']);
      return favorites;
    }

    return [];
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _createDoc(String doc) async {
    var documentReference =
        _firestore.collection(Constants.favoritesCollection).doc(doc);
    await documentReference.set({});
    await _setWordsField(documentReference);
    return documentReference.get();
  }

  Future<void> _setWordsField(DocumentReference ref) {
    return ref.set({'words': []});
  }
}
