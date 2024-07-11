import 'dart:io';

import 'package:first_project/model/user.dart';
import 'package:first_project/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoScreen extends StatefulWidget {
  @override
  _ProfilePhotoScreenState createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends State<ProfilePhotoScreen> {
  bool _isImagePicked = false;
  String? _imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Pick a Profile Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundColor: Colors.grey,
                backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : FileImage(File("https://firebasestorage.googleapis.com/v0/b/qawl-io-8c4ff.appspot.com/o/images%2Fdefault_images%2FEDA16247-B9AB-43B1-A85B-2A0B890BB4B3_converted.png?alt=media&token=6e7f0344-d88d-4946-a6de-92b19111fee")) ,
)) ,         
            
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey, // Background color
                    ),
                    child: const Text(
                      'Skip',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _pickImage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                    ),
                    child: const Text(
                      'Change',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),
            if (_isImagePicked)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Background color
                  ),
                  child: const Text('Next'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<String?>  _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String? uid = QawlUser.getCurrentUserUid();
      if (uid != null) {
        String imagePath = pickedFile.path;
        QawlUser? currUser = await QawlUser.getQawlUser(uid);
        await currUser!.updateImagePath(uid, imagePath);
      } else {
        print("No signed-in user found.");
      }
    }

    // Update the state to show the Next button
    setState(() {
      _isImagePicked = true;
    });
    return pickedFile?.path;
  }
}
