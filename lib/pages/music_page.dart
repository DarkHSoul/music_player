import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'package:music_player/controllers/audio_controller.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({super.key});

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final AudioController audioController = Get.put(AudioController());

  @override
  void initState() {
    super.initState();
    // Fetch all songs when the MusicPage is initialized
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
                        subtitle: Text(song.artist ?? ''),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePlaylistDialog(context);
        },
        child: const Icon(Icons.playlist_add),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    TextEditingController playlistNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Create Playlist"),
          content: TextField(
            controller: playlistNameController,
            decoration: const InputDecoration(labelText: "Enter Playlist Name"),
          ),
          actions: const [
            // Add actions here
          ],
        );
      },
    );
  }
}

void _handlePlaylistSelection(PlaylistModel playlist) {
  // Debug print to confirm the playlist selection
  print("Selected Playlist: ${playlist.playlist}");

  // Placeholder logic for handling playlist selection
  // Replace this with your actual logic
  // For example, you can navigate to a new screen to display songs in the selected playlist
}
