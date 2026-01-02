import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/routes/app_routes.dart';
import 'package:fittrack_mobile/app/modules/auth/login_page.dart';
import 'package:fittrack_mobile/app/modules/auth/register_page.dart';
import 'package:fittrack_mobile/app/modules/auth/auth_binding.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_page.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_binding.dart';

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
    GetPage(
      name: Routes.EXERCISES,
      page: () => const ExercisesPage(),
      binding: ExercisesBinding(),
    ),
    // Placeholder for Home until we build it
    GetPage(
      name: Routes.HOME,
      page: () => const Scaffold(body: Center(child: Text("Home Screen"))),
    ),
  ];
}
