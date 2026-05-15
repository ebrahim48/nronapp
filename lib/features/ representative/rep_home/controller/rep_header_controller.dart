import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/services/api_service.dart';
import '../../../../core/services/socket_service.dart';

class RepHeaderController extends GetxController {
  final _api = ApiService();

  final name = ''.obs;
  final imageUrl = ''.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Register synchronously so Obx tracks hasUnread from the first build
    if (!Get.isRegistered<SocketService>()) {
      Get.put(SocketService(), permanent: true);
    }
    _fetchProfile();
    _connectSocket();
  }

  Future<void> _connectSocket() async {
    final token = await PrefsHelper.getString('auth_token');
    await SocketService.instance.connect(token);
  }

  Future<void> _fetchProfile() async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      final res = await _api.get(
        ApiConstants.getMyProfile,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final data = (res.data as Map<String, dynamic>?)?['data'];
      if (data is Map<String, dynamic>) {
        name.value = data['name']?.toString() ??
            data['fullName']?.toString() ??
            data['userName']?.toString() ??
            '';
        imageUrl.value = data['profileImage']?.toString() ??
            data['avatar']?.toString() ??
            data['image']?.toString() ??
            '';
      }
    } catch (_) {
      // silently fail — keep empty values
    } finally {
      isLoading.value = false;
    }
  }
}
