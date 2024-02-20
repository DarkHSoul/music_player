import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player/controllers/audio_controller.dart';

class playSongButton extends StatelessWidget {
  const playSongButton({
    super.key,
    required this.audioController,
  });

  final AudioController audioController;

  @override
  Widget build(BuildContext context) {
    return Obx(() => IconButton(
          icon: Icon(
              audioController.isPlaying.value ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            audioController.PlayOrPause();
          },
        ));
  }
}
