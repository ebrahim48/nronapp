import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../../core/helpers/prefs_helper.dart';
import '../../../../../core/services/api_service.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../%20representative/rep_inventory/data/repositories/inventory_repository.dart';

class QrScanController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  MobileScannerController? _scanner;

  final RxBool isFlashOn = false.obs;
  final RxBool hasScanned = false.obs;
  final RxString scannedValue = ''.obs;

  final RxBool isLoadingProduct = false.obs;
  final RxString productId = ''.obs;   // DB _id of the matched product
  final RxString productName = ''.obs;
  final RxString productPrice = ''.obs;

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
    _lookupProduct(rawValue);
  }

  Future<void> _lookupProduct(String serial) async {
    isLoadingProduct.value = true;
    productId.value = '';
    productName.value = '';
    productPrice.value = '';
    try {
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getImplants(token, search: serial, limit: 10);
      final raw = res['data'];
      List<dynamic> list = [];
      if (raw is List) {
        list = raw;
      } else if (raw is Map) {
        for (final key in ['results', 'items', 'list', 'data', 'docs']) {
          if (raw[key] is List) {
            list = raw[key] as List;
            break;
          }
        }
      }

      // Prefer exact serialNumber match; fall back to first result
      Map<String, dynamic>? match;
      for (final e in list) {
        if (e is Map<String, dynamic> &&
            e['serialNumber']?.toString() == serial) {
          match = e;
          break;
        }
      }
      if (match == null && list.isNotEmpty && list.first is Map<String, dynamic>) {
        match = list.first as Map<String, dynamic>;
      }

      if (match != null) {
        productId.value = match['_id']?.toString() ?? '';
        productName.value = match['systemType']?.toString() ??
            match['itemName']?.toString() ??
            '';
        final price = match['price'] ?? match['unitPrice'] ?? match['amount'];
        productPrice.value = price != null ? '\$${price.toString()}' : '';
      }
    } catch (_) {
      // Non-fatal — panel still shows; user can still add by serial
    } finally {
      isLoadingProduct.value = false;
    }
  }

  Future<void> toggleFlash() async {
    await _scanner?.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  void resetScan() {
    hasScanned.value = false;
    scannedValue.value = '';
    productId.value = '';
    productName.value = '';
    productPrice.value = '';
    _scanner?.start();
  }
}
