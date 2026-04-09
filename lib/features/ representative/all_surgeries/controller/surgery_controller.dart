import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../model/surgery_model.dart';

class SurgeryController extends GetxController {

  final searchQuery = ''.obs;


  final allSurgeries = <SurgeryModel>[
    SurgeryModel(
      id: '1',
      patientName: 'Michael Johnson',
      procedureName: 'Knee Replacement',
      facility: 'General Hospital',
      dateTime: 'Oct 24, 2023 • 08:30 AM',
      imageAsset: 'assets/images/surgery.png',
    ),
    SurgeryModel(
      id: '2',
      patientName: 'Michael Johnson',
      procedureName: 'Knee Replacement',
      facility: 'General Hospital',
      dateTime: 'Oct 24, 2023 • 08:30 AM',
      imageAsset: 'assets/images/surgery.png',
    ),
  ].obs;

  List<SurgeryModel> get filteredSurgeries {
    if (searchQuery.value.isEmpty) return allSurgeries;
    final q = searchQuery.value.toLowerCase();
    return allSurgeries
        .where((s) =>
    s.patientName.toLowerCase().contains(q) ||
        s.procedureName.toLowerCase().contains(q) ||
        s.facility.toLowerCase().contains(q))
        .toList();
  }

  // ── Detail data ───────────────────────────────────────────────────────────
  final surgeryDetail = const SurgeryDetailModel(
    patientName: 'John Doe',
    avatarAsset: 'assets/images/profile.jpg',
    physician: 'Dr. Sarah Jenkins',
    ptId: '132135454',
    facility: 'St. Jude Medical Center',
    dateOfSurgery: '27 march, 2026',
    surgeryType: 'General',
    attachments: [
      SurgeryAttachment(fileName: 'Surgery Sheet.pdf', isPdf: true),
      SurgeryAttachment(fileName: 'Medical Report.docx', isPdf: false),
    ],
    materials: [
      SurgeryMaterialGroup(
          category: 'SCREWS',
          detail: 'Pedicle Screw 6.5mm x 45mm QTY (4)'),
      SurgeryMaterialGroup(
          category: 'RODS/CONNECTORS',
          detail: 'Titanium Rod 5.5mm x 100mm QTY (3)'),
      SurgeryMaterialGroup(
          category: 'PLATES',
          detail: 'Pedicle Screw 6.5mm x 45mm QTY (4)'),
      SurgeryMaterialGroup(
          category: 'IMPLANTS', detail: 'PEEK Inter body Cage QTY (2)'),
      SurgeryMaterialGroup(
          category: 'BIOLOGICS',
          detail: 'Pedicle Screw 6.5mm x 45mm QTY (1)'),
    ],
    radiologyImages: [
      RadiologyImage(
          label: 'AP PRE-OP', imageAsset: 'assets/images/radio.png'),
      RadiologyImage(
          label: 'LATERAL PRE-OP', imageAsset: 'assets/images/radio.png'),
      RadiologyImage(
          label: 'AP POST-OP', imageAsset: 'assets/images/radio.png'),
      RadiologyImage(
          label: 'LATERAL POST-OP', imageAsset: 'assets/images/radio.png'),
    ],
  );


  final selectedPhysician = ''.obs;
  final patientIdController = TextEditingController();
  final facilityController = TextEditingController();
  final dateOfSurgery = ''.obs;
  final surgeryTypeController = TextEditingController();
  final screwsController = TextEditingController();
  final platesController = TextEditingController();
  final rodsController = TextEditingController();
  final implantsController = TextEditingController();
  final biologicsController = TextEditingController();
  final caseNotesController = TextEditingController();


  final radiologyPickedImages = <String, String?>{
    'PATIENT STICKER': null,
    'AP PRE': null,
    'AP POST': null,
    'LATERAL PRE': null,
    'LATERAL POST': null,
  }.obs;


  final uploadedDocs = <String>[].obs;

  final physicians = [
    'Dr. Jane Smith',
    'Dr. Sarah Jenkins',
    'Dr. Robert Chen',
    'Dr. Lee',
  ];

  final _picker = ImagePicker();

  Future<void> pickRadiologyImage(String label) async {
    final picked =
    await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      radiologyPickedImages[label] = picked.path;
      radiologyPickedImages.refresh();
    }
  }

  Future<void> pickDocument() async {
    // file_picker integration point
    // Using image picker for demo; replace with file_picker for real docs
    final picked =
    await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      uploadedDocs.add(picked.name);
    }
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (ctx, child) =>
          Theme(data: ThemeData.dark(), child: child!),
    );
    if (picked != null) {
      dateOfSurgery.value =
      '${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

  void saveSurgery() {
    // Save logic here
  }

  @override
  void onClose() {
    patientIdController.dispose();
    facilityController.dispose();
    surgeryTypeController.dispose();
    screwsController.dispose();
    platesController.dispose();
    rodsController.dispose();
    implantsController.dispose();
    biologicsController.dispose();
    caseNotesController.dispose();
    super.onClose();
  }
}