import '../data_sources/word_info/word_info_data_source.dart';
import '../models/default_response_model.dart';
import '../models/word_info_model.dart';
import '../services/execute_service.dart';

class WordInfoRepository {
  final WordInfoDataSource _wordDataSource;

  WordInfoRepository(this._wordDataSource);

  Future<DefaultResponseModel<List<WordInfoModel>>> getInfoByWord(String word) {
    return ExecuteService.tryExecuteAsync(_wordDataSource.getInfosByWord(word));
  }
}
