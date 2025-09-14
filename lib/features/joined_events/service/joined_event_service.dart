import 'dart:convert';
import 'package:hoodhappen_creator/features/joined_events/model/joined_event_model';
import 'package:hoodhappen_creator/utils/constants.dart';
import 'package:http/http.dart' as http;

class JoinedEventService {
  static Future<JoinedEventModel?> getjoinedEvents(String id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/event/all-joined-events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": id}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return JoinedEventModel.fromJson(json);
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
