import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hoodhappen_creator/features/create_event/service/create_event_service.dart';
import 'package:hoodhappen_creator/utils/helper.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventProvider extends ChangeNotifier {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  File? get selectedImage => _selectedImage;
  String? _error;
  String? get error => _error;

  Future<void> pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      _selectedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  String? _location;
  String? get location => _location;
  // ✅ Private variable
  String? _mapurl;

  // ✅ Getter
  String? get mapurl => _mapurl;

  // ✅ Setter
  set mapurl(String? value) {
    _mapurl = value;
    notifyListeners();
  }

  Future<void> getLocation(
    BuildContext context,
    TextEditingController controller,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.always &&
            permission != LocationPermission.whileInUse) {
          Navigator.of(context).pop();
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final placemark = placemarks.first;
      print("I am Here");

      _location =
          "${placemark.name}, ${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}";
      _mapurl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
      print(_mapurl);

      // ✅ controller ko sync karo
      controller.text = _location ?? "";

      Navigator.of(context).pop();
      notifyListeners();
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to fetch location"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  DateTime? _startDateTime;
  DateTime? _endDateTime;

  DateTime? get startDateTime => _startDateTime;
  DateTime? get endDateTime => _endDateTime;

  Future<void> pickDateTime({
    required BuildContext context,
    required bool isStart,
  }) async {
    FocusScope.of(context).requestFocus(FocusNode()); // Prevent focus shift

    final DateTime now = DateTime.now();
    final DateTime initial = now;

    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: isStart
          ? initial
          : (_startDateTime ?? initial), // Default fallback
      firstDate: isStart
          ? now // Start date can't be past
          : (_startDateTime ?? now), // End date >= start date
      lastDate: DateTime(2035),
    );

    if (date == null) return;

    TimeOfDay? initialTime = TimeOfDay.now();

    // If selecting end date/time and end date is after start, default to start time
    if (!isStart &&
        _startDateTime != null &&
        date.isAtSameMomentAs(_startDateTime!)) {
      initialTime = TimeOfDay(
        hour: _startDateTime!.hour,
        minute: _startDateTime!.minute,
      );
    }

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (time == null) return;

    // Validate time if start date is today
    if (isStart &&
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      if (time.hour < now.hour ||
          (time.hour == now.hour && time.minute < now.minute)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Time cannot be in the past."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final DateTime selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    if (isStart) {
      _startDateTime = selectedDateTime;

      // Reset endDateTime if invalid
      if (_endDateTime != null && _endDateTime!.isBefore(_startDateTime!)) {
        _endDateTime = null;
      }
    } else {
      // Validation: End cannot be before Start
      if (_startDateTime != null &&
          selectedDateTime.isBefore(_startDateTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("End date/time can't be before Start."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      _endDateTime = selectedDateTime;
    }

    notifyListeners();
  }

  Future<void> addEvent({
    required BuildContext context,
    required String eventName,
    required String eventDiscriptioion,
    required int eventTotalSeat,
    required String
    eventLoaction, // 📍 Human-readable location (e.g. "LPU Unimall")
    required String eventMapLocation, // 📍 Google Maps URL
    required int ticketPrice,
    required String creatorUpiID,
    required String contactNumber,
  }) async {
    _error = null;
    notifyListeners();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final id = await Helper.getUserID();
      if (id == null) throw "User ID not found";
      if (_selectedImage == null) throw "No image selected";
      if (_startDateTime == null || _endDateTime == null) {
        throw "Date/Time not selected";
      }
      if (eventLoaction.isEmpty) throw "Location not selected";
      if (eventMapLocation.isEmpty) throw "Map location not selected";

      final createdEvent = await CreateEventService.createEvent(
        creatorID: id,
        eventBanner: _selectedImage!,
        eventName: eventName,
        eventDiscriptioion: eventDiscriptioion,
        eventTotalSeat: eventTotalSeat,
        eventLoaction:
            eventMapLocation, // 🟢 Use argument instead of `_location`
        eventMapLocation: eventLoaction, // 🟢 Use argument instead of `_mapurl`
        ticketPrice: ticketPrice,
        creatorUpiID: creatorUpiID,
        contactNumber: contactNumber,
        startDate: _startDateTime!,
        endDate: _endDateTime!,
      );

      print("✅✅ Event Created");
      print("Start: $_startDateTime, End: $_endDateTime");

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      context.go("/home");
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Internet Issue"),
            backgroundColor: Colors.red,
          ),
        );
      }
      print("❌ Error: ${e.toString()}");
      _error = e.toString();
    }
    notifyListeners();
  }

  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }
}
