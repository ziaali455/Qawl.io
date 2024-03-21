import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_project/screens/profile_content.dart';

import 'package:flutter/foundation.dart';

class QawlUser {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String imagePath;
  final String id;
  String name;
  final String email;
  String about;
  String country;
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

  // this method can be called in other classes to get the UID
  static String? getCurrentUserUid() {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid; // This will be null if no user is logged in
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
      followers: data['followers'] ?? '',
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

  // getters for the object itself will be quicker than firebase lookups?
  String get getQawlUserImagePath => imagePath;
  String get getQawlUserId => id;
  String get getQawlUserName => name;
  String get getQawlUserEmail => email;
  String get getQawlUserAbout => about;
  String get getQawlUserCountry => country;
  int get getQawlUserFollowers => followers;

  //MUSA: See line 26 of profile_picture_widget. I just ran one method to build every PFP in the app
  //as the pfp of the Firebase user, but obviously I will change that later. It was just for
  //the sake of practicing changin ur personal pfp and then seeing it
  //MUSA: Create a method that returns the imagePath property of a user given the Firebase UID of the user.
  //First find the QawlUser with the UID get request, and then return this person's imagePath
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

// updating instance field with static method will need a current object reference passed in as a parameter
// a way to get around this could be to have a currentQawlUser class that is global to be able to access maybe
  // void postPfp(String uid, String newImagePath) async {
  //   try {
  //     await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(uid)
  //         .update({'imagePath': newImagePath});
  //     print("User pfp updated successfully.");
  //     imagePath = newImagePath;
  //   } catch (e) {
  //     print("Error updating user pfp: $e");
  //   }
  // }

  // Setters will set the objects field and call method to update the firestore entry
  set setName(String newName) {
    name = newName;
    updateUserField(id, "name", newName);
  }

  set setAbout(String newAbout) {
    about = newAbout;
    updateUserField(id, "about", newAbout);
  }

  set setCountry(String newCountry) {
    country = newCountry;
    updateUserField(id, "country", newCountry);
  }

  set setFollowers(int newFollowers) {
    followers = newFollowers;
    updateUserField(id, "followers", newFollowers);
  }

  Future<void> updateImagePath(String uid, String newPath) async {
    await FirebaseFirestore.instance.collection('QawlUsers').doc(uid).update({
      'imagePath': newPath,
    });
    debugPrint("\nImage path: " + imagePath + '\n');
    debugPrint("\n UPLOADING IMAGE TO STORAGE\n");
    // Create a reference to the location where you want to upload the image in Firebase Storage
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child("images/profile_images/$uid/profile.jpg");
    // Upload the file
    File imageFile =
        File(imagePath); // Convert the picked image path to a File object
    try {
      // Start the upload task
      UploadTask uploadTask = storageRef.putFile(imageFile);
      // Wait for the upload to complete
      await uploadTask;
      //this.imagePath = "images/profile_images/$uid/profile.jpg";
      
      // Get the download URL
      final url = await storageRef.getDownloadURL();
      imagePath = url;
      updateQawlUserImagePath(imagePath);
      print("THE DOWNLOAD URL IS: " + imagePath + '\n');
      print("Image uploaded successfully. URL: $url");
    } on FirebaseException catch (e) {
      // Handle any errors
      print("Error uploading image: ${e.message}");
    }


    debugPrint("Image path updated successfully.");
  }

  Future<void> updateQawlUserImagePath(String newPath) async {
    this.imagePath = newPath;
    await updateUserField(this.id, "imagePath", newPath);
  }

  // Method to update a specific field for the user in Firestore
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

    //check if the user already exists in firebase
    DocumentReference docRef = FirebaseFirestore.instance
        .collection('QawlUsers')
        .doc(firebaseUser?.uid);
    DocumentSnapshot docSnapshot = await docRef.get();

    if (firebaseUser != null && !docSnapshot.exists) {
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
        'followers': 0
      });
    }

    if (firebaseUser?.uid != null) {
      return firebaseUser?.uid;
    } else {
      return null;
    }
  }
}
