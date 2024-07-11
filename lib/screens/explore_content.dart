import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/widgets/search_field.dart';
import 'package:first_project/widgets/explore_track_widget_block.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/fake_user_data.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/size_config.dart';

import '../widgets/categories_widget.dart';
import '../widgets/qari_card_widget.dart';

class ExploreContent extends StatefulWidget {
  //  final Playlist playlist;
  const ExploreContent({Key? key}) : super(key: key);
  @override
  State<ExploreContent> createState() => _ExploreContentState();
}

class _ExploreContentState extends State<ExploreContent> {
  Future<QawlPlaylist>? _top100PlaylistFuture;
  Future<QawlPlaylist>? _newReleasesPlaylistFuture;

  @override
  void initState() {
    super.initState();
    _top100PlaylistFuture = QawlPlaylist.getTop100Playlist();
    _newReleasesPlaylistFuture = QawlPlaylist.getNewReleasesPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenWidth;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // const SearchField(),
            Categories(
              playlist:
                  QawlPlaylist(author: 'na', name: 'na', list: [], id: '0'),
            ),
            FutureBuilder<QawlPlaylist>(
              future: _top100PlaylistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.green); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error message
                } else {
                  return ExploreTrackWidgetRow(
                    title: "Top 100",
                    playlist: snapshot.data!,
                  );
                }
              },
            ),
            FutureBuilder<QawlPlaylist>(
              future: _newReleasesPlaylistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(color: Colors.green); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}'); // Show error message
                } else {
                  return ExploreTrackWidgetRow(
                    title: "New Releases",
                    playlist: snapshot.data!,
                  );
                }
              },
            ),
            SectionTitle(
              title: "Popular Qaris",
              press: () {},
            ),
            const QariCardRow(
              category: 'Featured',
            ),
          ],
        ),
      ),
    );
  }
}

class QariCardRow extends StatefulWidget {
  const QariCardRow({
    Key? key,
    this.width = 175,
    this.aspectRetio = 1.02,
    required this.category,
  }) : super(key: key);

  final String category;
  final double width, aspectRetio;

  @override
  State<QariCardRow> createState() => _QariCardRowState();
}

class _QariCardRowState extends State<QariCardRow> {
  late Future<List<QawlUser>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = getTopUsersByFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QawlUser>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is loading
          return const CircularProgressIndicator(color: Colors.green);
        } else if (snapshot.hasError) {
          // If an error occurs
          return Text('Error: ${snapshot.error}');
        } else {
          // Once data is loaded successfully
          List<QawlUser>? firstThreeUsers = snapshot.data;
          if (firstThreeUsers != null && firstThreeUsers.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(0)),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: firstThreeUsers.map((user) {
                    return QariCard(width: widget.width, user: user);
                  }).toList(),
                ),
              ),
            );
          } else {
            // If no users are available
            return const Text('No users available');
          }
        }
      },
    );
  }
}

Future<List<QawlUser>> getTopUsersByFollowers() async {
  List<QawlUser> topThreeUsers = [];

  try {
    QawlUser? currUser = await QawlUser.getCurrentQawlUser(); // Await here

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('QawlUsers')
        .orderBy('followers', descending: true)
        .limit(5)
        .get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      QawlUser user = QawlUser.fromFirestore(doc);
      if (currUser != null && user.id != currUser.id) {
        topThreeUsers.add(user);
      }
    }
  } catch (e) {
    print("Error getting top three users by followers: $e");
  }

  return topThreeUsers;
}
