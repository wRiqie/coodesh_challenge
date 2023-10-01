import 'dart:async';

import '../../core/constants.dart';
import '../../data/repositories/word_repository.dart';
import '../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/helpers/preferences_helper.dart';

class PrepareScreen extends StatefulWidget {
  const PrepareScreen({super.key});

  @override
  State<PrepareScreen> createState() => _PrepareScreenState();
}

class _PrepareScreenState extends State<PrepareScreen> {
  final wordRepository = GetIt.I<WordRepository>();
  final preferencesHelper = GetIt.I<PreferencesHelper>();

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      _handleContinue();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'Please wait\nWe are preparing the app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircularProgressIndicator(),
              Text(
                'In seconds you\'ll be able to take advantage of all the amazing features',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContinue() async {
    await wordRepository.downloadWords();
    await preferencesHelper.setBool(Constants.alreadySavedWords, true);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    }
  }
}
