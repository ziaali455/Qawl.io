import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/track.dart';

class faketrackdata {
  static var defaultTrack = Track(
    userId: "no author",
    id: "0",
    trackName: "none",
inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},    plays: 0,
    surahNumber: 0,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/001.mp3",
    coverImagePath:
        "https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg",
  );

  static var fakeTrack1 = Track(
    userId: "Mahmoud Hussary",
    id: "1",
    trackName: "Al-Fatihah",
inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},    plays: 2000000,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/001.mp3",
    coverImagePath: "https://quran.com.kw/en/wp-content/uploads/alhusarey.jpg",
  );
  static var fakeTrack2 = Track(
    userId: "Mohamed Minshawi",
    id: "2",
    trackName: "Al-Baqarah",
    inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},
    plays: 309444,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/002.mp3",
    coverImagePath:
        "https://static.qurancdn.com/images/reciters/7/mohamed-siddiq-el-minshawi-profile.jpeg?v=1",
  );

  static var fakeTrack3 = Track(
    userId: "Abdul Al-Sudais",
    id: "3",
    trackName: "Al-e-Imran",
inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},    plays: 654243,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/003.mp3",
    coverImagePath:
        "https://upload.wikimedia.org/wikipedia/commons/1/18/Abdul-Rahman_Al-Sudais_%28Cropped%2C_2011%29.jpg?20210429184005",
  );
  static var fakeTrack4 = Track(
    userId: "Noreen Siddig",
    id: "4",
    trackName: "An-Nisaa",
inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},    plays: 3543,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/004.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );
  static var fakeTrack5 = Track(
    userId: "Muzammil Hasballah",
    id: "5",
    trackName: "Ar-Rahman",
inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},    plays: 1234,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/004.mp3",
    coverImagePath:
        "https://i1.sndcdn.com/artworks-000180669830-vjgjbm-t500x500.jpg",
  );
  static var fakeTrack6 = Track(
    userId: "Abdul Rashid Ali",
    id: "6",
    inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},
    trackName: "Al-Maeda",
    plays: 1234,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/004.mp3",
    coverImagePath:
        "http://www.assajda.com/media/person/square/abdul-rashid-ali-sufi.jpg",
  );
  static var fakeTrack7 = Track(
    userId: "Maher Al-Mu'aiqly",
    id: "8",
    trackName: "An-Nisaa",
    inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},
    plays: 1234,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/004.mp3",
    coverImagePath:
        "https://upload.wikimedia.org/wikipedia/commons/9/90/Maher_Al_Mueaqly.png",
  );
  static var fakeTrack8 = Track(
    userId: "Raad Al-Kurdi",
    id: "9",
    trackName: "Al-Ikhlas",
    inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},
    plays: 1234,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/004.mp3",
    coverImagePath:
        "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Raad_Mohammad_Al_Kurdi.png/220px-Raad_Mohammad_Al_Kurdi.png",
  );
  static var fakeTrack9 = Track(
    userId: "Saud Al-Shuraim",
    id: "9",
    trackName: "Al-Ahzab",
    inPlaylists: {new Playlist(author: "authorName" , name: "new playlist", list: new List.empty())},
    plays: 1234,
    surahNumber: 1,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/004.mp3",
    coverImagePath:
        "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcS3K1uE6ZsiKtszKFoB9o78OXdWKh_lzXDJoaSb1cKx7SZUP_0s",
  );
}
