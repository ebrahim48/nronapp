import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewSendPoController extends GetxController {
  // Step info
  final RxInt currentStep = 2.obs;
  final RxInt totalSteps = 2.obs;

  // PO details
  final RxString poNumber = 'PO #88234'.obs;
  final RxString poType = 'Emergency'.obs;
  final RxString poStatus = 'Draft'.obs;
  final RxString poTitle = 'Urgent Surgical Supplies'.obs;

  final RxString patientId = '1002120JSC2254S'.obs;
  final RxString facility = 'City Hospital'.obs;
  final RxString facilityEmail = 'example@gmial.com'.obs;
  final RxString surgeon = 'Dr. Michael Lee'.obs;
  final RxString surgeonSpecialty = 'Orthopedic Surgery'.obs;
  final RxString dateOfSurgery = 'Feb 14, 2024'.obs;
  final RxString surgeryTime = '08:30 AM EST'.obs;
  final RxString vendor = 'MedTech Inc.'.obs;
  final RxString vendorEmail = 'example@gmi...'.obs;
  final RxDouble totalAmount = 4250.00.obs;

  // Handwritten PO image
  final RxString handwrittenPoImage = 'assets/images/review.png'.obs;
  final RxString handwrittenPoFileName = 'PO_scan_88234.jpg'.obs;

  // Documents — url field holds the actual S3/remote URL
  final RxList<Map<String, dynamic>> documents = <Map<String, dynamic>>[
    {
      'id': '1',
      'name': 'PO_889_Final.pdf',
      'size': '1.2 MB',
      'date': 'FEB 15',
      'type': 'pdf',
      'url': '',
    },
    {
      'id': '2',
      'name': 'Implant_Serial_Photo.jpg',
      'size': '3.4 MB',
      'date': 'FEB 15',
      'type': 'image',
      'url': '',
    },
  ].obs;

  final RxBool isLoading = false.obs;

  /// Opens a URL in the browser/viewer. Shows a snackbar only on error.
  Future<void> _openUrl(String url) async {
    if (url.isEmpty) {
      _showError('No URL available for this document.');
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri == null) {
      _showError('Invalid URL.');
      return;
    }
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        _showError('Could not open the document.');
      }
    } catch (_) {
      _showError('Could not open the document.');
    }
  }

  void _showError(String message) {
    // Post-frame so the overlay is always ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          message,
          backgroundColor: Colors.red.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  Future<void> saveAndSend() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        Get.snackbar(
          'Success',
          'PO saved and sent to vendor successfully',
          backgroundColor: const Color(0xff00C2CB),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    });
  }

  /// Call this after the PO is created to populate real document URLs from API.
  void setDocumentsFromUrls(List<String> urls) {
    for (int i = 0; i < documents.length && i < urls.length; i++) {
      documents[i] = Map<String, dynamic>.from(documents[i])
        ..['url'] = urls[i];
    }
    documents.refresh();
  }

  void viewHandwrittenPo() {
    final url = handwrittenPoImage.value;
    // If it's a remote URL, open it; otherwise it's a local asset — nothing to launch
    if (url.startsWith('http')) {
      _openUrl(url);
    }
  }

  void viewDocument(Map<String, dynamic> doc) {
    final url = (doc['url'] as String?) ?? '';
    _openUrl(url);
  }

  void addNote() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        Get.snackbar('Note', 'Add note tapped',
            snackPosition: SnackPosition.BOTTOM);
      }
    });
  }
}


