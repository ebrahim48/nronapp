import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanController extends GetxController with WidgetsBindingObserver {
  late final MobileScannerController scannerController;

  final RxBool isFlashOn = false.obs;
  final RxBool hasScanned = false.obs;
  final RxString scannedValue = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!scannerController.value.isInitialized) return;
    switch (state) {
      case AppLifecycleState.resumed:
        scannerController.start();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        scannerController.stop();
        break;
      default:
        break;
    }
  }

  void onDetect(BarcodeCapture capture) {
    if (hasScanned.value) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final String? rawValue = barcodes.first.rawValue;
    if (rawValue == null) return;

    hasScanned.value = true;
    scannedValue.value = rawValue;
    scannerController.stop();
  }

  Future<void> toggleFlash() async {
    await scannerController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  void resetScan() {
    hasScanned.value = false;
    scannedValue.value = '';
    scannerController.start();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scannerController.dispose();
    super.onClose();
  }
}