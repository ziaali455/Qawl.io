import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/track.dart';


import 'package:first_project/model/audio_handler.dart';

// AudioPlayer main_player = AudioPlayer();
MyAudioHandler audioHandler = MyAudioHandler();
List<Track> current_list = [];
late Track currentTrack;
bool isNext = true;
bool autoplay = true;
var currentPlaylist;

// void playTracks(List<Track> tracks) async {
//   updateCurrentPlaylist(tracks);
//   await main_player.setAudioSource(currentPlaylist);
//   main_player.play();
// }

// void updateCurrentPlaylist(List<Track> tracks) {
//   List<AudioSource> audioSources = tracks.map((track) {
//     return AudioSource.uri(
//       Uri.parse(track.audioPath),
//       tag: track.toMediaItem(),
//     );
//   }).toList();
//   currentPlaylist = ConcatenatingAudioSource(children: audioSources);
// }

// void playTrack(Track playedTrack) async {
//   currentTrack = playedTrack;
//   await main_player.setUrl(playedTrack.audioPath);
//   if (main_player.playing == true &&
//       main_player.processingState == ProcessingState.ready) {
//     main_player.pause();
//   }
//   main_player.play();
// }

// bool trackIsPlaying() {
//   return main_player.playing == true;
// }

// void pauseTrack() {
//   main_player.pause();
// }

// void unpauseTrack() {
//   main_player.play();
// }

// void closePlayer() {
//   main_player.dispose();
//   AudioService.stop();
// }

Track getCurrentTrack() {
  return currentTrack;
}

void playTracks(List<Track> tracks) async {
  await audioHandler.updatePlaylist(tracks);
  audioHandler.play();
}

// Function to update the current playlist
Future<void> updateCurrentPlaylist(List<Track> tracks) async {
  await audioHandler.updatePlaylist(tracks);
}

// // Function to play a specific track
// void playTrack(Track playedTrack) async {
//   currentTrack = playedTrack;
//   audioHandler.loadSingleTrack(playedTrack);
//   audioHandler.play();
//   playedTrack.increasePlays();
// }

void playTrackWithList(
    Track playedTrack, QawlPlaylist destinationPlaylist) async {
  currentTrack = playedTrack;
  playedTrack.increasePlays();
  audioHandler.playTrackWithPlaylist(playedTrack, destinationPlaylist.list);
}

// Function to check if a track is playing
bool trackIsPlaying() {
  return audioHandler.playbackState.value.playing;
}

// Function to get the current track

// Function to pause the current track
void pauseTrack() {
  audioHandler.pause();
}

// Function to unpause the current track
void unpauseTrack() {
  audioHandler.play();
}

// Function to close the player
void closePlayer() {
  audioHandler.stop();
}
