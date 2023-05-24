import 'package:first_project/model/fakeuserdata.dart';
import 'package:first_project/profilewidget.dart';
import 'package:first_project/trackwidget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/numberswidget.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/model/faketrackdata.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({Key? key}) : super(key: key);
  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    const user = fakeuserdata.fakeUser;
    var track = faketrackdata.fakeTrack; //pass in data here 
    return Container(
        padding: EdgeInsets.only(top: 50),
        child: Scaffold(
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: user.imagePath,
                onClicked: () async {},
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildName(user),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: NumbersWidget(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: buildAbout(user),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
              ),
              TrackWidget(
                  title: track.trackName, //accessing the data in the data set for profile widget to use
                  audioPath: track.audioFile,
                  coverImagePath:
                      track.coverImagePath),
            ],
          ),
        ));
  }

  Widget buildName(User user) => Column(
        children: [
          Text(user.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
        ],
      );
  Widget buildAbout(User user) => Column(
        children: [
          Text(user.about,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12))
        ],
      );
}
