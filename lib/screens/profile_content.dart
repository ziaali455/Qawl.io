import 'package:first_project/model/fake_user_data.dart';
import 'package:first_project/widgets/tracklist_preview_widget.dart';
import 'package:first_project/widgets/profile_picture_widget.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:first_project/widgets/track_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/widgets/profile_stats_widget.dart';
import 'package:first_project/model/fake_track_data.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({Key? key, }) : super(key: key);
  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  @override
  Widget build(BuildContext context) {
    const user = fakeuserdata.user0;
    var track1 = faketrackdata.fakeTrack1; //pass in data here
    var track2 = faketrackdata.fakeTrack2;
    var track3 = faketrackdata.fakeTrack3;
    var track4 = faketrackdata.fakeTrack4;
    return Container(
        padding: const EdgeInsets.only(top: 50),
        child: Scaffold(
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
              SectionTitle(title: "Uploads", press: () {}),
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
              SectionTitle(title: "Playlists", press: () {}),
              const TrackList(),
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
              style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12))
        ],
      );
}
