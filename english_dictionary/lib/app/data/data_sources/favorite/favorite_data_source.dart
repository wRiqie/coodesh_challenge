import '../../models/favorite_model.dart';
import '../../models/paginable_model.dart';
import '../../models/word_model.dart';

abstract class FavoriteDataSource {
  Future<void> saveFavorite(FavoriteModel favorite);
  Future<void> deleteFavoriteByWordIdAndUserId(int wordId, String userId);
  Future<PaginableModel<WordModel>> getFavorites(
      String query, int? limit, int? offset, String userId);
}
