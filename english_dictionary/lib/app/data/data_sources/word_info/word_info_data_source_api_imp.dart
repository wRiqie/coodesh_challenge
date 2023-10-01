import 'word_info_data_source.dart';
import '../../models/word_info_model.dart';
import '../../services/http/http_service.dart';

class WordInfoDataSourceApiImp implements WordInfoDataSource {
  final HttpService _httpService;

  WordInfoDataSourceApiImp(this._httpService);

  @override
  Future<List<WordInfoModel>> getInfosByWord(String word) async {
    var response = await _httpService.get('/v2/entries/en/$word');

    return List<Map<String, dynamic>>.from(response)
        .map((e) => WordInfoModel.fromApi(e))
        .toList();
  }
}
