import 'package:flutter/material.dart';

class CreateShipmentController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Shipment Information
  final TextEditingController companyController = TextEditingController();
  final TextEditingController jobNameController = TextEditingController();
  final TextEditingController recipientNameController = TextEditingController();

  // Logistics – Pickup
  final TextEditingController pickupAddressController = TextEditingController();
  final TextEditingController pickupCityController = TextEditingController();
  final TextEditingController pickupDateController = TextEditingController();
  final TextEditingController pickupInstructionsController =
  TextEditingController();

  // Logistics – Drop-off
  final TextEditingController dropoffAddressController =
  TextEditingController();
  final TextEditingController dropoffInstructionsController =
  TextEditingController();

  // Package Details
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dimensionsController = TextEditingController();

  String selectedServiceType = 'FedEx';
  String selectedPackageType = 'Medical EXP';
  bool sendCourierOrder = true;
  List<String> uploadedFiles = [];

  final List<String> serviceTypes = ['FedEx', 'UPS', 'DHL', 'USPS'];
  final List<String> packageTypes = [
    'Medical EXP',
    'Standard',
    'Priority',
    'Express'
  ];

  void setServiceType(String value) {
    selectedServiceType = value;
    notifyListeners();
  }

  void setPackageType(String value) {
    selectedPackageType = value;
    notifyListeners();
  }

  void toggleSendCourier(bool value) {
    sendCourierOrder = value;
    notifyListeners();
  }

  void addFile(String fileName) {
    uploadedFiles.add(fileName);
    notifyListeners();
  }

  bool createJob() {
    return formKey.currentState?.validate() ?? false;
  }

  @override
  void dispose() {
    companyController.dispose();
    jobNameController.dispose();
    recipientNameController.dispose();
    pickupAddressController.dispose();
    pickupCityController.dispose();
    pickupDateController.dispose();
    pickupInstructionsController.dispose();
    dropoffAddressController.dispose();
    dropoffInstructionsController.dispose();
    weightController.dispose();
    dimensionsController.dispose();
    super.dispose();
  }
}