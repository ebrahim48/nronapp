import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanController extends GetxController {
  MobileScannerController? _scanner;

  final RxBool isFlashOn = false.obs;
  final RxBool hasScanned = false.obs;
  final RxString scannedValue = ''.obs;

  void attachScanner(MobileScannerController scanner) {
    _scanner = scanner;
  }

  void onDetect(BarcodeCapture capture) {
    if (hasScanned.value) return;
    if (capture.barcodes.isEmpty) return;

    final String? rawValue = capture.barcodes.first.rawValue;
    if (rawValue == null || rawValue.isEmpty) return;

    hasScanned.value = true;
    scannedValue.value = rawValue;
    _scanner?.stop();
  }

  Future<void> toggleFlash() async {
    await _scanner?.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  void resetScan() {
    hasScanned.value = false;
    scannedValue.value = '';
    _scanner?.start();
  }
}
