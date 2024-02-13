import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_player/controllers/audio_controller.dart';

class MusicPage extends StatelessWidget {
  final AudioController audioController = Get.put(AudioController());
  Future<void> _showDeletePlaylistDialog() async {
    final context = Get.context!;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () async {
                // Delete the long pressed playlist
                await audioController.deletePlaylist(
                  audioController.allPlaylists[0],
                );
                // Fetch all playlists again to update the list
                audioController.fetchAllPlaylists();
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
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
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              await audioController.fetchAllSongs();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        subtitle: Text(song.artist ?? 'Unknown Artist'),
                        onTap: () {
                          audioController.play(song);
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Playlists',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: audioController.allPlaylists.length,
                    itemBuilder: (context, index) {
                      final playlist = audioController.allPlaylists[index];
                      return ListTile(
                        title: Text(playlist.playlist +
                            " (" +
                            playlist.numOfSongs.toString() +
                            ")"),
                        onLongPress: () {
                          //show an alert dialog to delete the playlist
                          _showDeletePlaylistDialog();
                        },
                        onTap: () {
                          // Handle playlist selection
                          _handlePlaylistSelection(playlist);
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
        child: Icon(Icons.playlist_add),
      ),
    );
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    TextEditingController playlistNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Create Playlist"),
          content: TextField(
            controller: playlistNameController,
            decoration: InputDecoration(labelText: "Enter Playlist Name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String playlistName = playlistNameController.text.trim();
                if (playlistName.isNotEmpty) {
                  // Create the playlist using the entered name
                  await audioController.audioQuery.createPlaylist(playlistName);
                  // Fetch all playlists again to update the list
                  audioController.fetchAllPlaylists();
                  // Close the dialog
                  Navigator.pop(context);
                }
              },
              child: Text("Create"),
            ),
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
