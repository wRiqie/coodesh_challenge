import 'package:english_dictionary/app/data/data_sources/word_info/word_info_data_source.dart';
import 'package:english_dictionary/app/data/models/default_response_model.dart';
import 'package:english_dictionary/app/data/models/word_info_model.dart';
import 'package:english_dictionary/app/data/services/execute_service.dart';

class WordInfoRepository {
  final WordInfoDataSource _wordDataSource;

  WordInfoRepository(this._wordDataSource);

  Future<DefaultResponseModel<List<WordInfoModel>>> getInfoByWord(String word) {
    return ExecuteService.tryExecuteAsync(_wordDataSource.getInfosByWord(word));
  }
}
