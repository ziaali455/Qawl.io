import 'package:first_project/model/faketrackdata.dart';
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
      padding: EdgeInsets.only(top: 5.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
  String image = faketrackdata.fakeTrack1.coverImagePath;
  //final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: ListTile(
        splashColor: Colors.transparent,
        leading: Image.network(faketrackdata.defaultTrack.coverImagePath),
        title: Text(title),
        onTap: () {
          // TODO: play this audio when tapped.
        },
      ),
    );

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
