import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:flutter/material.dart';

import '../widgets/empty_placeholder_widget.dart';

class WordPaginableWidget extends StatefulWidget {
  final PaginableModel<WordModel> words;
  final bool isLoading;
  final Widget Function(WordModel word) itemBuilder;
  final Future Function(bool clear)? getWords;
  const WordPaginableWidget({
    super.key,
    required this.words,
    this.getWords,
    required this.itemBuilder,
    this.isLoading = false,
  });

  @override
  State<WordPaginableWidget> createState() => _WordPaginableWidgetState();
}

class _WordPaginableWidgetState extends State<WordPaginableWidget> {
  final scrollController = ScrollController();
  final isLoadingMore = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    isLoadingMore.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: widget.words.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    if (widget.getWords != null) widget.getWords!(true);
                  },
                  child: ListView(
                    controller: scrollController,
                    children: widget.words.items
                        .map((e) => widget.itemBuilder(e))
                        .toList(),
                  ),
                )
              : !widget.isLoading
                  ? const Center(child: EmptyPlaceholderWidget())
                  : Container(),
        ),
        ValueListenableBuilder(
          valueListenable: isLoadingMore,
          builder: (context, value, child) {
            return Visibility(
              visible: value,
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }

  void scrollListener() async {
    if (widget.words.isEnd) return;
    if (!isLoadingMore.value) {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        isLoadingMore.value = true;
        if (widget.getWords != null) await widget.getWords!(false);
        isLoadingMore.value = false;
      }
    }
  }
}
