import 'package:english_dictionary/app/core/helpers/session_helper.dart';
import '../../data/models/favorite_model.dart';
import '../../data/models/history_model.dart';
import '../../data/models/word_model.dart';
import '../../data/repositories/favorite_repository.dart';
import '../../data/repositories/history_repository.dart';

class WordHelper {
  final FavoriteRepository _favoriteRepository;
  final SessionHelper _sessionHelper;
  final HistoryRepository _historyRepository;

  WordHelper(
      this._favoriteRepository, this._sessionHelper, this._historyRepository);

  Future<void> toggleFavorite(WordModel word) async {
    if (word.isFavorited) {
      var userId = _sessionHelper.actualSession?.id;
      await _favoriteRepository.deleteFavoriteByWordIdAndUserId(
          word.id, userId ?? '');
    } else {
      final favorite = FavoriteModel(
        userId: _sessionHelper.actualSession?.id,
        wordId: word.id,
      );

      await _favoriteRepository.saveFavorite(favorite);
    }
  }

  Future<void> addToHistory(WordModel word) {
    var userId = _sessionHelper.actualSession?.id;
    var history = HistoryModel(
      wordId: word.id,
      userId: userId ?? '',
      displayDate: DateTime.now(),
    );

    return _historyRepository.addHistoryWord(history);
  }
}
