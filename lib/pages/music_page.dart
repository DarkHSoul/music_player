import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:music_player/controllers/audio_controller.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> _requestPermissions() async {
  // Request permission to read and write external storage
  var status = await Permission.storage.request();
  if (status.isGranted) {
    // Permission granted, you can now read and write to external storage
  } else {
    // Permission denied, handle accordingly
  }
}

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  late final OnAudioQuery audioQuery;
  final AudioController audioController = Get.put(AudioController());

  @override
  void initState() {
    super.initState();

    audioQuery = OnAudioQuery();

    _init();
    // Fetch all songs when the MusicPage is initialized
    audioController.fetchLocalAssetSongs();
  }

  Future<void> _init() async {
    final songs = await audioQuery.querySongs();
    setState(() {
      audioController.allSongs.assignAll(songs);
    });
    await _requestPermissions();
    audioController.fetchLocalAssetSongs();
  }

  Future<void> _showDeletePlaylistDialog() async {
    final context = Get.context!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Delete Playlist ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to approve deletion of this playlist?'),
              ],
            ),
          ),
          actions: <Widget>[
            // Add actions here
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Page"),
      ),
      body: Obx(() {
        if (audioController.allSongs.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              // Don't call fetchAllSongs here
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Songs',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: audioController.allSongs.length,
                    itemBuilder: (context, index) {
                      final song = audioController.allSongs[index];
                      return ListTile(
                        title: Text(song.title),
                        subtitle: Text(song.artist ?? 'Ahmet'),
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
        }
      }),
      
    );
  }



}
