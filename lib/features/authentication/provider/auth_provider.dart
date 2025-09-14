import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/authentication/model/user_model.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await AuthService.registerUser(
        name: name,
        email: email,
        password: password,
      );

      _user = user;
      await Helper.storeIdInPref(user);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await AuthService.loginUser(
        email: email,
        password: password,
      );

      _user = user;
      await Helper.storeIdInPref(user);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
