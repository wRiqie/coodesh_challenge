import 'package:english_dictionary/app/routes/app_routes.dart';
import 'package:english_dictionary/app/ui/screens/favorites_screen.dart';
import 'package:english_dictionary/app/ui/screens/history_screen.dart';
import 'package:english_dictionary/app/ui/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../core/helpers/dialog_helper.dart';
import '../../core/helpers/session_helper.dart';
import '../../data/repositories/auth_repository.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final authRepository = GetIt.I<AuthRepository>();
  final sessionHelper = GetIt.I<SessionHelper>();

  var currentIndex = 1;

  List<Widget> pages = [
    const HistoryScreen(),
    const HomeScreen(),
    const FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('English Dictionary'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: colorScheme.surface,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: currentIndex,
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  void signOut() async {
    DialogHelper().showDecisionDialog(
      context,
      title: 'End session',
      content: 'Are you sure you want to end your session?',
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
