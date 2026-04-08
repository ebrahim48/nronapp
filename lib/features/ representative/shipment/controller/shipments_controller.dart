import 'package:flutter/material.dart';

import '../model/shipment_model.dart';


class ShipmentsController extends ChangeNotifier {
  int selectedTabIndex = 0;
  String searchQuery = '';

  final List<ShipmentModel> allShipments = const [
    ShipmentModel(
      id: '1',
      refNumber: '#JOB-88224',
      title: 'Spinal Kit - Dr. Aris',
      status: 'pending',
      driverName: 'Unassigned',
      driverAssigned: false,
      pickupAddress: 'North Sterilization Center',
      dropAddress: 'General Health Clinic, Surgical Wing',
      pickupDate: 'Oct 25',
      pickupTime: '09:00 AM',
      packageType: 'Medical EXP',
      serviceType: 'FedEx',
      jobId: '#INV-99284',
    ),
    ShipmentModel(
      id: '2',
      refNumber: '#JOB-88224',
      title: 'Spinal Kit - Dr. Aris',
      status: 'pending',
      driverName: 'Unassigned',
      driverAssigned: false,
      pickupAddress: 'North Sterilization Center',
      dropAddress: 'General Health Clinic, Surgical Wing',
      pickupDate: 'Oct 25',
      pickupTime: '09:00 AM',
      packageType: 'Medical EXP',
      serviceType: 'FedEx',
      jobId: '#INV-99285',
    ),
    ShipmentModel(
      id: '3',
      refNumber: '#JOB-88224',
      title: 'Spinal Kit - Dr. Aris',
      status: 'delivered',
      driverName: 'Marcus Thompson',
      driverAssigned: true,
      pickupAddress: 'North Sterilization Center',
      dropAddress: 'General Health Clinic, Surgical Wing',
      pickupDate: 'Oct 25',
      pickupTime: '09:00 AM',
      packageType: 'Medical EXP',
      serviceType: 'FedEx',
      jobId: '#INV-99286',
    ),
    ShipmentModel(
      id: '4',
      refNumber: '#JOB-88225',
      title: 'Spinal Kit - Dr. Aris',
      status: 'in_transit',
      driverName: 'Marcus Thompson',
      driverAssigned: true,
      pickupAddress: 'North Sterilization Center',
      dropAddress: 'General Health Clinic, Surgical Wing',
      pickupDate: 'Oct 25',
      pickupTime: '09:00 AM',
      packageType: 'Medical EXP',
      serviceType: 'FedEx',
      jobId: '#INV-99287',
    ),
  ];

  List<ShipmentModel> get filteredShipments {
    List<ShipmentModel> result = allShipments;
    if (selectedTabIndex == 1) {
      result = result.where((s) => s.status == 'pending').toList();
    } else if (selectedTabIndex == 2) {
      result = result.where((s) => s.status == 'approved').toList();
    } else if (selectedTabIndex == 3) {
      result = result.where((s) => s.status == 'rejected').toList();
    }
    if (searchQuery.isNotEmpty) {
      result = result
          .where((s) =>
      s.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          s.refNumber.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return result;
  }

  List<ShipmentModel> get activeShipments => allShipments
      .where((s) => s.status == 'pending' || s.status == 'in_transit')
      .toList();

  int get activeJobsCount =>
      allShipments.where((s) => s.status != 'delivered').length;
  int get pendingPickupCount =>
      allShipments.where((s) => s.status == 'pending').length;
  int get inTransitCount =>
      allShipments.where((s) => s.status == 'in_transit').length;
  int get deliveredCount =>
      allShipments.where((s) => s.status == 'delivered').length;

  void setTab(int index) {
    selectedTabIndex = index;
    notifyListeners();
  }

  void setSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }
}