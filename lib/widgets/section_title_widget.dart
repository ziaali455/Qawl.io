import 'package:first_project/model/fake_playlists_data.dart';
import 'package:first_project/model/fake_user_data.dart';
import 'package:flutter/material.dart';

import '../../../../size_config.dart';
import '../model/playlist.dart';
import '../model/user.dart';

class SectionTitle extends StatelessWidget {
  SectionTitle({
    Key? key,
    required this.title,
    required this.press,
    this.playlist,
    this.qaris,
    required this.isPlaylist,
  }) : super(key: key);

  final String title;
  Playlist? playlist = fake_playlist_data.defaultPlaylist;
  List<User>? qaris = [fakeuserdata.user0, fakeuserdata.user1];
  final GestureTapCallback press;
  final bool isPlaylist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: () {
              if(isPlaylist){
                //do this
              }else{
                //do that
              }
            },
            child: Text(
              "See More",
              style: TextStyle(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  fontSize: getProportionateScreenWidth(15)),
            ),
          ),
        ],
      ),
    );
  }
}
