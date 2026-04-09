import 'package:flutter/material.dart';
import '../model/implant_model.dart';

class ReceivingSessionController extends ChangeNotifier {
  // Session meta
  String supplierName = 'MedTech Inc.';
  String sessionStartTime = 'Feb 15, 9:00 AM';
  int expectedTotal = 50;
  int scanned = 27;
  bool isSessionActive = true;
  bool isPaused = false;

  // Stats for empty/filled state
  int get totalItem => scanned;
  int get missing => 0;
  int get lowStockAlert => scanned > 0 ? 85 : 0;

  double get progress => expectedTotal > 0 ? scanned / expectedTotal : 0;
  int get remaining => expectedTotal - scanned;
  String get progressPercent => '${(progress * 100).round()}%';

  // Boxes / received groups
  List<ReceivingBoxModel> boxes = [
    ReceivingBoxModel(
      boxCode: 'Box 4D-HC-02',
      description: 'Knee Prosthesis - Titanium Grade 5',
      itemCount: 5,
      serialRanges: [
        'SN: jtaxy1331hj – jtaxy1342hj',
        'SN: jtaxy1331hj – jtaxy1342hj',
        'SN: jtaxy1331hj – jtaxy1342hj',
        'SN: jtaxy1331hj – jtaxy1342hj',
        'SN: jtaxy1331hj – jtaxy1342hj',
      ],
      isExpanded: true,
    ),
    ReceivingBoxModel(
      boxCode: 'Box 4D-HC-02',
      description: 'Bone Cement - 40g Standard Pack',
      itemCount: 12,
      serialRanges: [
        'SN: jtaxy1331hj – jtaxy1342hj',
      ],
      isExpanded: false,
    ),
    ReceivingBoxModel(
      boxCode: 'Box 4D-HC-02',
      description: 'Knee Prosthesis - Titanium Grade 5',
      itemCount: 5,
      serialRanges: [
        'SN: jtaxy1331hj – jtaxy1342hj',
      ],
      isExpanded: true,
    ),
  ];

  // Most recent 3 scans (Image 3)
  List<ReceivingBoxModel> get recentScans => boxes.take(3).toList();

  DateTime selectedMonth = DateTime(2025, 2);

  void toggleBox(int index) {
    boxes[index].isExpanded = !boxes[index].isExpanded;
    notifyListeners();
  }

  void pauseSession() {
    isPaused = !isPaused;
    notifyListeners();
  }

  void scanItem() {
    // Trigger scanner logic
    notifyListeners();
  }

  void completeSession() {
    isSessionActive = false;
    notifyListeners();
  }
}