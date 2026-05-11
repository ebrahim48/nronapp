import 'package:get/get.dart';

import '../../../../core/helpers/prefs_helper.dart';
import '../../../../core/helpers/toast_mesage_helper.dart';
import '../data/driver_job_repository.dart';

class NewDeliveryController extends GetxController {
  final _repo = DriverJobRepository();

  final isLoading = false.obs;

  Future<bool> acceptJob(String id) async {
    try {
      isLoading.value = true;
      final token = await PrefsHelper.getString('auth_token');
      await _repo.acceptJob(token, id);
      ToastMessageHelper.showSuccessMessage('Job accepted successfully');
      return true;
    } catch (e) {
      ToastMessageHelper.showErrorMessage(
          e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> declineJob() async {
    return true;
  }
}
