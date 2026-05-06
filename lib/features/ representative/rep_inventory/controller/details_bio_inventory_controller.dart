import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';

class DetailsBioInventoryController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  String bioId = '';

  final name = ''.obs;
  final lotNumber = ''.obs;
  final quantity = ''.obs;
  final vendor = ''.obs;
  final expiryDate = ''.obs;
  final location = ''.obs;
  final status = ''.obs;
  final notes = ''.obs;
  final imageUrl = ''.obs;
  final files = <String>[].obs;

  void loadDetail(String id) {
    if (id.isEmpty) {
      isLoading.value = false;
      return;
    }
    bioId = id;
    _fetchDetail(id);
  }

  Future<void> _fetchDetail(String id) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getBioDetail(token, id);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      name.value = data['itemName']?.toString() ?? '';
      lotNumber.value = data['lotNumber']?.toString() ?? '';
      quantity.value = data['quantity']?.toString() ?? '';
      vendor.value = data['vendor']?.toString() ?? '';
      expiryDate.value = data['expiryDate']?.toString() ?? '';
      location.value = data['location']?.toString() ?? '';
      status.value = data['productStatus']?.toString() ?? '';
      notes.value = data['notes']?.toString() ?? '';
      imageUrl.value = data['initialPhoto']?.toString() ?? '';
      final fileList = data['files'];
      if (fileList is List) {
        files.assignAll(fileList.map((e) => e.toString()));
      }
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load bio inventory details');
    } finally {
      isLoading.value = false;
    }
  }
}
