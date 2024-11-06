import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller =
      Get.put(LoginController(), permanent: true);

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Obx(() {
        return Container(
          color: Colors.teal[700],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    controller.mobileNumber.value = value;
                    print(controller.mobileNumber.value);
                  },
                ),
                const SizedBox(height: 32),
                if (controller.isOtpSent.value)
                  TextField(
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: "Enter OTP",
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onChanged: (value) => controller.otp.value = value,
                  ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: controller.isOtpSent.value
                      ? controller.verifyOtp
                      : controller.sendOtp,
                  child: Text(
                    controller.isOtpSent.value ? "Verify OTP" : "Send OTP",
                    style: TextStyle(
                      color: Colors.teal[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
