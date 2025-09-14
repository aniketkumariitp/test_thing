import 'dart:convert';
import 'package:hoodhappen_creator/features/authentication/model/user_model.dart';
import 'package:hoodhappen_creator/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthService {
  static Future<UserModel?> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final userId = data['user']['id']?.toString() ?? "";
        if (userId.isNotEmpty) {
          await saveFcmToken(userId);
        }

        return UserModel.fromJson(data['user']);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      print("🚀 Login API Call Started"); // Debug

      final response = await http.post(
        Uri.parse('$baseUrl/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("📩 Response Status: ${response.statusCode}");
      print("📩 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Login Response: $data");

        final userId = data['user']['id']?.toString() ?? "";
        if (userId.isNotEmpty) {
          await saveFcmToken(userId);
        }

        return UserModel.fromJson(data['user']);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      print("❌ Login Error: $e");
      rethrow;
    }
  }

  // 🔥 Ye method tum login/register ke baad call karoge
  static Future<void> saveFcmToken(String userId) async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      print("📱 Current FCM Token: $token"); // Debug ke liye add karo

      if (token != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/api/event/save-fcm-token'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"userId": userId, "fcmToken": token}),
        );

        print("📩 Backend Response: ${response.body}");
        print("✅ FCM Token saved successfully");
      }
    } catch (e) {
      print("❌ Error saving FCM Token: $e");
    }
  }
}
