import 'package:english_dictionary/app/data/models/favorite_model.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';

abstract class FavoriteDataSource {
  Future<void> saveFavorite(FavoriteModel favorite);
  Future<void> deleteFavoriteByWordIdAndUserId(int wordId, String userId);
  Future<PaginableModel<WordModel>> getFavorites(
      String query, int? limit, int? offset, String userId);
}
