import 'package:get/get.dart';

import '../model/shipment_model.dart';


class ShipmentController extends GetxController {
  final pendingJobs = 4.obs;
  final drivers = 1.obs;
  final inTransit = 2.obs;
  final delivered = 12.obs;

  final activeShipments = <ShipmentModel>[
    ShipmentModel(
      id: '1',
      title: 'Spinal Kit - Dr. Aris',
      refNumber: 'Ref: #JOB-88224',
      driver: 'Unassigned',
      pickupDate: 'Oct 25, 09:00 AM',
      pickup: 'North Sterilization Center',
      dropAddress: 'General Health Clinic, Surgical Wing',
      status: ShipmentStatus.pending,
    ),
    ShipmentModel(
      id: '2',
      title: 'Spinal Kit - Dr. Aris',
      refNumber: 'Ref: #JOB-88224',
      driver: 'Unassigned',
      pickupDate: 'Oct 25, 09:00 AM',
      pickup: 'North Sterilization Center',
      dropAddress: 'General Health Clinic, Surgical Wing',
      status: ShipmentStatus.inTransit,
    ),
  ].obs;

  final jobReview = const JobReviewModel(
    status: 'In Transit',
    jobId: '#INV-99284',
    packageName: 'Emergency Medical Supplies',
    packageType: 'Package Type',
    pickupDate: 'Oct 24, 2023',
    pickupTime: '09:15 AM',
    pickupLocation: 'St. Jude Medical Research Hub',
    pickupBuilding: 'Building 4, Receiving Dock B, South Entrance',
    pickupNote: 'Required temperature control: -20°C. Handle with extreme care.',
    dropoffEstTime: '11:45 AM',
    dropoffLocation: 'City Central Hospital - Lab Wing',
    dropoffBuilding: 'Main Lab Level 3, Room 302',
    dropoffNote: 'Restricted access area. ID badge required for entry.',
    items: 'Medical Implant (2)',
    weight: '5.2 lbs',
    service: 'Priority Overnight',
  );

  void assignDriver() {
    Get.snackbar('Assign Driver', 'Driver assignment screen', snackPosition: SnackPosition.BOTTOM);
  }

  void sendCourierOrder() {
    Get.snackbar('Sent', 'Courier order sent successfully', snackPosition: SnackPosition.BOTTOM);
  }

  void closeJob() {
    Get.snackbar('Closed', 'Job has been closed', snackPosition: SnackPosition.BOTTOM);
  }
}