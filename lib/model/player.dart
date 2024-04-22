import 'package:first_project/model/playlist.dart';
import 'package:just_audio/just_audio.dart';
import 'package:first_project/model/track.dart';

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

import 'package:audio_service/audio_service.dart';

AudioPlayer main_player = AudioPlayer();
List<Track> current_list = [];
late Track currentTrack;
bool isNext = true;
bool autoplay = true;
var currentPlaylist;

void playTracks(List<Track> tracks) async {
  updateCurrentPlaylist(tracks);
  await main_player.setAudioSource(currentPlaylist);
  main_player.play();
}

void updateCurrentPlaylist(List<Track> tracks) {
  List<AudioSource> audioSources = tracks.map((track) {
    return AudioSource.uri(
      Uri.parse(track.audioPath),
      tag: track.toMediaItem(),
    );
  }).toList();
  currentPlaylist = ConcatenatingAudioSource(children: audioSources);
}

void playTrack(Track playedTrack) async {
  currentTrack = playedTrack;
  await main_player.setUrl(playedTrack.audioPath);
  if (main_player.playing == true &&
      main_player.processingState == ProcessingState.ready) {
    main_player.pause();
  }
  main_player.play();
}

bool trackIsPlaying() {
  return main_player.playing == true;
}

Track getCurrentTrack() {
  return currentTrack;
}

void pauseTrack() {
  main_player.pause();
}

void unpauseTrack() {
  main_player.play();
}

void closePlayer() {
  main_player.dispose();
  AudioService.stop();
}

// I click on surah nas by musa -> surah nas by musa ends -> I need to find the previous tracks -> 
//I need to know what playlist surah nas by musa in -> 
// I need to find surah nas' location in this list -> I go to the track before it