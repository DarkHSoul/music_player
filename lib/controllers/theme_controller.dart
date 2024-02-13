import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
class ThemeController extends GetxController {
  final box = GetStorage();
  Rx<ThemeMode> themeMode;

  // Constructor with optional initialThemeMode argument
  ThemeController({ThemeMode initialThemeMode = ThemeMode.light}) 
      : themeMode = initialThemeMode.obs;

  bool get isDark => themeMode.value == ThemeMode.dark;
  ThemeData get theme => isDark ? ThemeData.dark() : ThemeData.light();

  void toggleTheme() {
    themeMode.value = isDark ? ThemeMode.light : ThemeMode.dark;
    box.write('isDark', isDark);
    Get.changeThemeMode(themeMode.value);
    update();
  }
}

