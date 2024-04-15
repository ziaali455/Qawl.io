import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:first_project/widgets/track_widget.dart';
import 'package:flutter/material.dart';

class PlaylistPreviewWidget extends StatelessWidget {
  final Playlist playlist;
  final bool isPersonal;
  const PlaylistPreviewWidget({
    Key? key,
    required this.playlist,
    required this.isPersonal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get a maximum of four tracks from the playlist
    List<Track> tracks = playlist.list.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        PlaylistSectionTitle(
          title: playlist.name,
          press: () {}, // Add your desired action here
          isPlaylist: true,
          playlist: playlist,
        ),
        // Track widgets
        ...tracks
            .map((track) => TrackWidget(
                  track: track,
                  isPersonal: isPersonal,
                ))
            .toList(),
      ],
    );
  }
}
