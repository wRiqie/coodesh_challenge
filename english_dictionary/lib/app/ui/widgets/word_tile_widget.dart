import 'package:flutter/material.dart';

class WordTileWidget extends StatelessWidget {
  final String word;
  final VoidCallback? onFavorite;
  final VoidCallback? onDelete;

  const WordTileWidget({
    super.key,
    required this.word,
    this.onFavorite,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
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
          Text(word),
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
                  Icons.favorite_outline,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
