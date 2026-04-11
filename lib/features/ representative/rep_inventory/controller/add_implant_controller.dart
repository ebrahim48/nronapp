import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImplantController extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController facilityController = TextEditingController();
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController recipientEmailController = TextEditingController();
  final TextEditingController serial1Controller = TextEditingController();
  final TextEditingController serial2Controller = TextEditingController();
  final TextEditingController additionalNotesController = TextEditingController();
  final TextEditingController brokenNotesController = TextEditingController();

  String? selectedSystemType;
  String? selectedSystemSubType;

  List<File> inboundImages = [];
  List<File> brokenImages = [];

  final _picker = ImagePicker();

  final List<String> systemTypes = [
    'Orthopedic System',
    'Hip System',
    'Spine System',
    'Knee System',
  ];

  final List<String> systemSubTypes = [
    'Primary',
    'Revision',
    'Trauma',
    'Total',
  ];

  void setSystemType(String? v) {
    selectedSystemType = v;
    notifyListeners();
  }

  void setSystemSubType(String? v) {
    selectedSystemSubType = v;
    notifyListeners();
  }

  Future<void> pickInboundImage(BuildContext context) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      inboundImages.add(File(picked.path));
      notifyListeners();
    }
  }

  Future<void> pickBrokenImage(BuildContext context) async {
    final source = await _showSourceDialog(context);
    if (source == null) return;
    final picked = await _picker.pickImage(source: source, imageQuality: 80);
    if (picked != null) {
      brokenImages.add(File(picked.path));
      notifyListeners();
    }
  }

  Future<ImageSource?> _showSourceDialog(BuildContext context) {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: const Color(0xFF1E2427),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              title: const Text('Camera', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: Colors.white),
              title: const Text('Gallery', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  void removeInboundImage(int index) {
    inboundImages.removeAt(index);
    notifyListeners();
  }

  void removeBrokenImage(int index) {
    brokenImages.removeAt(index);
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
