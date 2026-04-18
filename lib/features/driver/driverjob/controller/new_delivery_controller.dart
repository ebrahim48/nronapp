import 'package:flutter/material.dart';

import '../model/new_delivery_model.dart';

class NewDeliveryController extends ChangeNotifier {
  bool isLoading = false;

  final NewDeliveryModel delivery = const NewDeliveryModel(
    shipmentId: 'SH-1847',
    isUrgent: true,
    earnings: 18,
    distanceKm: 4.2,
    pickupName: 'City Medical Center',
    pickupAddress: '123 Medical Plaza, Downtown',
    pickupContact: 'Dr. Sarah Johnson',
    pickupPhone: '+1 555-0123',
    dropoffName: 'Hope Clinic',
    dropoffAddress: '456 Hope Avenue, Westside',
    dropoffContact: 'Nurse Mike Chen',
    dropoffPhone: '+1 555-0456',
    servicesType: 'FedEx',
    weight: '5 kg',
    dimensions: '12*10*6',
    specialInstructions:
    'Temperature controlled items - handle with care',
  );

  Future<bool> acceptJob() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> declineJob() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    isLoading = false;
    notifyListeners();
    return true;
  }
}