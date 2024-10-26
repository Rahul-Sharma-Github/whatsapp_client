import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/home/screens/whatsapp_screen.dart';
import 'features/login/screens/login_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: WhatsAppTheme.primaryColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: WhatsAppTheme.primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          toolbarTextStyle: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ).bodyMedium,
          titleTextStyle: const TextTheme(
            titleLarge: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ).titleLarge,
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: WhatsAppTheme.accentColor),
      ),

      ////////////////
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => LoginScreen()),
        GetPage(name: '/home', page: () => WhatsAppScreen()),
      ],
    );
  }
}
