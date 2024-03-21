import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:first_project/model/user.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatefulWidget {
  //must be changed to Stateful to accomodate for changing username and pfp and then going back to this page
  final String imagePath;
  final VoidCallback onClicked;
  final String country;
  

   ProfilePictureWidget({
    Key? key,
    required this.imagePath,
    required this.country,
    required this.onClicked,
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
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  debugPrint("the current user is ${firebaseUser?.uid}");

  if (firebaseUser?.uid == null) {
    return Text('User not found');
  }

  return FutureBuilder<QawlUser?>(
    future: QawlUser.getQawlUser(QawlUser.getCurrentUserUid() ?? ''),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          if (user.imagePath.isNotEmpty) {
          debugPrint("THE IMAGE PATH TO SHOW IS: " + user.imagePath + '\n');
          // need to check if we are viewing a personal content widget or other qari widget
          // then show pfp and follow button accordingly 
            return CircleAvatar(
              radius: 60, // Adjust the size as needed
              backgroundImage: NetworkImage(user.imagePath),
              backgroundColor: Colors.green,
            );
          }
        }
        // Return a placeholder if there's no imagePath or snapshot has no data
        return CircleAvatar(
          radius: 60,
          child: Icon(Icons.person, size: 60),
          backgroundColor: Colors.red[200],
        );
      } else {
        // Future is not yet complete, show a loading indicator
        return CircularProgressIndicator();
      }
    },
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
