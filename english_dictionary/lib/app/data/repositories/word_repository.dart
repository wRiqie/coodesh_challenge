import 'package:english_dictionary/app/data/data_sources/word/word_data_source.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';

class WordRepository {
  final WordDataSource _wordDataSource;

  WordRepository(this._wordDataSource);

  // Future<void> updateWord(WordModel word) {
  //   return _wordDataSource.updateWord(word);
  // }

  Future<PaginableModel<WordModel>> getWords(
      {String query = '',
      int? limit,
      int? offset,
      bool onlyFavorited = false,
      required String userId}) {
    return _wordDataSource.getWords(query, limit, offset, userId);
  }
}
