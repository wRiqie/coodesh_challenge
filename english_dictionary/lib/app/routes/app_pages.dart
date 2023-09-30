import 'package:english_dictionary/app/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'app_routes.dart';

class AppPages {
  static Map<String, Widget Function(BuildContext context)> values = {
    AppRoutes.home: (context) => const HomeScreen(),
  };
}
