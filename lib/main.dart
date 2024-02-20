import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/controllers/theme_controller.dart';
import 'package:music_player/pages/intropage.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    //custom action

    return true;
  });

  await GetStorage.init();
  bool isDark = GetStorage().read('isDark') ?? false;
  ThemeMode initialThemeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  Get.put(ThemeController(initialThemeMode: initialThemeMode));
  AudioController audioController = Get.put(AudioController());
  AssetsAudioPlayer.setupNotificationsOpenAction((notification) {
    audioController.PlayOrPause();
    audioController.seekbackward();
    audioController.seekforward();

    return false;
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: Get.find<ThemeController>().themeMode.value,
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
    );
  }
}
