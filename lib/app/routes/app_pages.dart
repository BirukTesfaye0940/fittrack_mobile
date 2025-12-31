import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/routes/app_routes.dart';
import 'package:fittrack_mobile/app/modules/auth/login_page.dart';
import 'package:fittrack_mobile/app/modules/auth/register_page.dart';
import 'package:fittrack_mobile/app/modules/auth/auth_binding.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterPage(),
      binding: AuthBinding(),
    ),
    // Placeholder for Home until we build it
    GetPage(
      name: Routes.HOME,
      page: () => const Scaffold(body: Center(child: Text("Home Screen"))),
    ),
  ];
}
