import 'package:flutter/material.dart';
import 'package:flutter_sliding_box/flutter_sliding_box.dart';
import 'package:get/get.dart';
import 'package:music_player/buttons/playSongButton.dart';

import 'package:music_player/controllers/audio_controller.dart';
import 'package:music_player/pages/musicUi.dart';

import 'package:on_audio_query/on_audio_query.dart';

class myFloatButton extends StatelessWidget {
  const myFloatButton({
    super.key,
    required this.audioController,
  });

  final AudioController audioController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      width: MediaQuery.of(context).size.width - 16,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //thumbnail of the song
          QueryArtworkWidget(
            type: ArtworkType.AUDIO,
            id: audioController.currentSong.value!.id,
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.325,
                child: Text(
                  audioController.currentSong.value!.displayNameWOExt,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              IconButton(
                  icon: Icon(Icons.fast_rewind),
                  onPressed: () {
                    audioController.seekbackward();
                  }),
              playSongButton(audioController: audioController),
              IconButton(
                icon: Icon(Icons.fast_forward),
                onPressed: () {
                  audioController.seekforward();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
