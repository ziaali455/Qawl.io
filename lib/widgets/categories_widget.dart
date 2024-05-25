import 'package:cloud_firestore/cloud_firestore.dart';
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
  final QawlPlaylist playlist;

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
  final QawlPlaylist playlist;
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
            MaterialPageRoute(builder: (context) => const FollowingContent()),
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

Future<List<QawlUser>> getFollowingUsers() async {
    QawlUser? currentUser = await QawlUser.getCurrentQawlUser();
    List<QawlUser> followingUsers = [];

    if (currentUser != null) {
      List<String> followingUserIds = currentUser.following.toList();

      // Iterate over each userId in the following list
      for (String userId in followingUserIds) {
        // Skip adding the currentUser's id to the list of following users
        if (userId == currentUser.id) {
          continue;
        }

        // Query Firestore to get the QawlUser with the current userId
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('QawlUsers')
            .doc(userId)
            .get();

        // If the document exists, convert it to a QawlUser object and add it to the list
        if (userSnapshot.exists) {
          QawlUser user = QawlUser.fromFirestore(userSnapshot);
          followingUsers.add(user);
        }
      }
    }

    return followingUsers;
  }
class FollowingContent extends StatelessWidget {
  const FollowingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
      ),
      body: FutureBuilder<List<QawlUser>>(
        future: getFollowingUsers(), // Your method to fetch following Qaris
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<QawlUser>? users = snapshot.data;
            if (users != null && users.isNotEmpty) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 80.0,
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return QariCard(
                    user: users[index],
                    width: MediaQuery.of(context).size.width / 2 - 20, // Adjust width
                  );
                },
              );
            } else {
              return const Center(child: Text('No Qaris available'));
            }
          }
        },
      ),
    );
  }
}

class PlaceholderContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Column(
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
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: QawlBackButton(),
          ),
        ]),
      ),
    );
  }
}
