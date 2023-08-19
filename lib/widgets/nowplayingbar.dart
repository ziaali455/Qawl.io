import 'package:first_project/model/fake_track_data.dart';
import 'package:first_project/model/player.dart';
import 'package:first_project/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../screens/now_playing_content.dart';

class NowPlayingBarWidget extends StatelessWidget {
  const NowPlayingBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool showTrack = false;
    if (trackIsPlaying()) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NowPlayingContent(playedTrack: getCurrentTrack())),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            
            height: 45,
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.green,
                width: 2,
              ),
            ),
            child: Column(children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:5.0),
                  child: Text(
                    getCurrentTrack().trackName,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Text(
                  getCurrentTrack().author,
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ),
        ),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }
}
