import 'package:first_project/model/fake_playlists_data.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/screens/country_explore_content.dart';
import 'package:first_project/screens/playlist_screen_content.dart';
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
        "icon": const Icon(Icons.local_fire_department_outlined, color: Colors.red),
        "text": "New"
      },
      {
        "icon":
            const Icon(Icons.supervised_user_circle_rounded, color: Colors.purple),
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
            press: () {}, playlist: playlist,
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
            MaterialPageRoute(builder: (context) => const CountryExploreContent()),
          );
        }else if (text == "Trending"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaylistScreenContent(playlist: fake_playlist_data.trending,)),
          );
        }else if (text == "New"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaylistScreenContent(playlist: fake_playlist_data.newReleases,)),
          );
        }
        else if (text == "Following"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaylistScreenContent(playlist: fake_playlist_data.following,)),
          );
        }
        else if (text == "Following"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlaylistScreenContent(playlist: fake_playlist_data.following,)),
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
