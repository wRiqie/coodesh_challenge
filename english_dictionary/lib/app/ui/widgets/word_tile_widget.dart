import 'package:english_dictionary/app/core/snackbar.dart';
import 'package:english_dictionary/app/data/models/word_info_args.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class WordTileWidget extends StatelessWidget {
  final WordModel word;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;
  final Future<void> Function()? onView;

  const WordTileWidget({
    super.key,
    required this.word,
    this.onFavorite,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => viewInfo(context),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 12,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(word.text),
            Row(
              children: [
                Visibility(
                  visible: onDelete != null,
                  child: GestureDetector(
                    onTap: onDelete,
                    child: Icon(
                      Icons.delete,
                      color: colorScheme.secondary,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: onFavorite,
                  child: Icon(
                    word.isFavorited ? Icons.favorite : Icons.favorite_outline,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void viewInfo(BuildContext context) async {
    var checker = InternetConnectionCheckerPlus.createInstance();
    var result = await checker.hasConnection;
    if (result) {
      if (onView != null) await onView!();
      if (context.mounted) {
        Navigator.pushNamed(
          context,
          AppRoutes.wordInfo,
          arguments: WordInfoArgs(word: word),
        );
      }
    } else {
      if (context.mounted) {
        AlertSnackbar(context,
            message:
                'You need to be connected to the internet, check your connection');
      }
    }
  }
}
