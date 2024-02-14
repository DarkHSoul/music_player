import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/buttons/deezerAuthButton.dart';
import 'package:music_player/pages/deezerPage.dart';
import 'package:music_player/pages/music_page.dart';
import 'package:music_player/pages/settings.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),

        backgroundColor: Colors.blue,
        actions: [
          IconButton(onPressed: (){
            //use get to navigate
            Get.to(const Settings());
          }, icon: const Icon(Icons.settings))
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            //navigate to music page
            Get.to( const MusicPage());
          }, child: const Text("Music Player")),
          ElevatedButton(onPressed: (){
            //navigate to deezer page
            Get.to(const DeezerPage());
          }, child:const Text("Deezer Page")),
          const DeezerAuthButton(),
         TextButton(onPressed: ()async{
          await Permission.storage.request();
         }, child: const Text("perm"))
        ],
      )

    );
  }
}