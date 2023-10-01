import 'dart:async';

import 'package:flutter/material.dart';

class SearchFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onSearch;
  const SearchFieldWidget({
    super.key,
    this.controller,
    this.onSearch,
  });

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  bool isNotEmpty = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(searchListener);
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller,
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
        suffixIcon: isNotEmpty
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.controller?.clear();
                  });
                  if (widget.onSearch != null) widget.onSearch!();
                },
                icon: const Icon(Icons.clear),
              )
            : null,
        hintText: 'Search for...',
      ),
    );
  }

  void searchListener() {
    if ((isNotEmpty && (widget.controller?.text.trim().isEmpty ?? false)) ||
        (!isNotEmpty && (widget.controller?.text.trim().isNotEmpty ?? false))) {
      setState(() {
        isNotEmpty = !isNotEmpty;
      });
    }
  }
}
