import '../data_sources/history/history_data_source.dart';
import '../models/history_model.dart';
import '../models/paginable_model.dart';
import '../models/word_model.dart';

class HistoryRepository {
  final HistoryDataSource _historyDataSource;

  HistoryRepository(this._historyDataSource);

  Future<PaginableModel<WordModel>> getHistoryWords(
      {String query = '', int? limit, int? offset, required String userId}) {
    return _historyDataSource.getHistoryWords(query, limit, offset, userId);
  }

  Future<void> addHistoryWord(HistoryModel history) {
    return _historyDataSource.addHistoryWord(history);
  }

  Future<void> deleteHistoryWord(int wordId, String userId) {
    return _historyDataSource.deleteHistoryWord(wordId, userId);
  }

  Future<void> deleteUserHistory(String userId) {
    return _historyDataSource.deleteUserHistory(userId);
  }
}
