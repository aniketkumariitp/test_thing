import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/joined_events/model/joined_event_model';
import 'package:hoodhappen_creator/features/joined_events/service/joined_event_service.dart';
import 'package:hoodhappen_creator/utils/helper.dart';

class JoinedEventProvider extends ChangeNotifier {
  List<Eventdata> _events = [];
  List<Eventdata> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userID = await Helper.getUserID();
      final fetchedUser = await JoinedEventService.getjoinedEvents(userID!);
      _events = fetchedUser?.eventdata ?? [];
    } catch (e) {
      debugPrint('Error fetching user: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Internet Issue !!!')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
