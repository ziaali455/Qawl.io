import 'dart:ffi';

import 'package:first_project/model/track.dart';

class Playlist {
  final String author;
  final String name;
  int trackCount;
  final String surah;
  final List<Track> list;
  String coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg";
  Playlist(
      {required this.author,
      required this.name,
      this.trackCount = 0,
      required this.surah,
      required this.list});
  void addTrack(Track track) {
    list.add(track);
    trackCount++;
  }

  void removeTrack(Track track) {
    if (!empty()) {
      list.remove(track);
      trackCount--;
    } else {
      print("you can't remove from an empty list!");
    }
  }

  int getCount() {
    return list.length;
  }

  bool empty() {
    return list.isEmpty;
  }
}
