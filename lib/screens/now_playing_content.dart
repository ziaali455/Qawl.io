
import 'dart:async';
=======
//NOW PLAYING CONTENT THAT USES AUDIO HANDLER METHODS

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as fba;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/model/audio_handler.dart';
import 'package:first_project/model/player.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/profile_content.dart';
import 'package:first_project/widgets/add_to_library_popup.dart';
import 'package:first_project/widgets/explore_track_widget_block.dart';
import 'package:flutter/material.dart';
import 'package:first_project/neu_box.dart';
import 'package:first_project/model/track.dart';
import 'package:flutter/widgets.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rxdart/rxdart.dart';

class NowPlayingContent extends StatefulWidget {
  final Track playedTrack;
  const NowPlayingContent({Key? key, required this.playedTrack})
      : super(key: key);
  @override
  State<NowPlayingContent> createState() => _NowPlayingContentState();
}

class PositionData {
  const PositionData(this.position, this.bufferedPosition, this.duration);
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;
}

class _NowPlayingContentState extends State<NowPlayingContent> {
  late Track myTrack;
  late AudioPlayer _audioPlayer;

  late StreamSubscription<User?> _authStateChangesSubscription; // used to detect when user signs out


=======

  @override
  void initState() {
    super.initState();
    myTrack = widget.playedTrack;
    _audioPlayer = audioHandler.audioPlayer;
     _authStateChangesSubscription = fba.FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // User has signed out, pause the audio
        _audioPlayer.pause();
      }
    });

  }

  void updateTrack(Track newTrack) {
    setState(() {
      myTrack = newTrack;
    });
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const QawlBackButton(),
          const SizedBox(height: 20),
          CoverContent2(
            audioHandler: audioHandler,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: QawlProgressBar(
                positionDataStream: _positionDataStream,
                audioPlayer: _audioPlayer),
          ),
          const SizedBox(height: 20),
          Controls(
            audioHandler: audioHandler,
            onTrackChange: updateTrack,
          ),
        ],
      ),
    );
  }
}

class CoverContent2 extends StatelessWidget {
  const CoverContent2({
    Key? key,
    required this.audioHandler,
  }) : super(key: key);
  final MyAudioHandler audioHandler;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Track?>(
      valueListenable: audioHandler.currentTrackNotifier,
      builder: (context, myTrack, child) {
        if (myTrack == null) {
          return Text('No track playing');
        } else {
          return Column(
            children: [
              NeuBox(
                child: Column(
                  children: [
// Track image
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            myTrack.coverImagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
// Load default image when loading fails
                              return Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
// Author name
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<String?>(
                        future: myTrack.getAuthor(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Example loading indicator
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      child: Text(
                                        snapshot.data ??
                                            '', // Display author if available
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                      onTap: () async {
                                        String? author = snapshot.data;
                                        if (author != null) {
                                          QawlUser? user =
                                              await QawlUser.getQawlUser(
                                                  myTrack.userId);
                                          if (user != null) {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileContent(
                                                  user: user,
                                                  isPersonal: false,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      SurahMapper.getSurahNameByNumber(
                                          myTrack.surahNumber),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  onPressed: () {
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (context) =>
                                          SingleChildScrollView(
                                        controller:
                                            ModalScrollController.of(context),
                                        child: AddToLibraryWidget(
                                          track: myTrack,
                                        ),
                                      ),
                                    );
                                  },
                                  iconSize: 35,
                                  color: Colors.white,
                                  icon: const Icon(Icons.library_add),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class CoverContent extends StatefulWidget {
  const CoverContent({Key? key}) : super(key: key);
  @override
  _CoverContentState createState() => _CoverContentState();
}

class _CoverContentState extends State<CoverContent> {
  @override
  void initState() {
    super.initState();
// myTrack = widget.myTrack;
  }

  @override
  Widget build(BuildContext context) {
    final Track? myTrack = getCurrentTrack();
    print(
        "The image path displayed on nowplaying is " + myTrack!.coverImagePath);
    return Column(
      children: [
        NeuBox(
            child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(myTrack!.coverImagePath, fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
// Load default image when loading fails
                  return Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/b/b9/No_Cover.jpg',
                    fit: BoxFit.cover,
                  );
                }),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<String?>(
              future: myTrack.getAuthor(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
// Return a loading indicator or placeholder widget
                  return CircularProgressIndicator(); // Example loading indicator
                } else if (snapshot.hasError) {
// Handle error case
                  return Text('Error: ${snapshot.error}');
                } else {
// Data has been retrieved successfully
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            child: Text(
                              snapshot.data ??
                                  '', // Display author if available
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            onTap: () async {
                              String? author = snapshot.data;
                              if (author != null) {
                                QawlUser? user =
                                    await QawlUser.getQawlUser(myTrack.userId);
                                if (user != null) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileContent(
                                        user: user,
                                        isPersonal: false,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          const SizedBox(height: 6),
                          Text(
                            SurahMapper.getSurahNameByNumber(
                                myTrack.surahNumber),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        onPressed: () {
                          showMaterialModalBottomSheet(
                            context: context,
                            builder: (context) => SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: AddToLibraryWidget(
                                track: myTrack,
                              ),
                            ),
                          );
                        },
                        iconSize: 35,
                        color: Colors.white,
                        icon: const Icon(Icons.library_add),
                      ),
                    ],
                  );
                }
              },
            ),
          )
        ])),
      ],
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({
    super.key,
    required this.audioHandler,
    required this.onTrackChange,
  });
  final MyAudioHandler audioHandler;
  final void Function(Track) onTrackChange;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
//prev
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onPressed: () {
            audioHandler.audioPlayer.seekToPrevious();
            onTrackChange(getCurrentTrack());
          },
          iconSize: 60,
          color: Colors.white,
          icon: const Icon(Icons.skip_previous_rounded),
        ),
//play
        StreamBuilder<PlayerState>(
          stream: audioHandler.audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing ?? false;
            if (!playing) {
              return IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: audioHandler.play,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.play_arrow),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onPressed: audioHandler.pause,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white,
            );
          },
        ),
//next
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onPressed: () {
            audioHandler.audioPlayer.seekToNext();
// final nextTrack = // Get next track
            onTrackChange(getCurrentTrack());
          },
          iconSize: 60,
          color: Colors.white,
          icon: const Icon(Icons.skip_next_rounded),
        ),
      ],
    );
  }
}

class QawlBackButton extends StatelessWidget {
  const QawlBackButton({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40.0, left: 8.0),
          child: GestureDetector(
            child: const Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                  height: 40,
                  width: 40,
                  child: NeuBox(child: Icon(Icons.arrow_back))),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}

class QawlProgressBar extends StatelessWidget {
  const QawlProgressBar({
    super.key,
    required Stream<PositionData> positionDataStream,
    required AudioPlayer audioPlayer,
  })  : _positionDataStream = positionDataStream,
        _audioPlayer = audioPlayer;
  final Stream<PositionData> _positionDataStream;
  final AudioPlayer _audioPlayer;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PositionData>(
      stream: _positionDataStream,
      builder: (context, snapshot) {
        final positionData = snapshot.data;
        return ProgressBar(
          barHeight: 8,
          baseBarColor: Colors.white,
          bufferedBarColor: Colors.green,
          progressBarColor: Colors.green,
          thumbColor: Colors.green,
          timeLabelTextStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          progress: positionData?.position ?? Duration.zero,
          buffered: positionData?.bufferedPosition ?? Duration.zero,
          total: positionData?.duration ?? Duration.zero,
          onSeek: _audioPlayer.seek,
        );
      },
    );
  }
}
