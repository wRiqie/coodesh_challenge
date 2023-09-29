import 'package:english_dictionary/app/data/data_sources/word/word_data_source.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/services/http/http_service.dart';

class WordDataSourceApiImp implements WordDataSource {
  final HttpService _httpService;

  WordDataSourceApiImp(this._httpService);

  @override
  Future<WordModel> getInfoByWord(String word) async {
    var response = await _httpService.get('/v2/entries/en/$word');

    return WordModel.fromApi(response);
  }
}
