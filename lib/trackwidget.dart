import 'package:first_project/nowplayingcontent.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/model/faketrackdata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:line_icons/line_icons.dart';

//FIX THE TEXT UPDATING TO GREEN WHEN U TAP IT
class TrackWidget extends StatelessWidget {
  final Track track;
  TrackWidget({
    Key? key,
    required this.track,
  }) : super(key: key);

  Widget build(BuildContext context) {
    int count = 0;
    bool isPlaying = false;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          count++;
          if(count == 0){
            if((track.player.playing == false && track.player.processingState == ProcessingState.ready) || (track.player.playing == true )){ // && ProcessingState.completed???
              isPlaying = true;
              track.player.play();
            }else{
              isPlaying = false;
              track.player.pause();
            }
          }
          // print("the count is $count");
          // var snackBar = SnackBar(content: Text('Now Playing ' + track.trackName));
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // buildTitle(isPlaying);
          // track.playTrack(count);
          // if (count % 2 == 0) {
          //   isPlaying = false;
          //   buildTitle(isPlaying);
          // }
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NowPlayingContent(playedTrack: faketrackdata.fakeTrack)),
          );
        },
        child: Container(
            child: Row(
          children: [buildCoverImage(), buildTitle(isPlaying)],
        )),
      ),
    );
  }

  Widget buildCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Image border
      child: SizedBox.fromSize(
        size: Size.fromRadius(30), // Image radius
        child: Image.network(track.coverImagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget buildTitle(bool isPlaying) {
    Color titleColor;
    if (isPlaying) {
      titleColor = Colors.green;
    } else {
      titleColor = Colors.white;
    }
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 8.0, top: 8.0, bottom: 8.0),
      child: Text(
        track.trackName,
        style: TextStyle(fontSize: 20, color: titleColor),
      ),
    );
  }

  //boolean input not count
}
