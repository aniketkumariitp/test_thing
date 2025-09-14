import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashProvider extends ChangeNotifier {
  Future<void> handleSplashLogic(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 4));

    if (!context.mounted) return;

    // Ensure router context is ready
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('userID');

    Future.microtask(() {
      if (user != null) {
        context.go('/home');
      } else {
        context.go('/register');
      }
    });
  }
}
