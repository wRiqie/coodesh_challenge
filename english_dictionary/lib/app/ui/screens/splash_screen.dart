import 'dart:async';

import 'package:english_dictionary/app/core/helpers/session_helper.dart';
import 'package:english_dictionary/app/routes/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final sessionHelper = GetIt.I<SessionHelper>();

  @override
  void initState() {
    super.initState();
    scheduleMicrotask(() {
      Future.delayed(const Duration(seconds: 2)).then((_) => _handleDone());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(
          Icons.book,
          size: 80,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  void _handleDone() async {
    // checar se usuário está logado
    var actualSession = sessionHelper.actualSession;
    if (actualSession != null) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    } else {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.signin);
      }
    }
  }
}
