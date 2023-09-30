import 'package:flutter/material.dart';

class TitleWrapperWidget extends StatelessWidget {
  final String title;
  final Widget child;
  const TitleWrapperWidget(
      {super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 6,
        ),
        child,
      ],
    );
  }
}
