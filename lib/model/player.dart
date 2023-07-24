import 'dart:io';

import 'package:first_project/model/playlist.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:first_project/model/track.dart';

import 'package:just_audio/just_audio.dart';

//OBI: NOTE THIS CLASS NO LONGER FUNCTIONS AS A PROVIDER
//all of the methods were moved outside of the class
/*class MusicProvider /*extends ChangeNotifier */ {
  //list that the audio player starts with, should be the song of the first take on take page

  //global player
  AudioPlayer player = AudioPlayer();

  void init() async {
    await openPlayer(music_list: current_list, initial_index: 0);
    // notifyListeners();
  }
}*/

AudioPlayer main_player = AudioPlayer();
List<Track> current_list = [];
bool isNext = true;
bool autoplay = true;

void playTracks(Playlist playlist) async {}

void playTrack(Track playedTrack) async {
  await main_player.setUrl(playedTrack.audioFile);
  if (main_player.playing == true &&
      main_player.processingState == ProcessingState.ready) {
    main_player.pause();
    closePlayer();
  }
  main_player.play();
}

bool trackIsPlaying() {
  return main_player.playing == true;
}

void pauseTrack() {
  main_player.pause();
}

void unpauseTrack() {
  main_player.play();
}

void closePlayer() {
  main_player.dispose();

  ///notifyListeners();
}
