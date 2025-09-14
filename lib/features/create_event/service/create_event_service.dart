import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:hoodhappen_creator/features/create_event/Model/create_event_model.dart';
import 'package:hoodhappen_creator/utils/constants.dart';
import 'package:http_parser/http_parser.dart';

class CreateEventService {
  static Future<CreateEventModel?> createEvent({
    required String? creatorID,
    required File? eventBanner,
    required String? eventName,
    required String? eventDiscriptioion,
    required int? eventTotalSeat,
    required String? eventLoaction,
    required String? eventMapLocation,
    required String? creatorUpiID,
    required int? ticketPrice,
    required String? contactNumber,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/event/create-event'),
    );

    request.fields['creatorId'] = creatorID!;
    request.fields['eventName'] = eventName!;
    request.fields['eventDescription'] = eventDiscriptioion!;
    request.fields['eventTotalseat'] = eventTotalSeat.toString();
    request.fields['eventLocation'] = eventLoaction!;
    request.fields['eventMapLocation'] = eventMapLocation!;
    request.fields['ticketPrice'] = ticketPrice.toString();
    request.fields['creatorUpiID'] = creatorUpiID.toString();
    request.fields['contactNumber'] = contactNumber!;
    request.fields['startDate'] = startDate!.toIso8601String();
    request.fields['endDate'] = endDate!.toIso8601String();

    request.files.add(
      await http.MultipartFile.fromPath(
        'eventBanner',
        eventBanner!.path,
        contentType: MediaType('image', 'png'),
      ),
    );
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return CreateEventModel.fromJson(data['data']);
    } else {
      throw jsonDecode(response.body)['message'];
    }
  }
}
