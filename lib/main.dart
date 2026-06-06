import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'views/splash/splash_view.dart';

void main() {
  runApp(const HireHubApp());
}

class HireHubApp extends StatelessWidget {
  const HireHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HireHub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const SplashView(),
      getPages: appPages,
    );
  }
}
