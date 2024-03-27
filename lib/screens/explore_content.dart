import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/model/fake_playlists_data.dart';
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
  Future<Playlist>? _top100PlaylistFuture;
  Future<Playlist>? _newReleasesPlaylistFuture;

  @override
  void initState() {
    super.initState();
    _top100PlaylistFuture = Playlist.getTop100Playlist();
    _newReleasesPlaylistFuture = Playlist.getNewReleasesPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenWidth;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SearchField(),
            Categories(playlist: fake_playlist_data.defaultPlaylist,),
            FutureBuilder<Playlist>(
              future: _top100PlaylistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Show loading indicator
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
            FutureBuilder<Playlist>(
              future: _newReleasesPlaylistFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // Show loading indicator
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
            QariCardRow(
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
    _futureUsers = getTopThreeUsersByFollowers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<QawlUser>>(
      future: _futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is loading
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If an error occurs
          return Text('Error: ${snapshot.error}');
        } else {
          // Once data is loaded successfully
          List<QawlUser>? firstThreeUsers = snapshot.data;
          if (firstThreeUsers != null && firstThreeUsers.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(0)),
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
            return Text('No users available');
          }
        }
      },
    );
  }
}

Future<List<QawlUser>> getTopThreeUsersByFollowers() async {
  List<QawlUser> topThreeUsers = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('QawlUsers')
        .orderBy('followers', descending: true) // Order by followers in descending order
        .limit(3) // Limit the query to return only 3 documents
        .get();

    querySnapshot.docs.forEach((doc) {
      QawlUser user = QawlUser.fromFirestore(doc);
      topThreeUsers.add(user);
    });
  } catch (e) {
    print("Error getting top three users by followers: $e");
  }

  return topThreeUsers;
}