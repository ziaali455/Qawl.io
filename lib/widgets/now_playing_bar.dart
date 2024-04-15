import 'package:first_project/model/player.dart';
import 'package:first_project/widgets/explore_track_widget_block.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../screens/now_playing_content.dart';

class NowPlayingBarWidget extends StatelessWidget {
  const NowPlayingBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loaded = main_player.processingState == ProcessingState.ready ||
        main_player.processingState == ProcessingState.completed ||
        main_player.processingState == ProcessingState.buffering;
    if (loaded) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  NowPlayingContent(playedTrack: getCurrentTrack()),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder<String?>(
            future: getCurrentTrack().getAuthor(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Show loading indicator while waiting for data
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(
                        color: Colors.green,
                        width: 2, // Increased border width
                      ),
                      borderRadius: BorderRadius.circular(10), // Rounded border
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  SurahMapper.getSurahNameByNumber(getCurrentTrack().surahNumber),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  snapshot.data ?? '',
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 0,
                          bottom: 0,
                          child: Opacity(
                            opacity: main_player.playing ? 1.0 : 0.0,
                            child: SoundWaveformWidget(),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
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


class SoundWaveformWidget extends StatefulWidget {
  final int count;
  final double minHeight;
  final double maxHeight;
  final int durationInMilliseconds;
  const SoundWaveformWidget({
    Key? key,
    this.count = 3,
    this.minHeight = 5,
    this.maxHeight = 10,
    this.durationInMilliseconds = 500,
  }) : super(key: key);
  @override
  State<SoundWaveformWidget> createState() => _SoundWaveformWidgetState();
}

class _SoundWaveformWidgetState extends State<SoundWaveformWidget>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.durationInMilliseconds,
        ))
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.count;
    final minHeight = widget.minHeight;
    final maxHeight = widget.maxHeight;
    return AnimatedBuilder(
      animation: controller,
      builder: (c, child) {
        double t = controller.value;
        int current = (count * t).floor();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            count,
            (i) => AnimatedContainer(
              duration: Duration(
                  milliseconds: widget.durationInMilliseconds ~/ count),
              margin: i == (count - 1)
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(right: 5),
              height: i == current ? maxHeight : minHeight,
              width: 5,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
        );
      },
    );
  }
}
