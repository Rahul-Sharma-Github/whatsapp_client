import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var mobileNumber = ''.obs;
  var otp = ''.obs;
  var isOtpSent = false.obs;

  void sendOtp() {
    if (mobileNumber.value.isEmpty ||
        mobileNumber.value.length > 10 ||
        mobileNumber.value.length < 10) {
      Get.snackbar(
        'Warning',
        'Provide your 10 Digit Mobile Number',
        backgroundColor: Colors.orange[200],
      );
    } else {
      // Fake OTP sending
      isOtpSent.value = true;
      Get.snackbar(
        'Verify',
        'OTP Sent to your Number',
        backgroundColor: Colors.green[400],
      );
    }
  }

  void verifyOtp() {
    if (otp.value == "123456") {
      Get.offNamed('/home'); // Navigate to the home screen
      Get.snackbar('Success', 'Navigated to Home');
    } else {
      Get.snackbar(
        'Error',
        'Invalid OTP',
        colorText: Colors.white,
        backgroundColor: Colors.orange[900],
      );
    }
  }
}
