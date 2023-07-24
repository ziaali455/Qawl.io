 import 'package:first_project/model/fake_track_data.dart';
import 'package:first_project/size_config.dart';
import 'package:flutter/material.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          color: Colors.blueGrey,
          width: SizeConfig.screenWidth,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(faketrackdata.defaultTrack.coverImagePath, fit: BoxFit.cover),
              Text(
                faketrackdata.defaultTrack.trackName,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              IconButton(
                  onPressed: () async { },
                  icon: const Icon(Icons.pause, color: Colors.white)
              )
            ],
          ),
        ),
      ),
    );
  }}