import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/buttons/my_floating_button.dart';

import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/pages/deezerAuthPage.dart';

import 'package:music_player/pages/intropage.dart';
import 'package:music_player/pages/music_page.dart';
import 'package:music_player/pages/settings.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  AudioController audioController = Get.put(AudioController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Music Player"),
          backgroundColor: Colors.blue,
          actions: [
            IconButton(
                onPressed: () {
                  //use get to navigate
                  Get.to(const Settings());
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.music_note), label: "Music"),
          ],
          onTap: (index) {
            if (index == 1 && Get.currentRoute != '/musicPage') {
              //navigate to music page
              Get.to(() => MusicPage());
            }
            //if index is 0 and page is not mainmenu
            else if (index == 0 && Get.currentRoute != '/mainMenu') {
              //navigate to deezer page
              Get.to(() => MainMenu());
            }
          },
          // Your BottomNavigationBar items go here
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Obx(() =>
            audioController.currentSong.value != null
                ? myFloatButton(audioController: audioController)
                : SizedBox.shrink()),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  //navigate to music page
                  Get.to(() => MusicPage());
                },
                child: const Text("Music Player")),
            const DeezerAuthButton(),
            TextButton(
                onPressed: () async {
                  await Permission.storage.request();
                },
                child: const Text("perm")),
            TextButton(
                onPressed: () {
                  Get.to(() => IntroPage());
                },
                child: Text("Intro")),
            TextButton(
                onPressed: () {
                  //request internet permission via permission handler
                },
                child: Text("Request Internet perm")),
          ],
        ));
  }
}
