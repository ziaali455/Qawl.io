import 'package:first_project/model/playlist.dart';
import 'package:flutter/material.dart';
import '../screens/playlist_screen_content.dart';

class PlaylistButtonWidget extends StatelessWidget {
//  final String title;
  final Playlist playlist;
  const PlaylistButtonWidget({
    Key? key,
    required this.playlist,
 //   required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlaylistScreenContent(
                    //  Playlist: playlist,
                    playlist: playlist,
                  )),
        );
      },
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.green,
        ),
        child: Center(
            child: Text(playlist.getName(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 24))),
      ),
    );
  }
}
