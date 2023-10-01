import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';

import '../../models/history_model.dart';

abstract class HistoryDataSource {
  Future<PaginableModel<WordModel>> getHistoryWords(
      String query, int? limit, int? offset, String userId);
  Future<void> addHistoryWord(HistoryModel history);
  Future<void> deleteHistoryWord(int wordId, String userId);
  Future<void> deleteUserHistory(String userId);
}
