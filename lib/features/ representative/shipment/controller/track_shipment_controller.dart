import 'package:flutter/material.dart';

class TrackShipmentController extends ChangeNotifier {
  final TextEditingController trackingController = TextEditingController();
  bool isLoading = false;
  bool hasResult = false;
  String trackedNumber = '';

  void search() {
    final query = trackingController.text.trim();
    if (query.isEmpty) return;

    isLoading = true;
    hasResult = false;
    notifyListeners();

    // Simulate network request
    Future.delayed(const Duration(milliseconds: 600), () {
      trackedNumber = query;
      isLoading = false;
      hasResult = true;
      notifyListeners();
    });
  }

  void clear() {
    trackingController.clear();
    hasResult = false;
    trackedNumber = '';
    notifyListeners();
  }

  @override
  void dispose() {
    trackingController.dispose();
    super.dispose();
  }
}