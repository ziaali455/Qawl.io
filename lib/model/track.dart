import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/track_info_content.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Track {
  final String userId;
  String trackName;
  final String id;

  int plays;
  final int surahNumber;
  String audioPath;
  Set<Playlist> inPlaylists;
  String coverImagePath =
      "https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg";
  Track(
      {required this.userId,
      required this.id,
      required this.inPlaylists,
      required this.trackName,
      required this.plays,
      required this.surahNumber,
      required this.audioPath,
      this.coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg"});


  factory Track.fromFirestore(Map<String, dynamic> data, String id) {
    return Track(
      userId: data['userId'] as String,
      id: id,
       inPlaylists: <Playlist>{}, 
      trackName: data['trackName'] as String,
      plays: data['plays'] as int,
      surahNumber: data['surahNumber'] as int,
      audioPath: data['audioPath'] as String,
      coverImagePath:
          data['coverImagePath'] as String? ?? "defaultCoverImagePath",
    );
  }

  // Method to fetch a track by ID from Firestore
  static Future<Track?> getQawlTrack(String trackId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('QawlTracks')
          .doc(trackId)
          .get();
      if (docSnapshot.exists) {
        return Track.fromFirestore(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        print("Track not found.");
        return null;
      }
    } catch (e) {
      print("Error fetching track: $e");
      return null;
    }
  }

  static Future<String?> createQawlTrack(
      String uid, String surah, String fileUrl, text) async {
    //create unique id for each track
    String uniqueID = Uuid().v4();
    uid != null
        ? Track(
            userId: uid,
            id: uniqueID,
            inPlaylists: <Playlist>{}, //empty set for now
            trackName: text,
            plays: 0,
            surahNumber: getSurahNumberByName(surah)!,
            audioPath: fileUrl,
          )
        : null;

    //Store the recording in firestore
    await FirebaseFirestore.instance.collection('QawlTracks').add({
      'surah': surah,
      'userId': uid,
      'coverImagePath': '', //ali added this
      'id': uniqueID, // generate unique id for track
      'inPlaylists': <Playlist>{}, // need to address next
      'trackName': text,
      'plays': 0,
      'surahNumber': getSurahNumberByName(surah)!,
      'audioPath': fileUrl,
      'timeStamp': DateTime.now() // for testing clarity
    });
    print(fileUrl);

    return uid;
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

    //id and userId should not change
    Future<void> updateLocalField(String field, dynamic value) async {
    switch (field) {
      case 'audioPath':
        this.audioPath = value as String;
        break;
      case 'plays':
        this.plays = value as int;
        break;
      case 'coverImagePath':
        this.coverImagePath = value as String;
        break;
      case 'trackName':
        this.trackName = value as String;
        break;
      case 'surahNumber':
        this.plays = value as int;
        break;
      case 'surahNumber':
        this.plays = value as int;
        break;
      case 'inPlaylists':
        inPlaylists = value as Set<Playlist>;
        break;
      default:
        print("Field $field not recognized or not updatable.");
        return;
    }

    // After updating locally, call the static method to update Firestore
    await updateTrackField(this.id, field, value);
  }



   Future<void> updateTrackField(
      String id, String field, dynamic value) async {
    try {
      await FirebaseFirestore.instance
          .collection('QawlTracks')
          .doc(id)
          .update({field: value});
      debugPrint("User $field updated successfully.");
      


    } catch (e) {
      debugPrint("Error updating user $field: $e");
    }
  }

  static Future<String> getTemporaryFilePath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    return '$tempPath/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

  static Future<String?> uploadRecordingToStorage(String? filePath) async {
    debugPrint("Uploading recording...");
    File file;
    if (filePath != null) {
      file = File(filePath);

      try {
        String fileName =
            'recordings/${DateTime.now().millisecondsSinceEpoch}.m4a';
        debugPrint(fileName);

        TaskSnapshot uploadTask =
            await FirebaseStorage.instance.ref(fileName).putFile(file);

        String downloadUrl = await uploadTask.ref.getDownloadURL();
        // make field in firebase audioPath = download URL
        // String? uid = QawlUser.getCurrentUserUid();
        // if (uid != null) {
        //   updateTrackField(uid, "fileUrl", downloadUrl);
        // } else {
        //   print("Error: UID is null.");
        // }
        return downloadUrl;
      } catch (e) {
        debugPrint("Error uploading audio file: $e");
        return null;
      }
    } else {
      debugPrint("null filepath parameter");
      return null;
    }
  }

  static Future<void> deleteLocalFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        debugPrint("Local file deleted successfully.");
      }
    } catch (e) {
      debugPrint("Error deleting local file: $e");
    }
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
