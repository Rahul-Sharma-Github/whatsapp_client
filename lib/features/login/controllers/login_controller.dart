import 'package:get/get.dart';

class LoginController extends GetxController {
  var mobileNumber = ''.obs;
  var otp = ''.obs;
  var isOtpSent = false.obs;

  void sendOtp() {
    if (mobileNumber.value.isNotEmpty) {
      // Fake OTP sending
      isOtpSent.value = true;
    }
  }

  void verifyOtp() {
    if (otp.value == "123456") {
      Get.offNamed('/home'); // Navigate to the home screen
    } else {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }
}
