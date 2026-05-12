import 'package:get/get.dart';
import '../../../../core/services/api_service.dart';
import '../data/profile_repository.dart';
import '../model/user_profile_model.dart';

class DriverProfileApiController extends GetxController {
  final _repo = ProfileRepository(apiService: ApiService());

  final isLoading = false.obs;
  final profile = Rxn<UserProfileModel>();
  final error = ''.obs;
  final isAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    error.value = '';
    try {
      final res = await _repo.getMyProfile();
      if (res['success'] == true) {
        profile.value = UserProfileModel.fromJson(
          res['data'] as Map<String, dynamic>,
        );
      }
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void toggleAvailability(bool val) {
    isAvailable.value = val;
  }
}
