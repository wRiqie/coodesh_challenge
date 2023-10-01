import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

import 'app/core/helpers/preferences_helper.dart';
import 'app/core/helpers/session_helper.dart';
import 'app/core/inject.dart';
import 'app_widget.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Inject.init();

  await GetIt.I<PreferencesHelper>().init();
  GetIt.I<SessionHelper>().init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const AppWidget());
}
