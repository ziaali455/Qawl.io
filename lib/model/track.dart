import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/track_info_content.dart';
import 'package:first_project/widgets/explore_track_widget_block.dart';
import 'package:flutter/material.dart';
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
  Set<QawlPlaylist> inPlaylists;
  String coverImagePath =
      "https://firebasestorage.googleapis.com/v0/b/qawl-io-8c4ff.appspot.com/o/images%2Fdefault_images%2FEDA16247-B9AB-43B1-A85B-2A0B890BB4B3_converted.png?alt=media&token=6e7f0344-d88d-4946-a6de-92b19111fee3";
  Track(
      {required this.userId,
      required this.id,
      required this.inPlaylists,
      required this.trackName,
      required this.plays,
      required this.surahNumber,
      required this.audioPath,
      this.coverImagePath = "https://firebasestorage.googleapis.com/v0/b/qawl-io-8c4ff.appspot.com/o/images%2Fdefault_images%2FEDA16247-B9AB-43B1-A85B-2A0B890BB4B3_converted.png?alt=media&token=6e7f0344-d88d-4946-a6de-92b19111fee3"});

  factory Track.fromFirestore(Map<String, dynamic> data, String id) {
    return Track(
      userId: data['userId'] as String,
      id: id,
      inPlaylists: <QawlPlaylist>{},
      trackName: data['trackName'] as String,
      plays: data['plays'] as int,
      surahNumber: data['surahNumber'] as int,
      audioPath: data['audioPath'] as String,
      coverImagePath:
          data['coverImagePath'] as String? ?? "defaultCoverImagePath",
    );
  }

  static Future<List<Track>> getTracksByUser(QawlUser user) async {
    List<Track> tracks = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('QawlTracks')
          .where('userId', isEqualTo: user.id)
          .get();

      querySnapshot.docs.forEach((doc) {
        Track track =
            Track.fromFirestore(doc.data()! as Map<String, dynamic>, doc.id);
        tracks.add(track);
      });
    } catch (error) {
      print("Error getting tracks: $error");
      // Handle error as necessary
    }
    return tracks;
  }

  static Future<Track?> getQawlTrack(String trackId) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('QawlTracks')
          .doc(trackId)
          .get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Firestore document data for track with ID $trackId: $data');
        return Track.fromFirestore(data, doc.id);
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching track: $e');
      return null;
    }
  }

  static Future<void> deleteTrack(Track track) async {
    try {
      await FirebaseFirestore.instance
          .collection('QawlTracks')
          .doc(track.id)
          .delete();
      print('Track with ID ${track.id} deleted successfully');
    } catch (e) {
      print('Error deleting track: $e');
    }
  }
  // Method to fetch a track by ID from Firestore

  static Future<String?> createQawlTrack(
      String uid, String surah, String fileUrl, text) async {
    //create unique id for each track
    String? imagePath = await QawlUser.getPfp(uid);
    String uniqueID = Uuid().v4();
    uid != null
        ? Track(
            userId: uid,
            id: uniqueID,
            inPlaylists: <QawlPlaylist>{}, //empty set for now
            trackName: text,
            plays: 0,
            surahNumber: getSurahNumberByName(surah)!,
            audioPath: fileUrl,
            coverImagePath: imagePath ?? "https://firebasestorage.googleapis.com/v0/b/qawl-io-8c4ff.appspot.com/o/images%2Fdefault_images%2FEDA16247-B9AB-43B1-A85B-2A0B890BB4B3_converted.png?alt=media&token=6e7f0344-d88d-4946-a6de-92b19111fee3",
          )
        : null;

    //Store the recording in firestore
    await FirebaseFirestore.instance.collection('QawlTracks').add({
      'surah': surah,
      'userId': uid,
      'coverImagePath': imagePath, //ali added this
      'id': uniqueID, // generate unique id for track
      'inPlaylists': <QawlPlaylist>{}, // need to address next
      'trackName': text,
      'plays': 0,
      'surahNumber': getSurahNumberByName(surah)!,
      'audioPath': fileUrl,
      'timeStamp': DateTime.now() // for testing clarity
    });

    QawlUser? uploader = await QawlUser.getQawlUser(uid);
    if (uploader == null) {
      print("no corresponding uploader");
    }
    uploader!.uploads.add(uniqueID);
    postUploads(uploader);

    print(fileUrl);

    return uid;
  }

  static void postUploads(QawlUser? user) async {
    try {
      if (user != null) {
        // Convert the set to a list before updating Firestore
        List<String> uploadsList = user.uploads.toList();
        await FirebaseFirestore.instance
            .collection('QawlUsers')
            .doc(user.id)
            .update({'uploads': uploadsList});
        print('Uploads updated successfully.');
      } else {
        print('User is null. Uploads not updated.');
      }
    } catch (e) {
      print('Error updating uploads: $e');
    }
  }

  Future<String?> getAuthor() {
    return QawlUser.getName(userId);
  }

  String getTrackName() {
    return trackName;
  }

  Future<void> increasePlays() async {
    this.plays++;
    updateTrackField(this.id, 'plays', plays);
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

  Set<QawlPlaylist> getInPlayLists() {
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
        inPlaylists = value as Set<QawlPlaylist>;
        break;
      default:
        print("Field $field not recognized or not updatable.");
        return;
    }

    // After updating locally, call the static method to update Firestore
    await updateTrackField(this.id, field, value);
  }

  Future<void> updateTrackField(String id, String field, dynamic value) async {
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
        // debugPrint(fileName);

        TaskSnapshot uploadTask =
            await FirebaseStorage.instance.ref(fileName).putFile(file);

        String downloadUrl = await uploadTask.ref.getDownloadURL();

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
        title: SurahMapper.getSurahNameByNumber(surahNumber),
        artist: userId,
        album: 'Qawl',
        artUri: Uri.parse(coverImagePath),
        duration: Duration(seconds: 0), // Replace with actual duration if available
        extras: <String, dynamic>{
          'surah': surahNumber,
          'plays': plays,
          'audioPath': audioPath,
          'inPlaylists': inPlaylists,
        },
      );

  factory Track.fromMediaItem(MediaItem mediaItem) {
    return Track(
      userId: mediaItem.artist ?? '',
      id: mediaItem.id,
      inPlaylists: mediaItem.extras?['inPlaylists'] ?? {},
      trackName: mediaItem.title,
      plays: mediaItem.extras?['plays'] ?? 0,
      surahNumber: mediaItem.extras?['surah'] ?? 0,
      audioPath: mediaItem.extras?['audioPath'] ?? '',
      coverImagePath: mediaItem.artUri?.toString() ??
          "https://firebasestorage.googleapis.com/v0/b/qawl-io-8c4ff.appspot.com/o/images%2Fdefault_images%2FEDA16247-B9AB-43B1-A85B-2A0B890BB4B3_converted.png?alt=media&token=6e7f0344-d88d-4946-a6de-92b19111fee3",
    );
  }
}
