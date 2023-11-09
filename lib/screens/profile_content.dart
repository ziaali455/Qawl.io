import 'package:first_project/model/fake_playlists_data.dart';
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
    User user = fakeuserdata.user0;
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
                ProfilePictureWidget(
                  imagePath: user.imagePath,
                  country: "🇺🇸",
                  onClicked: () async {},
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildName(user),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: NumbersWidget(
                    user: user,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: buildAbout(user),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                PlaylistSectionTitle(
                  title: "Uploads",
                  press: () {},
                  isPlaylist: true,
                  playlist: fake_playlist_data.defaultPlaylist,
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
            floatingActionButton: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: 60,
                height: 60,
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  splashColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordAudioContent(),
                        ));
                  },
                  tooltip: 'Enter the record page',
                  child: Icon(
                    Icons.mic_none_rounded,
                    size: 35,
                  ),
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
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
          ProfilePictureWidget(
            imagePath: myUser.imagePath,
            country: myUser.country,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildName(myUser),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: NumbersWidget(
              user: myUser,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: buildAbout(myUser),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 11.0),
            child: FollowButton(
              user: myUser,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
          ),
          PlaylistSectionTitle(
            title: "Uploads",
            press: () {},
            playlist: fake_playlist_data.defaultPlaylist,
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

class FollowButton extends StatefulWidget {
  const FollowButton({
    super.key,
    required this.user,
  });
  final User user;

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool following = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 120.0, right: 120.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 13, 161, 99),
                      Color.fromARGB(255, 22, 181, 93),
                      Color.fromARGB(255, 32, 220, 85),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(2.0),
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () {
                setState(() {
                  following = !following;
                  widget.user.followers++;
                });
              },
              child: Align(
                  alignment: Alignment.center,
                  child: following ? Text("Unfollow") : Text("Follow")),
            ),
          ],
        ),
      ),
    );
  }
}
