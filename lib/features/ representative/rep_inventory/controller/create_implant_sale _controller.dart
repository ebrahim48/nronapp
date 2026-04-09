import 'package:flutter/material.dart';

class RepresentativeModel {
  final String initials;
  final String name;
  final String role; // 'Primary' | 'Assist'
  int commission;

  RepresentativeModel({
    required this.initials,
    required this.name,
    required this.role,
    required this.commission,
  });
}

class CreateImplantSaleController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String saleType = 'Sold'; // 'Sold' | 'Consigned'

  final TextEditingController physicianController = TextEditingController();
  final TextEditingController facilityController = TextEditingController();
  final TextEditingController procedureDateController =
  TextEditingController();
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController poNumberController =
  TextEditingController(text: 'PO-12345');
  final TextEditingController totalBillController = TextEditingController();
  final TextEditingController vendorPaymentController =
  TextEditingController(text: '\$00.0');
  final TextEditingController additionalNotesController =
  TextEditingController();

  List<RepresentativeModel> representatives = [
    RepresentativeModel(
        initials: 'JD', name: 'Jordan Dixon', role: 'Primary', commission: 10),
    RepresentativeModel(
        initials: 'AD', name: 'Asd Dixon', role: 'Assist', commission: 30),
  ];

  List<String> attachments = [
    'Doctor_Sheet_v4_Signed.pdf',
    'Surgical_Report_Jenkins.pdf',
    'Facility_Auth_Letter.docx',
  ];

  bool generatePackingSlip = true;

  void setSaleType(String t) {
    saleType = t;
    notifyListeners();
  }

  void removeRepresentative(int index) {
    representatives.removeAt(index);
    notifyListeners();
  }

  void addRepresentative() {
    representatives.add(RepresentativeModel(
      initials: 'NR',
      name: 'New Rep',
      role: 'Assist',
      commission: 0,
    ));
    notifyListeners();
  }

  int get totalCommission =>
      representatives.fold(0, (sum, r) => sum + r.commission);

  void togglePackingSlip(bool v) {
    generatePackingSlip = v;
    notifyListeners();
  }

  bool createSale() => formKey.currentState?.validate() ?? false;

  @override
  void dispose() {
    physicianController.dispose();
    facilityController.dispose();
    procedureDateController.dispose();
    vendorController.dispose();
    poNumberController.dispose();
    totalBillController.dispose();
    vendorPaymentController.dispose();
    additionalNotesController.dispose();
    super.dispose();
  }
}