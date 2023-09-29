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
}
