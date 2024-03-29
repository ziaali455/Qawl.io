import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/track.dart';
import 'package:flutter/foundation.dart';

class QawlUser {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String imagePath;
  final String id;
  String name;
  final String email;
  String about;
  String country;
  int followers;
  Set<String> following;
  Set<String> privateLibrary;
  Set<String> uploads;

  QawlUser(
      {required this.imagePath,
      required this.id,
      required this.name,
      required this.email,
      required this.about,
      required this.country,
      required this.followers,
      required this.following,
      required this.privateLibrary,
      required this.uploads});

  static String? getCurrentUserUid() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid;
  }

  factory QawlUser.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return QawlUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      imagePath: data['imagePath'] ?? '',
      about: data['about'] ?? '',
      country: data['country'] ?? '',
      followers: data['followers'] ?? 0,
      following: Set<String>.from(data['following'] ?? []),
      privateLibrary: Set<String>.from(data['privateLibrary'] ?? []),
      uploads: Set<String>.from(data['publicLibrary'] ?? []),
    );
  }

  static Future<QawlUser?> getQawlUser(String uid) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('QawlUsers').doc(uid).get();
    if (doc.exists) {
      return QawlUser.fromFirestore(doc);
    } else {
      return null;
    }
  }

  String get getQawlUserImagePath => imagePath;
  String get getQawlUserId => id;
  String get getQawlUserName => name;
  String get getQawlUserEmail => email;
  String get getQawlUserAbout => about;
  String get getQawlUserCountry => country;
  int get getQawlUserFollowers => followers;
  Set<String> get getQawlUserFollowing => following;

  static Future<String?> getPfp(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('QawlUsers')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        return userDoc.get('imagePath');
      } else {
        debugPrint("No user found for UID: $uid");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching user profile picture: $e");
      return null;
    }
  }

  static Future<String?> getName(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('QawlUsers')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        return userDoc.get('name');
      } else {
        debugPrint("No user found for UID: $uid");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching user profile picture: $e");
      return null;
    }
  }

  static Future<String?> getAbout(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('QawlUsers')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        return userDoc.get('about');
      } else {
        print("No about found for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching about: $e");
      return null;
    }
  }

  static Future<String?> getFollowers(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('QawlUsers')
          .doc(uid)
          .get();
      if (userDoc.exists) {
        return userDoc.get('followers');
      } else {
        print("No follower data found for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching followers: $e");
      return null;
    }
  }

  Future<void> updateImagePath(String uid, String newPath) async {
    await FirebaseFirestore.instance.collection('QawlUsers').doc(uid).update({
      'imagePath': newPath,
    });
    debugPrint("\nImage path: " + imagePath + '\n');
    debugPrint("\n UPLOADING IMAGE TO STORAGE\n");
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("images/profile_images/$uid/profile.jpg");
    File imageFile = File(imagePath);
    try {
      UploadTask uploadTask = storageRef.putFile(imageFile);
      await uploadTask;
      final url = await storageRef.getDownloadURL();
      imagePath = url;
      updateQawlUserImagePath(imagePath);
      print("THE DOWNLOAD URL IS: " + imagePath + '\n');
      print("Image uploaded successfully. URL: $url");
    } on FirebaseException catch (e) {
      print("Error uploading image: ${e.message}");
    }
    debugPrint("Image path updated successfully.");
  }

  Future<void> updateQawlUserImagePath(String newPath) async {
    this.imagePath = newPath;
    await updateUserField(this.id, "imagePath", newPath);
  }

  static Future<void> updateUserField(
      String uid, String field, dynamic value) async {
    try {
      await FirebaseFirestore.instance
          .collection('QawlUsers')
          .doc(uid)
          .update({field: value});
      debugPrint("User $field updated successfully.");
    } catch (e) {
      debugPrint("Error updating user $field: $e");
    }
  }

  static Future<String?> createQawlUser(User? firebaseUser) async {
    firebaseUser != null
        ? QawlUser(
            imagePath: "",
            id: firebaseUser.uid,
            name: "",
            email: firebaseUser.email ?? "",
            about: "",
            country: "",
            followers: 0,
            following: Set<String>(),
            privateLibrary: Set<String>(),
            uploads: Set<String>(),
          )
        : null;
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('QawlUsers')
        .doc(firebaseUser?.uid);
    DocumentSnapshot docSnapshot = await docRef.get();
    if (firebaseUser != null && !docSnapshot.exists) {
      Playlist uploads = new Playlist(
          author: firebaseUser.uid, name: "Uploads", list: List<Track>.empty());
      await FirebaseFirestore.instance
          .collection('QawlUsers')
          .doc(firebaseUser.uid)
          .set({
        'uid': firebaseUser.uid,
        'email': firebaseUser.email,
        'timestamp': DateTime.now(),
        'imagePath': "",
        'name': "",
        'about': "",
        'country': "",
        'followers': 0,
        'following': [],
        'privateLibrary': [],
        'publicLibrary': [uploads],
      });
    }
    if (firebaseUser?.uid != null) {
      return firebaseUser?.uid;
    } else {
      return null;
    }
  }
}
