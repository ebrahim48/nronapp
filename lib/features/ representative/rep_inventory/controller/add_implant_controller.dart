import 'package:flutter/material.dart';

class AddImplantController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController facilityController = TextEditingController();
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController recipientEmailController =
  TextEditingController();
  final TextEditingController serial1Controller = TextEditingController();
  final TextEditingController serial2Controller = TextEditingController();
  final TextEditingController additionalNotesController =
  TextEditingController();
  final TextEditingController brokenNotesController = TextEditingController();

  String? selectedSystemType;
  List<String> inboundImages = [];
  List<String> brokenImages = [];

  final List<String> systemTypes = [
    'Orthopedic System X',
    'Hip System Pro',
    'Spine System',
    'Knee System',
  ];

  void setSystemType(String? v) {
    selectedSystemType = v;
    notifyListeners();
  }

  void addInboundImage(String path) {
    inboundImages.add(path);
    notifyListeners();
  }

  void addBrokenImage(String path) {
    brokenImages.add(path);
    notifyListeners();
  }

  bool save() => formKey.currentState?.validate() ?? false;

  @override
  void dispose() {
    facilityController.dispose();
    vendorController.dispose();
    recipientEmailController.dispose();
    serial1Controller.dispose();
    serial2Controller.dispose();
    additionalNotesController.dispose();
    brokenNotesController.dispose();
    super.dispose();
  }
}