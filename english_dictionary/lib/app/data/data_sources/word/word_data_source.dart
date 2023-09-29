import 'package:english_dictionary/app/data/models/word_model.dart';

abstract class WordDataSource {
  Future<WordModel> getInfoByWord(String word);
}
