import 'package:english_dictionary/app/core/helpers/dialog_helper.dart';
import 'package:english_dictionary/app/core/helpers/session_helper.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/repositories/auth_repository.dart';
import 'package:english_dictionary/app/data/repositories/word_repository.dart';
import 'package:english_dictionary/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authRepository = GetIt.I<AuthRepository>();
  final sessionHelper = GetIt.I<SessionHelper>();

  final wordRepository = GetIt.I<WordRepository>();

  final scrollController = ScrollController();

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
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                onPressed: signOut,
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: words.items
                        .map((e) => ListTile(
                              title: Text('${e.id} - ${e.text}'),
                            ))
                        .toList(),
                  ),
                ),
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
    if (words.isEnd()) return;
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

    var response = await wordRepository.getWords(
      limit: 20,
      offset: words.length,
    );
    if (clear) words.clear();
    setState(() {
      words.items.addAll(response.items);
    });
    words.totalItemsCount = response.totalItemsCount;
    isLoading.value = false;
  }

  void signOut() async {
    DialogHelper().showDecisionDialog(
      context,
      title: 'Encerrar sessão',
      content: 'Tem certeza que deseja encerrar sua sessão?',
      onConfirm: () async {
        _clearSession();
        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.signin,
          );
        }
      },
    );
  }

  Future<void> _clearSession() async {
    await authRepository.signOut();
    await sessionHelper.signOut();
  }
}
