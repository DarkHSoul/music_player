import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:on_audio_query/on_audio_query.dart';

class AudioController extends GetxController {
  final AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();

  final OnAudioQuery _audioQuery = OnAudioQuery();
  RxList<SongModel> allSongs = RxList<SongModel>([]);
  Rxn<SongModel> currentSong = Rxn<SongModel>();
  RxBool isPlaying = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Fetch songs from both assets and device storage when the AudioController is initialized
    fetchSongs();
  }

  bool _isSongsFetched = false;
  Future<void> fetchSongs() async {
    print("Clearing the old songs...");
    allSongs.clear();
    print("Fetching new songs...");
    // Fetch songs from local assets
    List<SongModel> assetsSongs = await _audioQuery.querySongs();
    print("Fetched songs data : ${assetsSongs}");
    if (assetsSongs.isNotEmpty) {
      allSongs.addAll(assetsSongs);
      print("Assets songs fetched: ${assetsSongs.length}");
    }

    _isSongsFetched = true;
  }

  Future<void> play(SongModel song) async {
    // Extract the necessary details from the song model
    final String title = song.title;
    final String? artist = song.artist;
    final String? album = song.album;
    final String data = song.data;

    // Create an Audio instance using the data path
    final Audio audio = Audio.file(data,
        metas: Metas(
          title: title,
          artist: artist,
          album: album,
        ));

    // Stop any current playback
    _assetsAudioPlayer.stop();

    // Open the new audio file for playback
    _assetsAudioPlayer.open(
      audio,
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      loopMode: LoopMode.playlist,
    );

    // Update currentSong and isPlaying
    currentSong.value = song;
    isPlaying.value = true;
  }

  AudioController get audioController => Get.put(AudioController());
  void pause() {
    _assetsAudioPlayer.pause();
    isPlaying.value = false;
  }

  void seekforward() {
    if (audioController.allSongs.isNotEmpty) {
      // Find the index of the current song
      int currentIndex =
          audioController.allSongs.indexOf(audioController.currentSong.value);
      // Calculate the index of the next song
      int nextIndex = currentIndex + 1;
      // Check if nextIndex is within the bounds of the song list
      if (nextIndex < audioController.allSongs.length) {
        // Get the next song
        SongModel nextSong = audioController.allSongs[nextIndex];
        // Play the next song
        audioController.play(nextSong);
      }
    }
  }

  void seekbackward() {
    if (audioController.allSongs.isNotEmpty) {
      // Find the index of the current song
      int currentIndex =
          audioController.allSongs.indexOf(audioController.currentSong.value);
      // Calculate the index of the previous song
      int previousIndex = currentIndex - 1;
      // Check if previousIndex is within the bounds of the song list
      if (previousIndex >= 0) {
        // Get the previous song
        SongModel previousSong = audioController.allSongs[previousIndex];
        // Play the previous song
        audioController.play(previousSong);
      }
    }
  }

  void continuesong() {
    _assetsAudioPlayer.play();
    isPlaying.value = true;
  }

  void PlayOrPause() {
    if (isPlaying.value == true) {
      pause();
    } else {
      continuesong();
    }
  }

  void disposeAudioPlayer() {
    pause();
    _assetsAudioPlayer.dispose();
  }
}
