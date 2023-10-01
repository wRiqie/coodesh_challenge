import 'package:english_dictionary/app/core/helpers/json_helper.dart';
import 'package:english_dictionary/app/data/data_sources/word/word_data_source.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/services/local_db_service.dart';

class WordDataSourceLocalDbImp implements WordDataSource {
  final LocalDbService _localDbService;
  final JsonHelper _jsonHelper;

  WordDataSourceLocalDbImp(this._localDbService, this._jsonHelper);

  @override
  Future<PaginableModel<WordModel>> getWords(
      String query, int? limit, int? offset, String userId) async {
    return _localDbService.getWords(query, limit, offset, false, userId);
  }

  @override
  Future<void> downloadWords() async {
    var datas = await _jsonHelper.getData('assets/json/words_dictionary.json');

    await _localDbService.saveAllWords(List<String>.from(datas));
  }
}
