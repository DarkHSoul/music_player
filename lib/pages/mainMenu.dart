import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/pages/music_page.dart';
import 'package:music_player/pages/settings.dart';

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
            Get.to( MusicPage());
          }, child: Text("Music Player"))
          
         
        ],
      )

    );
  }
}