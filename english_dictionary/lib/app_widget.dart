import 'package:english_dictionary/app/core/theme/app_theme.dart';
import 'package:english_dictionary/app/routes/app_pages.dart';
import 'package:english_dictionary/app/routes/app_routes.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Dictionary',
      // theme: appTheme,
      // home: const SplashScreen()
      theme: appTheme,
      routes: AppPages.values,
      initialRoute: AppRoutes.signin,
    );
  }
}
