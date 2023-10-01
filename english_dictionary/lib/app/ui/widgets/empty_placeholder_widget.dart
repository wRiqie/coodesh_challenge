import 'package:english_dictionary/app/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/assets.dart';

class EmptyPlaceholderWidget extends StatelessWidget {
  const EmptyPlaceholderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
            height: MediaQuery.of(context).width * .35,
            child: SvgPicture.asset(Assets.empty)),
        const SizedBox(
          height: 16,
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'No words found, try searching for other terms like ',
              style: TextStyle(
                color: colorScheme.onBackground,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              children: [
                TextSpan(
                  text: '"Hello"',
                  style: TextStyle(color: colorScheme.primary),
                ),
                const TextSpan(
                  text: ' or ',
                ),
                TextSpan(
                  text: '"Work"',
                  style: TextStyle(color: colorScheme.primary),
                ),
              ]),
        ),
      ],
    );
  }
}
