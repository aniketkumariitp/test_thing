import 'package:flutter/material.dart';
import 'package:hoodhappen_creator/features/get_event/model/get_event_model.dart';
import 'package:hoodhappen_creator/features/get_event/service/get_event_service.dart';
import 'package:hoodhappen_creator/utils/helper.dart';

class GetEventProvider extends ChangeNotifier {
  List<Data> _events = [];
  List<Data> get events => _events;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userID = await Helper.getUserID();
      final fetchedUser = await GetEventService.getUser(userID!);
      _events = fetchedUser?.data ?? [];
    } catch (e) {
      debugPrint('Error fetching user: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Internet Issue!!')));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
