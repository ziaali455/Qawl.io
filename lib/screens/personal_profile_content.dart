import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:first_project/model/fake_playlists_data.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/screens/profile_content_DEPRECATED.dart';

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
import '../screens/taken_from_firebaseui/profile_screen_firebaseui.dart';
import 'package:flutter/material.dart' hide ModalBottomSheetRoute;

class ProfileContent extends StatefulWidget {
  final bool isPersonal;
  QawlUser? user;
  ProfileContent({
    required this.isPersonal,
    this.user,
    Key? key,
  }) : super(key: key);
  @override
  State<ProfileContent> createState() => _PersonalProfileContentState();
}

class _PersonalProfileContentState extends State<ProfileContent> {
  late Future<QawlUser?> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _loadUserData();
  }

  static Future<QawlUser?> getQawlUserOrCurr(bool isPersonal,
      {QawlUser? user}) async {
    if (isPersonal) {
      final currentUserUid = QawlUser.getCurrentUserUid();
      if (currentUserUid != null) {
        final doc = await FirebaseFirestore.instance
            .collection('QawlUsers')
            .doc(currentUserUid)
            .get();
        if (doc.exists) {
          return QawlUser.fromFirestore(doc);
        }
      }
    } else {
      return user;
    }
    return null; // Return null if user not found or isPersonal is true but no user is logged in
  }

  Future<QawlUser?> _loadUserData() async {
    if (widget.isPersonal) {
      return getQawlUserOrCurr(true);
    } else {
      return widget.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QawlUser?>(
      future: userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error!: ${snapshot.error}'));
        } else {
          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('No user found'));
          }
          return _buildContent(user);
        }
      },
    );
  }

  @override
  Widget _buildContent(QawlUser user) {
    final bool isPersonal = widget.isPersonal;
    final Playlist playlist;

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
                if(!isPersonal)
                  const QawlBackButton(),
                GestureDetector(
                  child: ProfilePictureWidget(
                    imagePath: user.imagePath,
                    country: user.country,
                    isPersonal: isPersonal,
                    user: user,
                  ),
                  onTap: () {
                    if (isPersonal) {
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
                    }
                  },
                ),
                const SizedBox(height: 24),
                if (isPersonal)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildPersonalName(),
                  ),
                if (!isPersonal)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: buildName(user),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: NumbersWidget(
                    user: user,
                  ),
                ),
                if (isPersonal)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<Widget>(
                      future: buildPersonalAbout(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Placeholder while loading
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error: ${snapshot.error}'); // Display error if any
                        } else {
                          return snapshot.data ??
                              Container(); // Return the widget when future completes
                        }
                      },
                    ),
                  ),
                if (!isPersonal)
                  Padding(
                    padding: const EdgeInsets.only(top: 11.0),
                    child: buildAbout(user),
                  ),
                if (!isPersonal)
                  Padding(
                    padding: const EdgeInsets.only(top: 11.0),
                    child: FollowButton(
                      user: user,
                    ),
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
            floatingActionButton: const QawlRecordButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ]));
  }

  Widget buildPersonalName() {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    String displayedUsername = " ";
    if (firebaseUser != null) {
      displayedUsername = firebaseUser.displayName!;
    } else {
      displayedUsername = "no name";
    }

    QawlUser.updateUserField(firebaseUser!.uid, "name", displayedUsername);
    return Column(
      children: [
        Text(displayedUsername,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
      ],
    );
  }

  Widget buildName(QawlUser user) {
    return Column(
      children: [
        Text(user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
      ],
    );
  }

  Future<Widget> buildPersonalAbout() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    String? about = await QawlUser.getAbout(firebaseUser!.uid);
    if (about == null) {
      about = "No about";
    }

    return Column(
      children: [
        Text(about,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15))
      ],
    );
  }

  Widget buildAbout(QawlUser user) {
    return Column(
      children: [
        Text(user.about,
            style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 15))
      ],
    );
  }
}

class FollowButton extends StatefulWidget {
  const FollowButton({
    super.key,
    required this.user,
  });
  final QawlUser user;

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
                      ? const Text(
                          "Unfollow",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        )
                      : const Text(
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
          decoration: const BoxDecoration(
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
                  child: const UploadPopupWidget(),
                ),
              );
            },
            tooltip: 'Enter the record page',
            child: const Icon(
              Icons.add,
              size: 35,
            ),
          ),
        ),
      ),
    );
  }
}
