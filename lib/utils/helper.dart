import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/authentication/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Helper {
  static String formatDateTime(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final amPm = dateTime.hour >= 12 ? "PM" : "AM";
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}\n$hour:$minute $amPm";
  }

  static String specialDateFormat1(DateTime dateTime) {
    String month = DateFormat('MMM').format(dateTime).toUpperCase();
    String day = dateTime.day.toString().padLeft(2, '0'); // add leading zero
    return "$month $day";
  }

  static String specilaDateFormat2(DateTime dateTime) {
    // Example: SEP 03, 12:00 PM
    return DateFormat('MMM dd, hh:mm a').format(dateTime).toUpperCase();
  }

  static Future<void> storeIdInPref(UserModel? user) async {
    if (user == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userID', user!.id);
  }

  static Future<String?> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    final id = await prefs.getString("userID");
    return id;
  }

  static Future<void> clearOnFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool("isFirstLaunch") ?? true;

    if (isFirstLaunch) {
      await prefs.clear(); // sab data clear
      await prefs.setBool(
        "isFirstLaunch",
        false,
      ); // ab agle launch pe clear na ho
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 1)),
    );
  }

  static Future<void> shareEvent(
    String eventImageUrl,
    String eventName,
    String downloadLink,
  ) async {
    try {
      // Download image to temp folder
      print("Cilick");
      final response = await http.get(Uri.parse(eventImageUrl));
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/event.jpg');
      await file.writeAsBytes(response.bodyBytes);

      // Share image + text
      await Share.shareXFiles(
        [XFile(file.path)],
        text: "🎉 Check out this event!\n\nEvent : $eventName\n$downloadLink",
        subject: "Don't miss this event!",
      );
    } catch (e) {
      print("Error sharing event: $e");
    }
  }
}
