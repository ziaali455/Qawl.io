import 'package:flutter/material.dart';
import 'package:first_project/neu_box.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/model/faketrackdata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
class NowPlayingContent extends StatefulWidget {
  final Track playedTrack;
  const NowPlayingContent({Key? key, required this.playedTrack})
      : super(key: key);

  @override
  State<NowPlayingContent> createState() =>
      new _NowPlayingContentState(playedTrack);
}

class _NowPlayingContentState extends State<NowPlayingContent> {
  late Track myTrack; //throw exception for null track here!!!!
  _NowPlayingContentState(Track playedTrack) {
    myTrack = playedTrack;
  }

  @override
  Widget build(BuildContext context) {
    bool toggle = myTrack.player.playing == true;
    setState(() {
      // Here we changing the icon.
      toggle = myTrack.player.playing == true;
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // back button and menu button

              GestureDetector(
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                      height: 60,
                      width: 60,
                      child: NeuBox(child: Icon(Icons.arrow_back))),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 25),

              // cover art, artist name, song name
              NeuBox(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(myTrack.coverImagePath),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myTrack.trackName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                //weird idk why it cant be const
                                myTrack.author,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 32,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // start time, shuffle button, repeat button, end time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text('0:00'), //updated duration
                  Icon(Icons.shuffle),
                  Icon(Icons.repeat),
                  Text('4:22') //track length
                ],
              ),

              const SizedBox(height: 30),

              // linear bar
              // NeuBox(
              //   child: LinearPercentIndicator(
              //     lineHeight: 10,
              //     percent: 0.8,
              //     progressColor: Colors.green,
              //     backgroundColor: Colors.transparent,
              //   ),
              // ),
              const ProgressBar(
                progress: Duration.zero,
                total: Duration.zero,
              ),

              const SizedBox(height: 30),

              // previous song, pause play, skip next song
              SizedBox(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: NeuBox(
                          child: Icon(
                        Icons.skip_previous,
                        size: 32,
                      )),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: IconButton(
                            icon: Icon(
                              toggle ? Icons.pause : Icons.play_arrow,
                              size: 32,
                            ),
                            onPressed: () {
                              setState(() {
                                // Here we changing the icon.
                                toggle = myTrack.player.playing == true &&
                                    myTrack.player.processingState ==
                                        ProcessingState.ready;
                              });
                              if (myTrack.player.playing == false &&
                                  myTrack.player.processingState ==
                                      ProcessingState.ready) {
                                myTrack.player.play();
                              } else {
                                myTrack.player.pause();
                              }
                            }),
                      ),
                    ),
                    Expanded(
                      child: NeuBox(
                          child: Icon(
                        Icons.skip_next,
                        size: 32,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


