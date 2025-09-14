import 'dart:convert';
import 'package:hoodhappen_creator/features/get_event/model/get_event_model.dart';
import 'package:hoodhappen_creator/utils/constants.dart';
import 'package:http/http.dart' as http;

class GetEventService {
  static Future<GetEventModel?> getUser(String id) async {
    try {
      // Get current date-time in UTC ISO8601 format
      final nowUtc = DateTime.now().toUtc().toIso8601String();
      print(nowUtc);

      final response = await http.post(
        Uri.parse('$baseUrl/api/event/all-events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": id,
          "currentDateTime": nowUtc, // send current UTC date-time
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return GetEventModel.fromJson(json);
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
