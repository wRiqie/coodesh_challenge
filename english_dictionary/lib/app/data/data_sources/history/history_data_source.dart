abstract class HistoryDataSource {
  Future<List<String>> getHistoryWords();
  Future<void> addHistoryWord(String word);
  Future<void> deleteHistoryWord(String word);
  Future<void> deleteHistory(String word);
}
