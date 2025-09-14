import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/profile/model/profile_%20model.dart';
import 'package:hoodhappen_creator/features/profile/service/profile_service.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  ProfileModel? _user;
  bool _isLoading = false;
  String userID = "";

  ProfileModel? get user => _user;
  bool get isLoading => _isLoading;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  void setImage(File? image) {
    _selectedImage = image;
    notifyListeners();
  }

  Future<void> fetchUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedID = await Helper.getUserID();

      if (fetchedID == null) {
        throw Exception('User ID not found in SharedPreferences');
      }

      userID = fetchedID;

      final fetchedUser = await ProfileService.getUser(userID: userID);
      _user = fetchedUser;
    } catch (e) {
      debugPrint('Error fetching user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  Future<void> updateUserProfile(String? newName) async {
    if (_user == null) return;

    final trimmedNewName = newName?.trim();
    debugPrint("🔍 Current name: '${_user!.name}'");
    debugPrint("📝 New name: '$trimmedNewName'");

    final bool isNameChanged =
        trimmedNewName != null && trimmedNewName != _user!.name;
    final bool isImageChanged = _selectedImage != null;

    if (!isNameChanged && !isImageChanged) {
      debugPrint("🛑 Nothing to update");
      throw Exception("Nothing to update");
    }

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = await ProfileService.updateUser(
        id: userID,
        name: isNameChanged ? trimmedNewName : null,
        imageFile: _selectedImage,
      );

      debugPrint("✅ Updated name sent: $trimmedNewName");

      _user = updatedUser;
      _selectedImage = null;
    } catch (e) {
      debugPrint("❌ Error updating user: $e");
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}
