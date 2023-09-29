import 'package:english_dictionary/app/data/data_sources/word/word_data_source.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';

class WordRepository {
  final WordDataSource _wordDataSource;

  WordRepository(this._wordDataSource);

  Future<PaginableModel<WordModel>> getWords({int? limit, int? offset}) {
    return _wordDataSource.getWords(limit, offset);
  }
}
