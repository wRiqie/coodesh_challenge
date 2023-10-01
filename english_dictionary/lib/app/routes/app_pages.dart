import 'package:english_dictionary/app/ui/screens/dashboard_screen.dart';
import 'package:english_dictionary/app/ui/screens/favorites_screen.dart';
import 'package:english_dictionary/app/ui/screens/history_screen.dart';
import 'package:english_dictionary/app/ui/screens/home_screen.dart';
import 'package:english_dictionary/app/ui/screens/signin_screen.dart';
import 'package:english_dictionary/app/ui/screens/signup_screen.dart';
import 'package:english_dictionary/app/ui/screens/splash_screen.dart';
import 'package:english_dictionary/app/ui/screens/word_info_screen.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class AppPages {
  static Map<String, Widget Function(BuildContext context)> values = {
    AppRoutes.splash: (context) => const SplashScreen(),
    AppRoutes.signin: (context) => const SigninScreen(),
    AppRoutes.signup: (context) => const SignupScreen(),
    AppRoutes.dashboard: (context) => const DashboardScreen(),
    AppRoutes.home: (context) => const HomeScreen(),
    AppRoutes.favorites: (context) => const FavoritesScreen(),
    AppRoutes.history: (context) => const HistoryScreen(),
    AppRoutes.wordInfo: (context) => const WordInfoScreen(),
  };
}
