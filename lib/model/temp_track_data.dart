import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/model/fake_playlists_data.dart';
import 'package:flutter/rendering.dart';

//we can use int.parse(id)
class temp_track_data {
  static var fakeTrack5 = Track(
    userId: "Muhammad Khan",
    id: "1",
    inPlaylists: inPlaylist5,
    trackName: "Surah Maryam Taraweeh",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist5 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };

  static var fakeTrack6 = Track(
    userId: "Abdullah Mahmud",
    id: "6",
    inPlaylists: inPlaylist6,
    trackName: "Surah An'aam Fajr",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist6 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };

  static var fakeTrack7 = Track(
    userId: "Hamza Rahman",
    id: "7",
    inPlaylists: inPlaylist7,
    trackName: "Surah Ghaafir",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist7 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };


  static var fakeTrack8 = Track(
    userId: "Abdulrahman Muhammd",
    id: "8",
    inPlaylists: inPlaylist8,
    trackName: "Surah Rahman",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist8 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };

  static var fakeTrack9 = Track(
    userId: "Zainab Khan",
    id: "9",
    inPlaylists: inPlaylist9,
    trackName: "Surah Israa",
    plays: 1234,
    surahNumber: 16,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/016.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist9 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };

  static var fakeTrack10 = Track(
    userId: "Yunus Amir",
    id: "10",
    inPlaylists: inPlaylist6,
    trackName: "Surah Yaseen Taraweeh",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist10 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };

 static var fakeTrack11 = Track(
    userId: "Yusuf Al-Ansaari",
    id: "11",
    inPlaylists: inPlaylist6,
    trackName: "Surah Maidah",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist11 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };
  static var fakeTrack12= Track(
    userId: "Aisha Malik",
    id: "12",
    inPlaylists: inPlaylist6,
    trackName: "Surah Zumar",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist12 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };

 static var fakeTrack13 = Track(
    userId: "Ahmed Muhammad",
    id: "13",
    inPlaylists: inPlaylist6,
    trackName: "Surah Saad",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist13 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };

 static var fakeTrack14 = Track(
    userId: "Muhammad Khan",
    id: "14",
    inPlaylists: inPlaylist6,
    trackName: "Surah Hajj Taraweeh",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist14 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };

 static var fakeTrack15 = Track(
    userId: "Ibrahim Jamal",
    id: "15",
    inPlaylists: inPlaylist6,
    trackName: "Surah Adiyaat",
    plays: 1234,
    surahNumber: 19,
    audioPath: "https://server8.mp3quran.net/ahmad_huth/019.mp3",
    coverImagePath:
        "https://assets.audiomack.com/mnissara321/40a82a3d67f838f992a195e6a90e81b82ab5bead4925639acb4581846273d60c.jpeg?width=1500&height=1500&max=true",
  );

  static Set<Playlist> inPlaylist15 = {

      Playlist(
          author: fake_playlist_data.defaultPlaylist.author,
          list: fake_playlist_data.defaultPlaylist.list,
          name: fake_playlist_data.defaultPlaylist.name),
      Playlist(
         author: fake_playlist_data.top100.author,
          list: fake_playlist_data.top100.list,
          name: fake_playlist_data.top100.name)
  
  };
}
