import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Mobile Number"),
                onChanged: (value) => controller.mobileNumber.value = value,
              ),
              const SizedBox(height: 16),
              if (controller.isOtpSent.value)
                TextField(
                  decoration: const InputDecoration(labelText: "Enter OTP"),
                  onChanged: (value) => controller.otp.value = value,
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.isOtpSent.value
                    ? controller.verifyOtp
                    : controller.sendOtp,
                child: Text(
                    controller.isOtpSent.value ? "Verify OTP" : "Send OTP"),
              ),
            ],
          ),
        );
      }),
    );
  }
}
