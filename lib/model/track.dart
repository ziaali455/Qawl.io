import 'dart:io';

class Track {
  String author;
  final String trackName;
  int plays;
  final String surah;
  final String audioFile;
  String coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg";

  Track(
      {required this.author,
      required this.trackName,
      required this.plays,
      required this.surah,
      required this.audioFile,
      required this.coverImagePath});

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

  void play(String audioFile) {
    File myFile = File(audioFile);
  }
}
