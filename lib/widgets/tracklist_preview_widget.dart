import 'package:first_project/screens/playlist_screen_content.dart';
import 'package:first_project/size_config.dart';
import 'package:flutter/material.dart';

class TrackList extends StatelessWidget {
  const TrackList({
    Key? key,
    //required EdgeInsets padding, required List<Widget> children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 5.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        PlaylistItem(title: "Post-Taraweeh Drive"),
        PlaylistItem(title: "Classics"),
        PlaylistItem(title: "Tajweed Practice"),
      ],
    );
  }
}

class PlaylistItem extends StatelessWidget {
  PlaylistItem({
    Key? key,
    required this.title,
    this.image = "",
    //required this.playlistObject
  }) : super(key: key);
  final String title;
  String image;
  String noimage =
      "https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg";
  //final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init;
    return Padding(
        padding: const EdgeInsets.only(left: 4.0, right: 4.0),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PlaylistScreenContent(playlistTitle: title,)),
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
                  title: Text(title),
                  subtitle: const Text("Number of plays here"),
                ),
              ],
            )),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                       EdgeInsets.all(getProportionateScreenWidth(27)),
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
