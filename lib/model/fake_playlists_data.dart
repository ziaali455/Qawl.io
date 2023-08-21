import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/fake_track_data.dart';

class fake_playlist_data {
  static var defaultPlaylist = Playlist(author: "Mishary", name: "new", list: [
    faketrackdata.defaultTrack,
    faketrackdata.fakeTrack1,
    faketrackdata.fakeTrack2
  ]);
  static var uploads = Playlist(author: "musa", name: "Uploads", list: [
    faketrackdata.fakeTrack3,
    faketrackdata.fakeTrack1,
    faketrackdata.fakeTrack2
  ]);
}
