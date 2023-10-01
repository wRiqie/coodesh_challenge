import 'package:english_dictionary/app/data/data_sources/favorite/favorite_data_source.dart';

import '../models/favorite_model.dart';
import '../models/paginable_model.dart';
import '../models/word_model.dart';

class FavoriteRepository {
  final FavoriteDataSource _favoriteDataSource;

  FavoriteRepository(this._favoriteDataSource);

  Future<void> saveFavorite(FavoriteModel favorite) {
    return _favoriteDataSource.saveFavorite(favorite);
  }

  Future<void> deleteFavoriteByWordIdAndUserId(int wordId, String userId) {
    return _favoriteDataSource.deleteFavoriteByWordIdAndUserId(wordId, userId);
  }

  Future<PaginableModel<WordModel>> getFavorites(
      {String query = '', int? limit, int? offset, String userId = ''}) {
    return _favoriteDataSource.getFavorites(query, limit, offset, userId);
  }
}
