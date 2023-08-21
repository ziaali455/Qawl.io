import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class Track {
  String author; // should be a user object?
  final String trackName;
  final String id;
  //String inPlaylist HashMap<String, List<Playlist>>???
  int plays;
  final String surah;
  final String audioFile;
  String coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg";
  final player = AudioPlayer();
  int count = 0;
  Track(
      {required this.author,
      required this.id,
      required this.trackName,
      required this.plays,
      required this.surah,
      required this.audioFile,
      required this.coverImagePath}) {
    initPlayer();
  }
  Future<void> initPlayer() async {
    await player.setUrl(audioFile);
  }

  String getAuthor() {
    return author;
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

  String getSurah() {
    return surah;
  }

  String getAudioFile() {
    return audioFile;
  }

  void playTrack(int count) async {
    this.count = count;
    await player.setUrl(audioFile);
    if (count % 2 != 0) {
      player.play();
      plays++;
    } else {
      await player.pause();
    }
  }

  bool isTrackPlaying() {
    return (count % 2 != 0);
  }

  // factory Track.fromMediaItem(MediaItem mediaItem) {
  //   String trackPath, trackURL;
  //   return Track(author: fakeuserdata.user0.name, id: mediaItem.id, trackName: mediaItem.title, plays: 0, surah: surah, audioFile: trackURL, coverImagePath: coverImagePath)
  // }
  MediaItem toMediaItem() => MediaItem(
      id: id,
      title: trackName,
      artist: author,
      artUri: Uri.parse(coverImagePath),
      extras: <String, dynamic>{
        'surah':surah,
        "plays": plays,
      });
}
