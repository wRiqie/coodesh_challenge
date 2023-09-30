import 'package:english_dictionary/app/ui/screens/home_screen.dart';
import 'package:english_dictionary/app/ui/screens/signin_screen.dart';
import 'package:english_dictionary/app/ui/screens/signup_screen.dart';
import 'package:english_dictionary/app/ui/screens/splash_screen.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class AppPages {
  static Map<String, Widget Function(BuildContext context)> values = {
    AppRoutes.splash: (context) => const SplashScreen(),
    AppRoutes.signin: (context) => const SigninScreen(),
    AppRoutes.signup: (context) => const SignupScreen(),
    AppRoutes.home: (context) => const HomeScreen(),
  };
}
