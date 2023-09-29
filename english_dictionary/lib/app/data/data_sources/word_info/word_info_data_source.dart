import 'package:english_dictionary/app/data/models/word_info_model.dart';

abstract class WordInfoDataSource {
  Future<WordInfoModel> getInfoByWord(String word);
}
