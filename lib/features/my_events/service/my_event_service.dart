import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hoodhappen_creator/utils/constants.dart';
import 'package:hoodhappen_creator/features/my_events/model/my_event_model.dart';

class MyEventService {
  static Future<MyEventModel?> getEvents(String? userId) async {
    final url = Uri.parse('$baseUrl/api/event/get-event');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'id': userId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        return MyEventModel.fromJson(decoded);
      } else {
        final errorJson = jsonDecode(response.body);
        throw Exception(errorJson['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      // Optionally log the error
      print('Error fetching events: $e');
      rethrow;
    }
  }

  static Future<String> verifyTicket(String userId, String eventId) async {
    final url = Uri.parse('$baseUrl/api/event/check-ticket');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'userId': userId, 'eventId': eventId}),
      );

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return json['message'] ?? 'Ticket verified successfully.';
      } else {
        throw Exception(json['message'] ?? 'Ticket verification failed.');
      }
    } catch (e) {
      print('Error verifying ticket: $e');
      rethrow;
    }
  }
}
