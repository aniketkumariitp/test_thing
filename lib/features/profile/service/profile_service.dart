import 'dart:convert';
import 'dart:io';

import 'package:hoodhappen_creator/features/profile/model/profile_%20model.dart';
import 'package:hoodhappen_creator/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ProfileService {
  static Future<ProfileModel?> getUser({required String userID}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/getUser'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"id": userID}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProfileModel.fromJson(data['user']);
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
  // Add mime: ^1.0.4 in pubspec.yaml if missing

  static Future<ProfileModel?> updateUser({
    required String id,
    String? name,
    File? imageFile,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/api/update');
      var request = http.MultipartRequest('POST', uri);
      request.fields['id'] = id;

      if (name != null) {
        request.fields['name'] = name;
      }

      if (imageFile != null) {
        final mimeType = lookupMimeType(imageFile.path);
        final multipartFile = await http.MultipartFile.fromPath(
          'profilePic',
          imageFile.path,
          contentType: mimeType != null
              ? MediaType.parse(mimeType)
              : MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("🔴 Raw Response:\n${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProfileModel.fromJson(data['user']);
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
