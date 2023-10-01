import '../../data/models/word_info_model.dart';
import 'package:flutter/material.dart';

class MeaningSectionWidget extends StatelessWidget {
  final Meaning meaning;
  const MeaningSectionWidget({super.key, required this.meaning});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            meaning.partOfSpeech ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),
          ...meaning.definitions
              .map((e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      '- ${e.text ?? ''}',
                      style: TextStyle(
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ))
              .toList()
        ],
      ),
    );
  }
}
