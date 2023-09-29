import 'package:english_dictionary/app/data/data_sources/word/word_data_source.dart';
import 'package:english_dictionary/app/data/models/default_response_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/services/execute_service.dart';

class WordRepository {
  final WordDataSource _wordDataSource;

  WordRepository(this._wordDataSource);

  Future<DefaultResponseModel<WordModel>> getInfoByWord(String word) {
    return ExecuteService.tryExecuteAsync(_wordDataSource.getInfoByWord(word));
  }
}
