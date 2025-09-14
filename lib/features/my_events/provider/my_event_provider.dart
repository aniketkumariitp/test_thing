import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/my_events/model/my_event_model.dart';
import 'package:hoodhappen_creator/features/my_events/service/my_event_service.dart';
import 'package:hoodhappen_creator/utils/helper.dart';

class MyEventProvider extends ChangeNotifier {
  List<CreatedEvent> _events = [];
  List<CreatedEvent> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final id = await Helper.getUserID();
      final fetchedUser = await MyEventService.getEvents(id);
      _events = fetchedUser?.data?.createdEvents ?? [];
    } catch (e) {
      debugPrint('Error fetching events: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Internet Issue!!!')));
    } finally {
      if (Navigator.canPop(context)) {
        Navigator.pop(context); // Close loading dialog safely
      }
      _isLoading = false;
      notifyListeners();
    }
  }
}
