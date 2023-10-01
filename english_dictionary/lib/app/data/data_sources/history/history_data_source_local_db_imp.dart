import 'package:english_dictionary/app/data/data_sources/history/history_data_source.dart';
import 'package:english_dictionary/app/data/models/history_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/services/local_db_service.dart';

import '../../models/paginable_model.dart';

class HistoryDataSourceLocalDbImp implements HistoryDataSource {
  final LocalDbService _localDbService;

  HistoryDataSourceLocalDbImp(this._localDbService);

  @override
  Future<PaginableModel<WordModel>> getHistoryWords(
      String query, int? limit, int? offset, String userId) {
    return _localDbService.getHistoryWords(query, limit, offset, userId);
  }

  @override
  Future<void> addHistoryWord(HistoryModel history) {
    return _localDbService.saveHistory(history);
  }

  @override
  Future<void> deleteHistoryWord(int wordId, String userId) {
    return _localDbService.deleteHistoryWord(wordId, userId);
  }

  @override
  Future<void> deleteUserHistory(String userId) {
    return _localDbService.deleteUserHistory(userId);
  }
}
