import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/theme_controller.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    // theme controller find
    ThemeController controller = Get.put(ThemeController());
    

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: GetBuilder<ThemeController>(
        builder: (controller) => Column(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              controller.toggleTheme();
              Get.changeThemeMode(controller.themeMode.value);
              Get.changeTheme(controller.theme);
          
            },
            label: const Text("Change Theme"),
            //change the icon to dark if theme is dark , change the icon to light if theme is light
            icon: Icon(controller.isDark ? Icons.dark_mode : Icons.light_mode),
            
          ),
        ],
      ),
    ));
  }
}
