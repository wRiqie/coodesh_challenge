import 'dart:async';

import 'package:flutter/material.dart';

class SearchFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onSearch;
  const SearchFieldWidget({
    super.key,
    required this.controller,
    this.onSearch,
  });

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  FocusNode searchNode = FocusNode();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    searchNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    searchNode.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller,
      focusNode: searchNode,
      onChanged: (value) {
        timer?.cancel();
        timer = Timer(const Duration(milliseconds: 800), () {
          if (widget.onSearch != null) widget.onSearch!();
        });
      },
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        fillColor: colorScheme.surface,
        // border: OutlineInputBorder(),
        border: const OutlineInputBorder(
          // width: 0.0 produces a thin "hairline" border
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide.none,
        ),
        prefixIcon: const Icon(Icons.search),
        hintText: 'Search for...',
      ),
    );
  }
}
