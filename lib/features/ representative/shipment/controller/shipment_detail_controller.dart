import 'package:get/get.dart';
import '../../../../core/exceptions/app_exceptions.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../data/repositories/shipment_repository.dart';
import '../model/shipment_model.dart';

class ShipmentDetailController extends GetxController {
  final _repo = ShipmentRepository(
    connectivityService: ConnectivityService(),
    apiService: ApiService(),
  );

  final isLoading = true.obs;
  final Rxn<ShipmentModel> shipment = Rxn<ShipmentModel>();

  void loadDetail(String id) {
    if (id.isEmpty) {
      isLoading.value = false;
      return;
    }
    _fetchDetail(id);
  }

  Future<void> _fetchDetail(String id) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _repo.getDetail(token, id);
      final data = res['data'] as Map<String, dynamic>? ?? {};
      shipment.value = ShipmentModel.fromJson(data);
    } catch (e) {
      final msg = e is AppException ? e.message : 'Failed to load shipment details';
      ToastMessageHelper.showErrorMessage(msg);
    } finally {
      isLoading.value = false;
    }
  }
}
