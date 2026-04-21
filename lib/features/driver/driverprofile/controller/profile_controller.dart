import 'package:flutter/material.dart';

import '../model/profile_model.dart';

class ProfileController extends ChangeNotifier {
  DriverProfileModel _profile = const DriverProfileModel(
    name: 'Driver Alex',
    driverId: 'DRV-2847',
    isAvailable: true,
    completedDeliveries: 785,
    successRate: 99.2,
    totalEarnings: 12450,
    avatarInitial: 'A',
  );

  DriverProfileModel get profile => _profile;

  void toggleAvailability(bool value) {
    _profile = _profile.copyWith(isAvailable: value);
    notifyListeners();
  }
}