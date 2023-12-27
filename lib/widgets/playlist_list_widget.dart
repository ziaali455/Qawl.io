import 'package:first_project/model/fake_playlists_data.dart';
import 'package:first_project/screens/playlist_screen_content.dart';
import 'package:first_project/size_config.dart';
import 'package:flutter/material.dart';

import '../model/playlist.dart';

class PlaylistListWidget extends StatelessWidget {
  final List<Playlist> playlists_List;

  const PlaylistListWidget({
    Key? key,
    required this.playlists_List,
    //required EdgeInsets padding, required List<Widget> children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        PlaylistItem(title: fake_playlist_data.defaultPlaylist.name, playlist: fake_playlist_data.defaultPlaylist,
        ),
         PlaylistItem(title: fake_playlist_data.defaultPlaylist.name, playlist: fake_playlist_data.defaultPlaylist,
        ),
         PlaylistItem(title: fake_playlist_data.defaultPlaylist.name, playlist: fake_playlist_data.defaultPlaylist,
        ),
         PlaylistItem(title: fake_playlist_data.defaultPlaylist.name, playlist: fake_playlist_data.defaultPlaylist,
        ),
       //PlaylistItem(title: "Classics"),
      //  PlaylistItem(title: "Tajweed Practice"),
      ],
    );
  }
}

class PlaylistItem extends StatelessWidget {
  final String title;
  final Playlist playlist;
  String image;
  String noimage =
      "https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg";

  PlaylistItem({
    Key? key,
    required this.title,
    required this.playlist,
    this.image = "",
  }) 
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init;
    return Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaylistScreenContent(
                     // Playlist: playlist,
                      playlist: playlist,
                    )),
          ),
          child: Stack(children: [
            Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(noimage)),
                  selectedTileColor: Colors.green,
                  title: Text(playlist.getName()),
                  subtitle: const Text("Number of plays here"),
                ),
              ],
            )),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.all(getProportionateScreenWidth(27)),
                  child: const Icon(Icons.arrow_forward_ios),
                ))
          ]),
        ));

    // Container(
    //   decoration: BoxDecoration(border: Border.all(color: Colors.wh)),
    //   height: 50,
    //   child: Center(
    //     child: Text(
    //       title,
    //       style: TextStyle(fontSize: getProportionateScreenWidth(15)),
    //     ),
    //   ), // pass in playlist content here
    // );
  }
}