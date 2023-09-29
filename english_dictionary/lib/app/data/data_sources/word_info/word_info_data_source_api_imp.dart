import 'package:english_dictionary/app/data/data_sources/word_info/word_info_data_source.dart';
import 'package:english_dictionary/app/data/models/word_info_model.dart';
import 'package:english_dictionary/app/data/services/http/http_service.dart';

class WordInfoDataSourceApiImp implements WordInfoDataSource {
  final HttpService _httpService;

  WordInfoDataSourceApiImp(this._httpService);

  @override
  Future<WordInfoModel> getInfoByWord(String word) async {
    var response = await _httpService.get('/v2/entries/en/$word');

    return WordInfoModel.fromApi(response);
  }
}
