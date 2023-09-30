import 'package:english_dictionary/app/data/data_sources/history/history_data_source.dart';
import 'package:english_dictionary/app/data/services/local_db_service.dart';

class HistoryDataSourceLocalDbImp implements HistoryDataSource {
  final LocalDbService _localDbService;

  HistoryDataSourceLocalDbImp(this._localDbService);

  @override
  Future<void> addHistoryWord(String word) {
    // TODO: implement addHistoryWord
    throw UnimplementedError();
  }

  @override
  Future<void> deleteHistory(String word) {
    // TODO: implement deleteHistory
    throw UnimplementedError();
  }

  @override
  Future<void> deleteHistoryWord(String word) {
    // TODO: implement deleteHistoryWord
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getHistoryWords() {
    // TODO: implement getHistoryWords
    throw UnimplementedError();
  }
}
