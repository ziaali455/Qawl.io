import 'package:first_project/model/fake_playlists_data.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/country_explore_content.dart';
import 'package:first_project/screens/explore_content.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/screens/playlist_screen_content.dart';
import 'package:first_project/widgets/qari_card_widget.dart';
import 'package:flutter/material.dart';

import '../../../../size_config.dart';
import '../constants.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, required this.playlist});
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> categories = [
      {
        "icon": const Icon(
          Icons.place_outlined,
          color: Colors.green,
        ),
        "text": "Nations"
      },
      {
        "icon": const Icon(Icons.trending_up, color: Colors.yellow),
        "text": "Trending"
      },
      {
        "icon":
            const Icon(Icons.local_fire_department_outlined, color: Colors.red),
        "text": "New"
      },
      {
        "icon": const Icon(Icons.supervised_user_circle_rounded,
            color: Colors.purple),
        "text": "Following"
      },
    ];
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index]["icon"],
            text: categories[index]["text"],
            press: () {},
            playlist: playlist,
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Playlist playlist;
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
    required this.playlist,
  }) : super(key: key);

  final Icon? icon;
  final String? text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (text == "Nations") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaceholderContent()),
            //const CountryExploreContent()),
          );
        } else if (text == "Trending") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaceholderContent()),
            //PlaylistScreenContent(playlist: fake_playlist_data.following,)),
          );
        } else if (text == "New") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaceholderContent()),
            //PlaylistScreenContent(playlist: fake_playlist_data.following,)),
          );
        } else if (text == "Following") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FollowingContent()),
            //PlaylistScreenContent(playlist: fake_playlist_data.following,)),
          );
        }
      },
      child: SizedBox(
        width: getProportionateScreenWidth(65),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(0)),
              height: getProportionateScreenWidth(55),
              width: getProportionateScreenWidth(55),
              decoration: BoxDecoration(
                color: kSecondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
            const SizedBox(
              height: 5,
              width: 30,
            ),
            Text(
              text!,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}

class QariCardGrid extends StatefulWidget {
  const QariCardGrid({
    Key? key,
    this.aspectRetio = 1.02,
    required this.category,
  }) : super(key: key);

  final String category;
  final double aspectRetio;

  @override
  State<QariCardGrid> createState() => _QariCardGridState();
}

class _QariCardGridState extends State<QariCardGrid> {
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // If an error occurs
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          // Once data is loaded successfully
          List<QawlUser>? users = snapshot.data;
          if (users != null && users.isNotEmpty) {
            return GridView.count(
              crossAxisCount: 2, // Number of columns
              crossAxisSpacing: 10.0, // Spacing between columns
              mainAxisSpacing: 10.0, // Spacing between rows
              padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(10),
                vertical: getProportionateScreenHeight(20),
              ),
              children: users.map((user) {
                return QariCard(user: user, width: 175,);
              }).toList(),
            );
          } else {
            // If no users are available
            return Center(child: Text('No users available'));
          }
        }
      },
    );
  }
}

class FollowingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        QawlBackButton(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QariCardGrid(category: "Following"),
        ),
      ],
    );
  }
}

class PlaceholderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Stack(
          children: [ Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Coming Soon',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 60),
              Text(
                '😊',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
            ],
          ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: QawlBackButton(),
        ),
        ]),
      ),
    );
  }
}
