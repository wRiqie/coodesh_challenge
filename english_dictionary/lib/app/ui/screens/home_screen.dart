import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/repositories/word_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final wordRepository = GetIt.I<WordRepository>();

  final scrollController = ScrollController();

  final words =
      ValueNotifier<PaginableModel<WordModel>>(PaginableModel.clean());
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
    words.dispose();
    isLoading.dispose();
    loadingMore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
          ),
          body: ValueListenableBuilder(
            valueListenable: words,
            builder: (context, value, child) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: words.value.items
                      .map((e) => ListTile(title: Text('${e.id} - ${e.text}')))
                      .toList(),
                ),
              );
            },
          ),
        ),
        ValueListenableBuilder(
          valueListenable: isLoading,
          builder: (context, value, child) {
            return Visibility(
              visible: value,
              child: Container(
                color: Colors.black38,
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
    if (words.value.isEnd()) return;
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
    if (words.value.length == 0) isLoading.value = true;

    var response = await wordRepository.getWords(
      limit: 20,
      offset: words.value.length,
    );
    if (clear) words.value = PaginableModel.clean();
    words.value.items.addAll(response.items);
    words.value.totalItemsCount = response.totalItemsCount;
    isLoading.value = false;
  }
}
