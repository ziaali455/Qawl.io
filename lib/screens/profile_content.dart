import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/widgets/playlist_preview_widget.dart';
import 'package:first_project/widgets/profile_picture_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/widgets/profile_stats_widget.dart';
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
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
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
  Future<void> _refreshUserData() async {
    setState(() {
      userFuture = _loadUserData();
    });
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
          return RefreshIndicator(
            onRefresh: _refreshUserData,
            child: _buildContent(user),
          );
        }
      },
    );
  }

  @override
  Widget _buildContent(QawlUser user) {
    final bool isPersonal = widget.isPersonal;
    List<Track> myList = [];
    Playlist uploadPlaylist =
        new Playlist(author: user.name, name: "Uploads", list: myList);

    Future<void> fetchAndAddTracks() async {
      for (var trackId in user.uploads) {
        Track? res = await Track.getQawlTrack(trackId);
        if (res != null) {
          myList.add(res);
        } else {
          // Handle the case where the track is null (not found)
          print('Track with ID $trackId not found.');
        }
      }
    }

    // Call the asynchronous method
    fetchAndAddTracks();

    return Container(
      padding: const EdgeInsets.only(top: 50),
      child: Stack(
        children: [
          Scaffold(
            body: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (!isPersonal) const QawlBackButton(),
                ProfilePictureWidget(
                    imagePath: user.imagePath,
                    country: user.country,
                    isPersonal: isPersonal,
                    user: user,
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
                IconButton(onPressed: (){if (isPersonal) {
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
                    }}, icon: Icon(Icons.settings)),
                if (!isPersonal)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<Widget>(
                      future: buildPersonalAbout(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return snapshot.data ?? Container();
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
                PlaylistPreviewWidget(playlist: uploadPlaylist)
              ],
            ),
            floatingActionButton: isPersonal ? const QawlRecordButton() : null,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          ),
        ],
      ),
    );
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

  displayUserUploads() {}
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
