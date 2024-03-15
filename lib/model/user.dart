
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/screens/profile_content.dart';

import 'package:flutter/foundation.dart';

class QawlUser {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String imagePath;
  final String id;
  final String name;
  final String email;
  final String about;
  final String country;
  int followers = 0;

  QawlUser({
    required this.imagePath,
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.country,
    required this.followers,
  });

  String getId() {
    return id;
  }

  String? getCurrentUserUid() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid; // This will be null if no user is logged in
  }

// Future<String> currentUser() async {
//   try  {
//      User _firebaseUser = await _auth.currentUser!();
//      if(_firebaseUser != null) {

//      }
//   }
//   catch (e) {

//   }
//     return "";

  //MUSA: See line 26 of profile_picture_widget. I just ran one method to build every PFP in the app
  //as the pfp of the Firebase user, but obviously I will change that later. It was just for
  //the sake of practicing changin ur personal pfp and then seeing it
  //MUSA: Create a method that returns the imagePath property of a user given the Firebase UID of the user.
  //First find the QawlUser with the UID get request, and then return this person's imagePath
  static Future<String?> getPfp(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.get('imagePath');
      } else {
        print("No user found for UID: $uid");
        return null;
      }
    } catch (e) {
      print("Error fetching user profile picture: $e");
      return null;
    }
  }

    static Future<String?> getAbout(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
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
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
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
  //MUSA: Create a method that edits the imagePath property of a user given the Firebase UID of the user and path.

  //First find the QawlUser with the uID get request, and then update this person's imagePath

// updating instance field with static method will need a current object reference passed in as a parameter
// a way to get around this could be to have a currentQawlUser class that is global to be able to access maybe
  void postPfp(String uid, String newImagePath) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'imagePath': newImagePath});
      print("User pfp updated successfully.");
      imagePath = newImagePath;
    } catch (e) {
      print("Error updating user pfp: $e");
    }
  }

//  static void updateImagePath(QawlUser user, String newPath) {
//     user.imagePath = newPath;
//     // Further actions, like updating a database, can also be performed here
//   }

  //create a Qawl user with the same UID as the firebase user and upload it to firebase
  //NOTE : User is a firebase user object, the user collection for firestore is being created in email_auth_provider.dart
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
          )
        : null;

     if (firebaseUser != null) {
       FirebaseFirestore.instance.collection('QawlUsers').doc(firebaseUser.uid).set({
        'uid': firebaseUser.uid,
         'email': firebaseUser.email,
         'timestamp' :DateTime.now()
       });
   }

    if (firebaseUser?.uid != null) {
      return firebaseUser?.uid;
    }
  }
}
