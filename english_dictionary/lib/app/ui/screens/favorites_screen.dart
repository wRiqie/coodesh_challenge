import 'dart:async';

import 'package:english_dictionary/app/ui/screens/paginable_list_widget.dart';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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

  final searchCtrl = TextEditingController();

  final words = PaginableModel<WordModel>.clean();
  final isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      getWords(true);
    });
  }

  @override
  void dispose() {
    isLoading.dispose();
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
                  hintText: 'Searching for favorites...',
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: PaginableListWidget(
                  paginable: words,
                  itemBuilder: (item) {
                    return WordTileWidget(
                      word: item,
                      onFavorite: () => onFavorite(item),
                      onView: () => onView(item),
                    );
                  },
                  isLoading: isLoading.value,
                  loadItems: getWords,
                )),
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

  Future<void> getWords(bool clear) async {
    if (words.length == 0) isLoading.value = true;
    if (clear) words.clear();

    var response = await favoriteRepository.getFavorites(
      query: searchCtrl.text.toLowerCase(),
      limit: MediaQuery.of(context).size.shortestSide < 600 ? 14 : 20,
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
