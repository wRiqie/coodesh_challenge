import 'package:english_dictionary/app/core/constants.dart';
import 'package:english_dictionary/app/core/helpers/json_helper.dart';
import 'package:english_dictionary/app/core/helpers/preferences_helper.dart';
import 'package:english_dictionary/app/data/data_sources/word/word_data_source.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/services/local_db_service.dart';

class WordDataSourceLocalDbImp implements WordDataSource {
  final PreferencesHelper _preferencesHelper;
  final LocalDbService _localDbService;

  WordDataSourceLocalDbImp(this._preferencesHelper, this._localDbService);

  @override
  Future<PaginableModel<WordModel>> getWords(int? limit, int? offset) async {
    var alreadySavedWords =
        _preferencesHelper.getBool(Constants.alreadySavedWords);

    if (!alreadySavedWords) await _saveJsonWords();

    return _localDbService.getWords(limit, offset);
  }

  Future<void> _saveJsonWords() async {
    var datas =
        await JsonHelper.instance.getData('assets/json/words_dictionary.json');

    await _localDbService.saveAllWords(List<String>.from(datas));
    await _preferencesHelper.setBool(Constants.alreadySavedWords, true);
  }
}
