import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:flutter/material.dart';

import '../widgets/empty_placeholder_widget.dart';

class PaginableListWidget extends StatefulWidget {
  final PaginableModel paginable;
  final bool isLoading;
  final Widget Function(dynamic item) itemBuilder;
  final Future Function(bool clear)? loadItems;
  const PaginableListWidget({
    super.key,
    required this.paginable,
    this.loadItems,
    required this.itemBuilder,
    this.isLoading = false,
  });

  @override
  State<PaginableListWidget> createState() => _PaginableListWidgetState();
}

class _PaginableListWidgetState extends State<PaginableListWidget> {
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
          child: widget.paginable.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: () async {
                    if (widget.loadItems != null) widget.loadItems!(true);
                  },
                  child: ListView(
                    controller: scrollController,
                    children: widget.paginable.items
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
    if (widget.paginable.isEnd) return;
    if (!isLoadingMore.value) {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        isLoadingMore.value = true;
        if (widget.loadItems != null) await widget.loadItems!(false);
        isLoadingMore.value = false;
      }
    }
  }
}
