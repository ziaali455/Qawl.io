import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/fake_track_data.dart';

class fake_playlist_data {
  static var defaultPlaylist = Playlist(author: "Mishary", name: "new", list: [
    faketrackdata.fakeTrack1,
    faketrackdata.fakeTrack2,
    faketrackdata.fakeTrack3,
    faketrackdata.fakeTrack4,
    faketrackdata.fakeTrack5,
  ]);
  static var top100 = Playlist(author: "musa", name: "Top 100", list: [
    faketrackdata.fakeTrack6,
    faketrackdata.fakeTrack7,
    faketrackdata.fakeTrack8,
    faketrackdata.fakeTrack9,
  ]);
  static var newReleases = Playlist(author: "qawl", name: "New", list: [
    faketrackdata.fakeTrack6,
    faketrackdata.fakeTrack7,
    faketrackdata.fakeTrack8,
    faketrackdata.fakeTrack9,
  ]);
   static var trending = Playlist(author: "qawl", name: "Trending", list: [
    faketrackdata.fakeTrack6,
    faketrackdata.fakeTrack7,
    faketrackdata.fakeTrack8,
    faketrackdata.fakeTrack9,
  ]);
  static var following = Playlist(author: "qawl", name: "Following", list: [
    faketrackdata.fakeTrack6,
    faketrackdata.fakeTrack7,
    faketrackdata.fakeTrack8,
    faketrackdata.fakeTrack9,
  ]);
  static var homeExample1 = Playlist(author: "Mishary", name: "Late Night", list: [
    faketrackdata.fakeTrack1,
    faketrackdata.fakeTrack2,
    faketrackdata.fakeTrack3,
    faketrackdata.fakeTrack4,
    faketrackdata.fakeTrack5,
  ]);
  static var homeExample2 = Playlist(author: "Mishary", name: "Soninke", list: [
    faketrackdata.fakeTrack1,
    faketrackdata.fakeTrack2,
    faketrackdata.fakeTrack3,
    faketrackdata.fakeTrack4,
    faketrackdata.fakeTrack5,
  ]);
  static var homeExample3 = Playlist(author: "Mishary", name: "Favorites", list: [
    faketrackdata.fakeTrack1,
    faketrackdata.fakeTrack2,
    faketrackdata.fakeTrack3,
    faketrackdata.fakeTrack4,
    faketrackdata.fakeTrack5,
  ]);
  static var homeExample4 = Playlist(author: "Mishary", name: "Taraweeh", list: [
    faketrackdata.fakeTrack1,
    faketrackdata.fakeTrack2,
    faketrackdata.fakeTrack3,
    faketrackdata.fakeTrack4,
    faketrackdata.fakeTrack5,
  ]);
  static var recents = Playlist(author: "Mishary", name: "Recently Played", list: [
    faketrackdata.fakeTrack4,
    faketrackdata.fakeTrack5,
  ]);
  static var homeExample5 = Playlist(author: "Mishary", name: "Studying", list: [
    faketrackdata.fakeTrack1,
    faketrackdata.fakeTrack5,
  ]);
  static var homeExample6 = Playlist(author: "Mishary", name: "Car Ride", list: [
    faketrackdata.fakeTrack2,
    faketrackdata.fakeTrack3,
    faketrackdata.fakeTrack4,
    faketrackdata.fakeTrack5,
  ]);
}
