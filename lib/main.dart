import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/login/screens/login_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),
        // GetPage(name: '/home', page: () => WhatsAppScreen()),
      ],
    );
  }
}
