import 'package:get/get.dart';

import '../model/driver_home_model.dart';


class DriverHomeController extends GetxController {
  final driverName = 'Driver Alex'.obs;
  final isOnline = true.obs;
  final showLocationPrompt = false.obs;
  final selectedNavIndex = 0.obs;

  final stats = <DriverStatModel>[
    DriverStatModel(
      iconPath: 'assets/icons/pendingpickups.svg',
      value: '2',
      label: 'Pending Pickups',
    ),
    DriverStatModel(
      iconPath: 'assets/icons/activedeliveries.svg',
      value: '2',
      label: 'Active Deliveries',
    ),
    DriverStatModel(
      iconPath: 'assets/icons/completedtoday.svg',
      value: '2',
      label: 'Completed Today',
    ),
    DriverStatModel(
      iconPath: 'assets/icons/todayearnings.svg',
      value: '\$245',
      label: 'Today Earnings',
    ),
  ].obs;

  final jobRequests = <JobRequestModel>[
    JobRequestModel(
      id: '1',
      shipmentId: 'SH-1847',
      isUrgent: true,
      timeAway: '25 min away',
      pickup: 'City Medical Center',
      dropoff: 'Hope Clinic',
      distanceKm: 4.2,
      earnings: 18,
    ),
    JobRequestModel(
      id: '2',
      shipmentId: 'SH-1848',
      isUrgent: false,
      timeAway: '15 min away',
      pickup: 'General Hospital',
      dropoff: 'St. Jude Clinic',
      distanceKm: 2.8,
      earnings: 12,
    ),
  ].obs;

  final jobDetail = const JobDetailModel(
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
    serviceType: 'FedEx',
    weight: '5 kg',
    dimensions: '12*10*6',
    specialInstructions: 'Temperature controlled items - handle with care',
  );

  int get availableJobs => jobRequests.length;

  void toggleOnlineStatus() {
    isOnline.value = !isOnline.value;
    if (!isOnline.value) {
      showLocationPrompt.value = true;
    }
  }

  void useMyLocation() {
    showLocationPrompt.value = false;
    isOnline.value = true;
  }

  void skipLocation() {
    showLocationPrompt.value = false;
  }

  void acceptJob() {
    Get.snackbar('Accepted', 'Job accepted successfully', snackPosition: SnackPosition.BOTTOM);
  }

  void declineJob() {
    Get.back();
  }

  void onNavTap(int index) {
    selectedNavIndex.value = index;
  }
}