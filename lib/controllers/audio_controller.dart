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

  Future<void> fetchSongs() async {
    // Fetch songs from local assets
    await fetchLocalAssetSongs();
    // Fetch songs from device storage
    await fetchDeviceStorageSongs();
  }

  Future<void> fetchLocalAssetSongs() async {
    // You can manually add your local asset songs here
    // For example:
    allSongs.addAll([
      // Add your local asset songs here
    ]);
  }

  Future<void> fetchDeviceStorageSongs() async {
    // Query all songs from device storage
    List<SongModel> deviceSongs = await _audioQuery.querySongs();
    // Add device storage songs to the list
    allSongs.addAll(deviceSongs);
  }

  
  Future<void> play(SongModel song) async {
    // Extract the necessary details from the song model
    final String title = song.title;
    final String? artist = song.artist;
    final String? album = song.album;
    final String data = song.data;

    // Create an Audio instance using the data path
    final Audio audio = Audio.file(data);

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

  void pause() {
    _assetsAudioPlayer.pause();
    isPlaying.value = false;
  }

  void disposeAudioPlayer() {
    pause();
    _assetsAudioPlayer.dispose();
  }

  void playSongFromDeezer(String previewUrl) {
    // Create an Audio instance for the Deezer preview URL
    final Audio audio = Audio.network(previewUrl);

    // Stop any current playback
    _assetsAudioPlayer.stop();

    // Open the new audio for playback
    _assetsAudioPlayer.open(
      audio,
      showNotification: true,
      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
      loopMode: LoopMode.playlist,
    );

    // Set isPlaying to true
    isPlaying.value = true;
  }
}
