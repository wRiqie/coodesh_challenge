import 'package:english_dictionary/app/core/helpers/session_helper.dart';
import 'package:english_dictionary/app/core/helpers/word_helper.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/repositories/word_repository.dart';
import 'package:english_dictionary/app/ui/widgets/empty_placeholder_widget.dart';
import 'package:english_dictionary/app/ui/widgets/search_field_widget.dart';
import 'package:english_dictionary/app/ui/widgets/word_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final wordRepository = GetIt.I<WordRepository>();
  final sessionHelper = GetIt.I<SessionHelper>();
  final wordHelper = GetIt.I<WordHelper>();

  final scrollController = ScrollController();

  final searchCtrl = TextEditingController();

  final words = PaginableModel<WordModel>.clean();
  final isLoading = ValueNotifier<bool>(false);
  final loadingMore = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    getWords(true);
  }

  @override
  void dispose() {
    scrollController.dispose();
    isLoading.dispose();
    loadingMore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
            child: Column(
              children: [
                SearchFieldWidget(
                  controller: searchCtrl,
                  onSearch: () => getWords(true),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: words.isNotEmpty
                      ? RefreshIndicator(
                          onRefresh: () => getWords(true),
                          child: ListView(
                            controller: scrollController,
                            children: words.items.map((e) {
                              return WordTileWidget(
                                word: e,
                                onFavorite: () => onFavorite(e),
                                onView: () => onView(e),
                              );
                            }).toList(),
                          ),
                        )
                      : !isLoading.value
                          ? const Center(child: EmptyPlaceholderWidget())
                          : Container(),
                ),
                ValueListenableBuilder(
                  valueListenable: loadingMore,
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
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, value, child) {
            return Visibility(
              visible: value,
              child: Container(
                color: Colors.black12,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void scrollListener() async {
    if (words.isEnd) return;
    if (!loadingMore.value) {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        loadingMore.value = true;
        await getWords(false);
        loadingMore.value = false;
      }
    }
  }

  Future<void> getWords(bool clear) async {
    if (words.length == 0) isLoading.value = true;
    if (clear) words.clear();

    var response = await wordRepository.getWords(
      query: searchCtrl.text.toLowerCase(),
      limit: 14,
      offset: words.length,
      userId: sessionHelper.actualSession?.id ?? '',
    );
    setState(() {
      words.items.addAll(response.items);
    });
    words.totalItemsCount = response.totalItemsCount;
    isLoading.value = false;
  }

  Future<void> onFavorite(WordModel word) async {
    await wordHelper.toggleFavorite(word);

    setState(() {
      word.isFavorited = !word.isFavorited;
    });
  }

  Future<void> onView(WordModel word) {
    return wordHelper.addToHistory(word);
  }
}
