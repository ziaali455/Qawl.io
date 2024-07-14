import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/size_config.dart';
import 'package:flutter/material.dart';
import "package:first_project/model/countries_data.dart";

class ProfilePictureWidget extends StatefulWidget {
  //must be changed to Stateful to accomodate for changing username and pfp and then going back to this page
  final String imagePath;
  final String country;
  final bool isPersonal;
  final QawlUser user;

  ProfilePictureWidget({
    Key? key,
    required this.imagePath,
    required this.country,
    required this.isPersonal,
    required this.user,
  }) : super(key: key);

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  Key futureBuilderKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: buildImage(widget.country),
    );
  }

  

  Widget buildImage(String country) {
    Map<String, String> countryToEmoji = {
    for (var entry in allcountries.emojiToCountry.entries) entry.value: entry.key
  };

  final String? emojiFlag = countryToEmoji[country];
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    debugPrint("the current user is ${firebaseUser?.uid}");
    QawlUser user = widget.user;

    if (firebaseUser?.uid == null) {
      return Text('User not found');
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 60, // Adjust the size as needed
          backgroundImage: NetworkImage((user.imagePath.isEmpty) ? "https://firebasestorage.googleapis.com/v0/b/qawl-io-8c4ff.appspot.com/o/images%2Fdefault_images%2FEDA16247-B9AB-43B1-A85B-2A0B890BB4B3_converted.png?alt=media&token=6e7f0344-d88d-4946-a6de-92b19111fee3" : user.imagePath),
          backgroundColor: Colors.green,
        ),
        if(emojiFlag != null)
          Positioned(
            bottom: 0,
            right: 0,
            child: buildCountryIcon(emojiFlag),
          ),
      ],
    );
  }

  // Widget buildImage(String country) {
  Widget buildCountryIcon(String country) => buildCircle(
        color: Colors.black,
        all: 3,
        child: buildCircle(
          color: Colors.green,
          all: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3.0),
            child: Text(country, style:  TextStyle(fontSize: getProportionateScreenWidth(25))),
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

  Widget buildEmptyPFP({
  required Widget child,
  required double all,
  required Color color,
}) =>
    Stack(
      children: [
        ClipOval(
          child: Container(
            padding: EdgeInsets.all(all),
            decoration: BoxDecoration(
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
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 40, // Adjust the size of the icon as needed
            ),
          ),
        ),
      ],
    );
}
