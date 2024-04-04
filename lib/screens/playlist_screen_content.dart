import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/size_config.dart';
import 'package:first_project/widgets/track_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/fake_track_data.dart';

import '../neu_box.dart';

class PlaylistScreenContent extends StatefulWidget {
  //final String playlistTitle;
  final Playlist playlist;

  //refactor playlistTitle

  const PlaylistScreenContent({Key? key, required this.playlist})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<PlaylistScreenContent> createState() =>
      _PlaylistScreenContentState(playlist);
}

class _PlaylistScreenContentState extends State<PlaylistScreenContent> {
  late Playlist playlist;
  _PlaylistScreenContentState(Playlist playlist) {
    this.playlist = playlist;
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            // back button and menu button
            const SizedBox(height: 50),
            QawlBackButton(),
            
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  playlist.getName(),
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            //insert for loop that goes through playlist parameter and populates track widgets HERE.
            for (Track track in playlist.list)
              Material(
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TrackWidget(track: track),
                ),
              ),
          ]),
        ),
      ),
    );
  }
}
