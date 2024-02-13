import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class AudioController extends GetxController {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
  final OnAudioQuery audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  RxList<SongModel> allSongs = RxList<SongModel>([]);
  Rxn<SongModel> currentSong = Rxn<SongModel>();
  RxInt currentSongIndex = 0.obs;
  RxList<PlaylistModel> allPlaylists = RxList<PlaylistModel>([]);
  RxBool isPlaying = false.obs; // Add this to track playing status

  @override
  void onInit() async {
    super.onInit();
    fetchAllSongs();
    fetchAllPlaylists();
  }

  Future<void> fetchAllSongs() async {
    List<SongModel> songs = await audioQuery.querySongs();
    allSongs.assignAll(songs);
  }

  void fetchAllPlaylists() async {
    List<PlaylistModel> playlists = await audioQuery.queryPlaylists();
    allPlaylists.assignAll(playlists);
  }

  void play(SongModel song) {
    final Audio audio = Audio.file(song.data);
    _assetsAudioPlayer.stop();
    pause();
    _assetsAudioPlayer.open(
      audio,
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      loopMode: LoopMode.playlist,
      // Set the current song to the one being played

      // Update playing status
    );
    currentSong.value = song;
    isPlaying.value = true;
  }

  // Check and request for permission.
  Future<void> checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await audioQuery.permissionsRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    if (_hasPermission) {
      update();
    }
  }

  void pause() {
    _assetsAudioPlayer.pause();
    isPlaying.value = false; // Update playing status
  }

  void disposeAudioPlayer() {
    pause();
    _assetsAudioPlayer.dispose();
  }

  Future<void> deletePlaylist(PlaylistModel playlist) async {
    // Use the OnAudioQuery plugin to delete the playlist
    await audioQuery.removePlaylist(playlist.id);

    // After deleting the playlist, update the list of playlists
    fetchAllPlaylists();
  }
}
