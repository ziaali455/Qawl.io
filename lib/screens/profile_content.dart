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
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:first_project/widgets/upload_popup_widget.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

import 'now_playing_content.dart';
class QawlRecordButton extends StatelessWidget {
  const QawlRecordButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        width: 60,
        height: 60,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromARGB(255, 13, 161, 99),
                Color.fromARGB(255, 22, 181, 93),
                Color.fromARGB(255, 32, 220, 85),
              ],
            ),
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            splashColor: Colors.white,
            onPressed: () {
              showMaterialModalBottomSheet(
                context: context,
                builder: (context) => SingleChildScrollView(
                  controller: ModalScrollController.of(context),
                  child: UploadPopupWidget(),
                ),
              );
             
            },
            tooltip: 'Enter the record page',
            child: Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }
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
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 15))
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
                  child: following
                      ? Text(
                          "Unfollow",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Follow",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
