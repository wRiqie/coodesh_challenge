import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:english_dictionary/app/core/snackbar.dart';
import 'package:english_dictionary/app/data/models/word_info_args.dart';
import 'package:english_dictionary/app/data/models/word_info_model.dart';
import 'package:english_dictionary/app/data/repositories/word_info_repository.dart';
import 'package:english_dictionary/app/ui/widgets/meaning_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shimmer/shimmer.dart';

class WordInfoScreen extends StatefulWidget {
  const WordInfoScreen({super.key});

  @override
  State<WordInfoScreen> createState() => _WordInfoScreenState();
}

class _WordInfoScreenState extends State<WordInfoScreen> {
  final wordInfoRepository = GetIt.I<WordInfoRepository>();
  List<WordInfoModel> wordInfos = [];

  int currentInfo = 0;

  final isLoading = ValueNotifier(false);

  bool get isStart => currentInfo == 0;
  bool get isEnd => currentInfo == wordInfos.length - 1;

  final player = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() {
      loadWordInfo();
    });

    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;
    var wordInfo = wordInfos.isNotEmpty ? wordInfos[currentInfo] : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Phonetics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              wordInfos.isNotEmpty
                  ? Container(
                      width: size.width,
                      height: size.height * .4,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          width: 4,
                          color: isPlaying
                              ? colorScheme.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: backToPrevious,
                              child: Icon(
                                Icons.skip_previous,
                                size: 38,
                                color: isStart
                                    ? colorScheme.secondary
                                    : colorScheme.primary,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  wordInfo?.word ?? '',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                Visibility(
                                  visible: wordInfo?.phonetic != null,
                                  child: Text(
                                    wordInfo?.phonetic ?? '',
                                    style: TextStyle(
                                      color: colorScheme.secondary,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: wordInfo?.audioUrl != null
                                      ? () {
                                          playWordAudio();
                                        }
                                      : null,
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: wordInfo?.audioUrl != null
                                          ? colorScheme.primary
                                          : colorScheme.secondary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: goToNext,
                              child: Icon(
                                Icons.skip_next,
                                color: isEnd
                                    ? colorScheme.secondary
                                    : colorScheme.primary,
                                size: 38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Shimmer.fromColors(
                      baseColor: const Color.fromARGB(
                        255,
                        240,
                        240,
                        240,
                      ),
                      highlightColor: const Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      ),
                      child: Container(
                        width: size.width,
                        height: size.height * .4,
                        color: colorScheme.surface,
                      ),
                    ),
              const SizedBox(height: 40),
              Text(
                'Meanings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onBackground,
                ),
              ),
              const SizedBox(height: 12),
              ...(wordInfo?.meanings.map((e) {
                    return MeaningSectionWidget(meaning: e);
                  }).toList() ??
                  [
                    Shimmer.fromColors(
                        baseColor: const Color.fromARGB(
                          255,
                          240,
                          240,
                          240,
                        ),
                        highlightColor: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 20,
                              color: colorScheme.surface,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: size.width,
                              height: 20,
                              color: colorScheme.surface,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: size.width,
                              height: 20,
                              color: colorScheme.surface,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: size.width,
                              height: 20,
                              color: colorScheme.surface,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: size.width,
                              height: 20,
                              color: colorScheme.surface,
                            ),
                          ],
                        )),
                  ])
            ],
          ),
        ),
      ),
    );
  }

  void loadWordInfo() async {
    final args = ModalRoute.of(context)?.settings.arguments as WordInfoArgs;
    final word = args.word;

    isLoading.value = true;
    final response = await wordInfoRepository.getInfoByWord(word.text);
    if (response.isSuccess) {
      if ((response.data ?? []).isEmpty) {
        if (context.mounted) {
          Navigator.of(context).pop();
          ErrorSnackbar(context, message: 'Word not found, try again');
        }
        return;
      }
      setState(() {
        wordInfos = response.data!;
      });
    } else {
      if (context.mounted) {
        Navigator.of(context).pop();
        ErrorSnackbar(context, message: response.error?.message);
      }
    }

    isLoading.value = false;
  }

  void goToNext() {
    stopPlayer();
    if (isEnd) return;
    setState(() {
      currentInfo++;
    });
  }

  void stopPlayer() {
    player.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void backToPrevious() {
    stopPlayer();
    if (isStart) return;
    setState(() {
      currentInfo--;
    });
  }

  void playWordAudio() async {
    if (isPlaying) return;

    var info = wordInfos[currentInfo];
    if (info.audioUrl != null) {
      setState(() {
        isPlaying = true;
      });
      player.play(UrlSource(info.audioUrl!));
    }
  }
}
