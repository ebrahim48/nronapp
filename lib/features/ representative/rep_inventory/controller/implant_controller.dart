import 'package:get/get.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/inventory_repository.dart';
import '../model/implant_model.dart';

class ImplantsController extends GetxController {
  final _repo = InventoryRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  final isDeleting = false.obs;
  final searchQuery = ''.obs;
  final _allImplants = <ImplantModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchImplants();
  }

  Future<void> fetchImplants() async {
    try {
      isLoading.value = true;
      _allImplants.clear();
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getImplants(
        token,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      );
      final list = _asList(res['data']);
      _allImplants.assignAll(list.map((e) => _fromJson(e as Map<String, dynamic>)));
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to load implants');
    } finally {
      isLoading.value = false;
    }
  }

  List<dynamic> _asList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['items', 'list', 'data', 'docs']) {
        if (data[key] is List) return data[key] as List;
      }
    }
    return [];
  }

  ImplantModel _fromJson(Map<String, dynamic> e) {
    final facilityMap = e['facility'] is Map ? e['facility'] as Map<String, dynamic> : <String, dynamic>{};
    final vendorMap = e['vendor'] is Map ? e['vendor'] as Map<String, dynamic> : <String, dynamic>{};
    return ImplantModel(
      id: e['_id']?.toString() ?? '',
      serialNumber: e['serialNumber']?.toString() ?? '',
      name: e['systemType']?.toString() ?? '',
      lotNumber: e['lotNumber']?.toString() ?? '',
      material: e['material']?.toString() ?? '',
      systemType: e['systemType']?.toString() ?? '',
      vendor: vendorMap['vendorName']?.toString() ?? e['vendor']?.toString() ?? '',
      status: _normalizeStatus(e['productStatus']?.toString() ?? e['status']?.toString()),
      facility: facilityMap['facilityName']?.toString() ?? facilityMap['name']?.toString() ?? '',
      recipientEmail: e['recipientEmail']?.toString() ?? '',
    );
  }

  String _normalizeStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'available': return 'available';
      case 'in_stock':
      case 'in stock': return 'in_stock';
      case 'shipped': return 'shipped';
      default: return raw?.toLowerCase() ?? '';
    }
  }

  List<ImplantModel> get filtered {
    final q = searchQuery.value.toLowerCase();
    if (q.isEmpty) return _allImplants;
    return _allImplants.where((i) =>
      i.name.toLowerCase().contains(q) ||
      i.serialNumber.toLowerCase().contains(q) ||
      i.lotNumber.toLowerCase().contains(q),
    ).toList();
  }

  void setSearch(String q) {
    searchQuery.value = q;
    fetchImplants();
  }

  Future<void> deleteImplant(String id) async {
    try {
      isDeleting.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.deleteImplant(token, id);
      _allImplants.removeWhere((i) => i.id == id);
      ToastMessageHelper.showSuccessMessage('Implant deleted');
    } catch (_) {
      ToastMessageHelper.showErrorMessage('Failed to delete implant');
    } finally {
      isDeleting.value = false;
    }
  }
}
