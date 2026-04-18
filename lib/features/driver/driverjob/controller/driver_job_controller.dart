import 'package:get/get.dart';

import '../model/driver_job_model.dart';


class DriverJobController extends GetxController {
  final selectedTab = DriverJobTab.newJobs.obs;
  final selectedPeriod = CompletedPeriod.today.obs;

  final newJobs = <NewJobModel>[
    NewJobModel(
      shipmentId: 'SH-1847',
      priority: JobPriority.urgent,
      timeAway: '25 min away',
      pickup: 'City Medical Center',
      dropoff: 'Hope Clinic',
      distanceKm: 4.2,
      earnings: 18,
    ),
    NewJobModel(
      shipmentId: 'SH-1848',
      priority: JobPriority.standard,
      timeAway: '35 min away',
      pickup: 'MedSupply Warehouse',
      dropoff: 'East Hospital',
      distanceKm: 6.8,
      earnings: 22,
    ),
    NewJobModel(
      shipmentId: 'SH-1849',
      priority: JobPriority.urgent,
      timeAway: '20 min away',
      pickup: 'Central Clinic',
      dropoff: 'North Medical',
      distanceKm: 3.5,
      earnings: 15,
    ),
  ].obs;

  final activeJobs = <ActiveJobModel>[
    ActiveJobModel(
      shipmentId: 'SH-1845',
      status: ActiveJobStatus.pickedUp,
      from: 'Metro Hospital',
      to: 'Valley Medical',
      eta: '15 min',
      earnings: 28,
    ),
    ActiveJobModel(
      shipmentId: 'SH-1846',
      status: ActiveJobStatus.inTransit,
      from: 'West Clinic',
      to: 'Regional Hospital',
      eta: '22 min',
      earnings: 32,
    ),
  ].obs;

  final completedJobs = <CompletedJobModel>[
    CompletedJobModel(
      shipmentId: 'SH-2845',
      type: 'Implants',
      pickup: 'Main Warehouse',
      dropoff: 'Valley Medical',
      earnings: 42,
      completedAt: '2:45 PM',
    ),
  ].obs;

  final jobDetail = const JobDetailFullModel(
    shipmentId: 'SH-1585',
    title: 'Job Details',
    status: 'Picked Up',
    eta: '15 min',
    shipmentSummaryId: 'SH-1845',
    type: 'Implant',
    priority: JobPriority.urgent,
    pickupLocation: 'Metro Hospital',
    pickupAddress: '789 Medical Drive, Central District',
    pickupContact: 'Dr. Emily Watson',
    pickupPhone: '+1 555-0789',
    pickupDate: '12/12/2026',
    pickupInstructions: 'Use the loading dock at the rear entrance',
    dropoffLocation: 'Valley Medical Center',
    dropoffAddress: '321 Valley Road, South District',
    dropoffFacility: 'abcd',
    dropoffContact: 'Pharmacy Manager',
    dropoffPhone: '+1 555-0321',
    dropoffInstructions: 'Deliver to Pharmacy Department on 2nd floor',
    serviceType: 'FedEx',
    weight: '5 kg',
    dimensions: '12*10*6',
    specialInstructions: 'Temperature controlled items - handle with care',
    attachedFiles: [
      AttachedFile(name: 'Shipment Manifest.pdf', size: '245 KB'),
      AttachedFile(name: 'Delivery Instructions.pdf', size: '180 KB'),
    ],
    deliveryFee: 35.00,
    yourPayout: 28.00,
  );

  void onTabSelected(DriverJobTab tab) => selectedTab.value = tab;
  void onPeriodSelected(CompletedPeriod period) => selectedPeriod.value = period;

  void navigateJob() {
    Get.snackbar('Navigate', 'Opening navigation', snackPosition: SnackPosition.BOTTOM);
  }

  void acceptNewJob() {
    Get.snackbar('Accepted', 'Job accepted successfully', snackPosition: SnackPosition.BOTTOM);
  }

  void declineNewJob() => Get.back();

  int get newJobCount => newJobs.length;
  int get activeJobCount => activeJobs.length;
}