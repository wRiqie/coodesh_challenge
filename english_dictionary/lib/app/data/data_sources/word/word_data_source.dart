import '../../models/paginable_model.dart';
import '../../models/word_model.dart';

abstract class WordDataSource {
  Future<PaginableModel<WordModel>> getWords(
      String query, int? limit, int? offset, String userId);

  Future<void> downloadWords();
}
