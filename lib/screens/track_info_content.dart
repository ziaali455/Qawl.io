import 'package:flutter/material.dart';
import 'package:first_project/model/track.dart';

class TrackInfoContent extends StatefulWidget {
  final String trackPath;

  TrackInfoContent({Key? key, required this.trackPath}) : super(key: key);

  @override
  State<TrackInfoContent> createState() => _TrackInfoContentState(trackPath);
}

class _TrackInfoContentState extends State<TrackInfoContent> {
  String trackPath = "";
  _TrackInfoContentState(String path) {
    trackPath = path;
  }
  
  @override
  Widget build(BuildContext context) {
    Track createdTrack = new Track(
      userId: "null",
      id: "null",
      inPlaylists: new Set(),
      trackName: "null",
      plays: 0,
      surahNumber: 0,
      audioPath: trackPath);
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrackInfoField(header: 'Track Name', value: createdTrack.trackName),
            TrackInfoField(
              header: 'Surah Number',
              value: createdTrack.surahNumber.toString(),
            ),
            // Add more fields as needed
    
            // Example for InPlaylists - assuming you want to display the names of playlists
          ],
        ),
      ),
    );
  }
}

class TrackInfoField extends StatelessWidget {
  final String header;
  final String value;

  const TrackInfoField({Key? key, required this.header, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        Divider(),
      ],
    );
  }
}
