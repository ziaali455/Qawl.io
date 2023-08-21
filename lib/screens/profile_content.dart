import 'package:first_project/model/fake_user_data.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/screens/record_audio_content.dart';
import 'package:first_project/widgets/profile_picture_widget.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:first_project/widgets/track_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/widgets/profile_stats_widget.dart';
import 'package:first_project/model/fake_track_data.dart';

import 'now_playing_content.dart';

class PersonalProfileContent extends StatefulWidget {
  const PersonalProfileContent({
    Key? key,
  }) : super(key: key);
  @override
  State<PersonalProfileContent> createState() => _PersonalProfileContentState();
}

class _PersonalProfileContentState extends State<PersonalProfileContent> {
  @override
  Widget build(BuildContext context) {
    final Playlist playlist;
    const user = fakeuserdata.user0;
    var track1 = faketrackdata.fakeTrack1; //pass in data here
    var track2 = faketrackdata.fakeTrack2;
    var track3 = faketrackdata.fakeTrack3;
    var track4 = faketrackdata.fakeTrack4;
    return Container(
        padding: const EdgeInsets.only(top: 50),
        child: Stack(children: [
          Scaffold(
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // Align(
                //     alignment: Alignment.topRight,
                //     child: Icon(Icons.mic_none_outlined)),
                ProfileWidget(
                  imagePath: user.imagePath,
                  country: "🇺🇸",
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildName(user),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: NumbersWidget(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildAbout(user),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                SectionTitle(
                  title: "Uploads",
                  press: () {},
                  isPlaylist: true,
                ),
                TrackWidget(
                  track: track1,
                ),
                TrackWidget(
                  track: track2,
                ),
                TrackWidget(
                  track: track3,
                ),
                TrackWidget(
                  track: track4,
                ),
              ],
            ),
          ),
          GestureDetector(
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Align(alignment: Alignment.topRight,child: Icon(Icons.mic_none_sharp)),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RecordAudioContent()));
              })
        ]));
  }

  Widget buildName(User user) => Column(
        children: [
          Text(user.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
        ],
      );
  Widget buildAbout(User user) => Column(
        children: [
          Text(user.about,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 12))
        ],
      );
}

class ProfileContent extends StatefulWidget {
  const ProfileContent({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;
  @override
  State<ProfileContent> createState() => _ProfileContentState(user);
}

class _ProfileContentState extends State<ProfileContent> {
  late User myUser;
  _ProfileContentState(User user) {
    myUser = user;
  }

  @override
  Widget build(BuildContext context) {
    final Playlist playlist;
    var track1 = faketrackdata.fakeTrack1; //pass in data here
    var track2 = faketrackdata.fakeTrack2;
    var track3 = faketrackdata.fakeTrack3;
    var track4 = faketrackdata.fakeTrack4;
    return Container(
        child: Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const QawlBackButton(),

          // Align(
          //     alignment: Alignment.topRight,
          //     child: Icon(Icons.mic_none_outlined)),
          ProfileWidget(
            imagePath: myUser.imagePath,
            country: myUser.country,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildName(myUser),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: NumbersWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildAbout(myUser),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
          ),
          SectionTitle(
            title: "Uploads",
            press: () {},
            isPlaylist: true,
          ),
          TrackWidget(
            track: track1,
          ),
          TrackWidget(
            track: track2,
          ),
          TrackWidget(
            track: track3,
          ),
          TrackWidget(
            track: track4,
          ),
        ],
      ),
    ));
  }

  Widget buildName(User user) => Column(
        children: [
          Text(user.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
        ],
      );
  Widget buildAbout(User user) => Column(
        children: [
          Text(user.about,
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 12))
        ],
      );
}
