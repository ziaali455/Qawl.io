import 'package:first_project/model/playlist.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class Track {
  final String userId; 
  final String trackName;
  final String id;
  
  int plays;
  final int surahNumber;
  final String audioPath;
  final Set<Playlist> inPlaylists;
  String coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg";
  Track(
      {required this.userId,
      required this.id,
      required this.inPlaylists,
      required this.trackName,
      required this.plays,
      required this.surahNumber,
      required this.audioPath,
      this.coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg"}) {
  }


  String getAuthor() {
    return userId;
  }

  String getTrackName() {
    return trackName;
  }

  void increasePlays() {
    plays++;
  }

  int getPlays() {
    return plays;
  }

  int getSurah() {
    return surahNumber;
  }

  String getAudioFile() {
    return audioPath;
  }

  Set<Playlist> getInPlayLists() {
    return inPlaylists;
  }


  // factory Track.fromMediaItem(MediaItem mediaItem) {
  //   String trackPath, trackURL;
  //   return Track(author: fakeuserdata.user0.name, id: mediaItem.id, trackName: mediaItem.title, plays: 0, surah: surah, audioFile: trackURL, coverImagePath: coverImagePath)
  // }
  MediaItem toMediaItem() => MediaItem(
          id: id,
          title: trackName,
          artist: userId,
          artUri: Uri.parse(coverImagePath),
          extras: <String, dynamic>{
            'surah': surahNumber,
            "plays": plays,
          });
}
