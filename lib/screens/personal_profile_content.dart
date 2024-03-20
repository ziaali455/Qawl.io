import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:first_project/model/fake_playlists_data.dart';
import 'package:first_project/model/fake_user_data.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/screens/profile_content.dart';
import 'package:first_project/screens/record_audio_content.dart';
import 'package:first_project/widgets/profile_picture_widget.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:first_project/widgets/track_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/widgets/profile_stats_widget.dart';
import 'package:first_project/model/fake_track_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:first_project/widgets/upload_popup_widget.dart';
import '../firebase_options.dart';
import '../screens/taken_from_firebaseui/profile_screen_firebaseui.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;
import '../model/user.dart';

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
    QawlUser user = fakeuserdata.user0;
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
                GestureDetector(
                  child: ProfilePictureWidget(
                    imagePath: user.imagePath,
                    country: user.country,
                    onClicked: () {
                      //testing
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<MyProfileScreen>(
                        builder: (context) => MyProfileScreen(
                          actions: [
                            SignedOutAction((context) {
                              Navigator.of(context).pop();
                            })
                          ],
                        ),
                      ),
                    );
                  },
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
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: buildAbout(user),
                // ),
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
            floatingActionButton: QawlRecordButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ]));
  }

  Widget buildName(QawlUser user) {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    String displayedUsername = firebaseUser != null
        ? firebaseUser.displayName ?? "No Name"
        : "No Name";

    return Column(
      children: [
        Text(displayedUsername,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
      ],
    );
  }

  Future<Widget> buildAbout(QawlUser user) async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    String? about = await QawlUser.getAbout(firebaseUser!.uid);
    if(about==null){
      about = "No about";
    }

    return Column(
      children: [
        Text(about,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15))
      ],
    );
  }
}