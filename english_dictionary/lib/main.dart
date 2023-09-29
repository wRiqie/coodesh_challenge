import 'package:english_dictionary/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'app/core/helpers/preferences_helper.dart';
import 'app/core/helpers/session_helper.dart';
import 'app/core/inject.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Inject.init();

  await GetIt.I<PreferencesHelper>().init();
  GetIt.I<SessionHelper>().init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const AppWidget());
}
