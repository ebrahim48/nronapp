import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class ImplantDetailsController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  String _id = '';

  final serialNumber = ''.obs;
  final systemType = ''.obs;
  final vendor = ''.obs;
  final vendorId = ''.obs;
  final status = ''.obs;
  final facilityAddress = ''.obs;
  final facilityId = ''.obs;
  final recipientEmail = ''.obs;
  final imageUrl = ''.obs;
  final additionalNote = ''.obs;
  final brokenNote = ''.obs;
  final inboundFiles = <String>[].obs;
  final brokenFiles = <String>[].obs;

  void loadDetail(String id) {
    if (id.isEmpty) {
      isLoading.value = false;
      return;
    }
    _id = id;
    _fetchDetail(id);
  }

  Future<void> _fetchDetail(String id) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getImplantDetail(token, id);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      final facilityMap = data['facility'] is Map ? data['facility'] as Map<String, dynamic> : <String, dynamic>{};
      final vendorMap = data['vendor'] is Map ? data['vendor'] as Map<String, dynamic> : <String, dynamic>{};

      serialNumber.value = data['serialNumber']?.toString() ?? '';
      systemType.value = data['systemType']?.toString() ?? '';
      vendor.value = vendorMap['vendorName']?.toString() ?? data['vendor']?.toString() ?? '';
      vendorId.value = vendorMap['_id']?.toString() ?? '';
      status.value = _capitalize(data['productStatus']?.toString() ?? data['status']?.toString() ?? '');
      facilityAddress.value = facilityMap['address']?.toString() ?? '';
      facilityId.value = facilityMap['_id']?.toString() ?? '';
      recipientEmail.value = data['recipientEmail']?.toString() ?? '';
      imageUrl.value = data['initialPhoto']?.toString() ?? '';
      additionalNote.value = data['inboundNotes']?.toString() ?? '';
      brokenNote.value = data['brokenInstrumentsNotes']?.toString() ?? '';

      final fileList = data['files'];
      if (fileList is List) {
        inboundFiles.assignAll(fileList
            .where((f) => f is Map && f['category']?.toString() == 'inbound_image')
            .map((f) => (f['url'] ?? f['path'] ?? '').toString())
            .where((s) => s.isNotEmpty));
        brokenFiles.assignAll(fileList
            .where((f) => f is Map && f['category']?.toString() == 'broken_instruments')
            .map((f) => (f['url'] ?? f['path'] ?? '').toString())
            .where((s) => s.isNotEmpty));
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load implant details');
    } finally {
      isLoading.value = false;
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
