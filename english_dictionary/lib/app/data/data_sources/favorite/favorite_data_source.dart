abstract class FavoriteDataSource {
  Future<List<String>> getFavoriteWords();
  Future<void> addFavoriteWord(String word);
  Future<void> deleteFavoriteWord(String word);
}
