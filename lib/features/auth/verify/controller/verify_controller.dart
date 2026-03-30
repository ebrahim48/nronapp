import 'dart:async';
import 'package:get/get.dart';

class VerifyController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxInt countdown = 60.obs;
  final RxBool isCountingDown = false.obs;

  Timer? _timer;

  void startCountdown() {
    countdown.value = 60;
    isCountingDown.value = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        isCountingDown.value = false;
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
