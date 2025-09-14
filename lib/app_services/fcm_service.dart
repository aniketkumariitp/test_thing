import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hoodhappen_creator/utils/constants.dart';
import 'package:http/http.dart' as http;

class FcmService {
  static Future<void> saveFcmToken(String userId) async {
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      await http.post(
        Uri.parse("$baseUrl/api/event/save-fcm-token"),
        body: {"userId": userId, "fcmToken": token},
      );
    }
  }
}
