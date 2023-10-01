import 'package:english_dictionary/app/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';

import '../../core/assets.dart';
import '../../core/helpers/session_helper.dart';
import '../../core/helpers/word_helper.dart';
import '../../data/models/paginable_model.dart';
import '../../data/models/word_model.dart';
import '../../data/repositories/favorite_repository.dart';
import '../widgets/search_field_widget.dart';
import '../widgets/word_tile_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final favoriteRepository = GetIt.I<FavoriteRepository>();
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
    final colorScheme = Theme.of(context).colorScheme;

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
                  hintText: 'Searching for favorites...',
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
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).width * .35,
                                      child: SvgPicture.asset(Assets.empty)),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                        text:
                                            'No words found, try searching for other terms like ',
                                        style: TextStyle(
                                          color: colorScheme.onBackground,
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '"Hello"',
                                            style: TextStyle(
                                                color: colorScheme.primary),
                                          ),
                                          const TextSpan(
                                            text: ' or ',
                                          ),
                                          TextSpan(
                                            text: '"Work"',
                                            style: TextStyle(
                                                color: colorScheme.primary),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                            )
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

    var response = await favoriteRepository.getFavorites(
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
