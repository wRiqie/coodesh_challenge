import '../data_sources/word/word_data_source.dart';
import '../models/paginable_model.dart';
import '../models/word_model.dart';

class WordRepository {
  final WordDataSource _wordDataSource;

  WordRepository(this._wordDataSource);

  Future<PaginableModel<WordModel>> getWords(
      {String query = '',
      int? limit,
      int? offset,
      bool onlyFavorited = false,
      required String userId}) {
    return _wordDataSource.getWords(query, limit, offset, userId);
  }

  Future<void> downloadWords() {
    return _wordDataSource.downloadWords();
  }
}
