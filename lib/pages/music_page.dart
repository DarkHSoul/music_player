import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/buttons/my_floating_button.dart';

import 'package:music_player/pages/mainMenu.dart';

import 'package:music_player/controllers/audio_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  String _getShortName(String fullName) {
    // Split the full name by whitespace
    List<String> words = fullName.split(' ');
    // Take the first 10 words or all if there are less than 10
    int endIndex = words.length < 10 ? words.length : 5;
    // Join the first 10 words back together
    return words.sublist(0, endIndex).join(' ');
  }

  final AudioController audioController = Get.put(AudioController());
  OnAudioQuery _audioQuery = OnAudioQuery();
  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _init() async {
    // Fetch all songs when the MusicPage is initialized
    await audioController.fetchSongs();
    await _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    // Request permission to read and write external storage
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, you can now read and write to external storage
    } else {
      // Permission denied, handle accordingly
      print("Permission denied");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Page"),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: "Music"),
        ],
        onTap: (index) {
          if (index == 1 && Get.currentRoute != '/musicPage') {
            //navigate to music page
            Get.to(() => MusicPage());
          } else if (index == 0 && Get.currentRoute != '/mainMenu') {
            //navigate to deezer page
            Get.to(() => MainMenu());
          }
        },
        // Your BottomNavigationBar items go here
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() => audioController.currentSong.value != null
          ? myFloatButton(audioController: audioController)
          : SizedBox.shrink()),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            audioController.fetchSongs();
            // refresh the UI
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: audioController.allSongs.length,
                  itemBuilder: (context, index) {
                    var song = audioController.allSongs[index];
                    var shortName = _getShortName(song.displayNameWOExt);
                    return ListTile(
                      title: Text(shortName),
                      subtitle: Text(song.artist ?? 'Unknown Artist'),
                      onTap: () {
                        audioController.play(song);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
