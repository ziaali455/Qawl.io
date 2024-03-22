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
  final String trackName;
  final String id;

  int plays;
  final int surahNumber;
  String audioPath;
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
      this.coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg"});

  static Future<String?> createQawlTrack(String uid, String surah) async {
    //create unique id for each track
    String uniqueID = Uuid().v4();
    uid != null
        ? Track(
            userId: uid,
            id: uniqueID,
            inPlaylists: <Playlist>{}, //empty set for now
            trackName: '',
            plays: 0,
            surahNumber: getSurahNumberByName(surah)!,
            audioPath: '',
          )
        : null;

    //Store the recording in firestore
    await FirebaseFirestore.instance.collection('QawlTracks').add({
      'fileUrl': "fileUrl",
      'surah': surah,
      'userId': uid,
      'id': uniqueID, // generate unique 4 digit id for track
      // 'inPlaylists: <Playlist>{}, //empty set for now
      'trackName': '',
      'plays': 0,
      'surahNumber': getSurahNumberByName(surah)!,
      'audioPath': '',
      'timeStamp': DateTime.now() // for testing clarity
    });

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

  static Future<void> updateTrackField(
      String uid, String field, dynamic value) async {
    try {
      await FirebaseFirestore.instance
          .collection('QawlTracks')
          .doc(uid)
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
        String? uid = QawlUser.getCurrentUserUid();
        if (uid != null) {
          updateTrackField(uid, "fileUrl", downloadUrl);
        } else {
          print("Error: UID is null.");
        }
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

  // static Future<void> storeRecordingInFirestore(
  //     String fileUrl, String surah) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('QawlTracks').add({
  //       'fileUrl': fileUrl,
  //       'timestamp': FieldValue.serverTimestamp(),
  //       'surah': surah,
  //       'userId': "c",
  //       'id': Uuid().v4(), // generate unique 4 digit id for track
  //       // 'inPlaylists: <Playlist>{}, //empty set for now
  //       'trackName': '',
  //       'plays': 0,
  //       'surahNumber': 0,
  //       'audioPath': '',
  //     });
  //     debugPrint('File URL stored in Firestore successfully.');
  //   } catch (e) {
  //     debugPrint('Error storing file URL in Firestore: $e');
  //   }
  // }

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
