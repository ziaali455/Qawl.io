import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:first_project/model/user.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  //must be changed to Stateful to accomodate for changing username and pfp and then going back to this page
  final String imagePath;
  final VoidCallback onClicked;
  final String country;

  const ProfilePictureWidget({
    Key? key,
    required this.imagePath,
    required this.country,
    required this.onClicked,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: buildImage(country),
    );
  }

  Widget buildImage(String country) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    String imageURL = QawlUser.getPfp(firebaseUser!.uid) as String;
    //make a firebase get request for the created profile picture here
    if (imageURL != null) { 
      final image = NetworkImage(imageURL);
      return Stack(children: [
        ClipOval(
            child: Material(
                color: Colors.transparent,
                child: Ink.image(
                  image: image,
                  fit: BoxFit.cover,
                  width: 128,
                  height: 128,
                ))),
        Positioned(
          bottom: 0,
          right: 4,
          child: buildCountryIcon(country),
        ),
      ]);
    } else {
      return Stack(children: [
        ClipOval(
            child: Material(
                child: UserAvatar(
          size: 128,
          placeholderColor: Colors.green,
        ))),
        Positioned(
          bottom: 0,
          right: 4,
          child: buildCountryIcon(country),
        ),
      ]);
    }
  }

  Widget buildCountryIcon(String country) => buildCircle(
        color: Colors.black,
        all: 3,
        child: buildCircle(
          color: Colors.green,
          all: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3.0),
            child: Text(country, style: const TextStyle(fontSize: 25)),
          ),
        ),
      );
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromARGB(255, 13, 161, 99),
                Color.fromARGB(255, 22, 181, 93),
                Color.fromARGB(255, 32, 220, 85),
              ],
            ),
          ),
          child: child,
        ),
      );
}
