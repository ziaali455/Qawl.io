import 'package:first_project/model/fake_track_data.dart';
import 'package:first_project/model/player.dart';
import 'package:flutter/material.dart';

import '../../../../size_config.dart';
import '../model/playlist.dart';
import '../model/track.dart';
import '../screens/now_playing_content.dart';
import 'section_title_widget.dart';

class ExploreTrackWidgetRow extends StatelessWidget {
  const ExploreTrackWidgetRow({
    Key? key,
    required this.title,
    required this.playlist,
  }) : super(key: key);
  final String title;
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    List<TrackCard> tracks = new List.empty(growable: true);
    for (var track in playlist.list) {
      tracks.add(new TrackCard(
        image: track.coverImagePath,
        title: track.trackName,
        author: track.userId,
        track:track,
        press: () {},
      ));
    }
    for (var track in playlist.list) {
      TrackCard(
        image: track.coverImagePath,
        title: track.trackName,
        author: track.userId,
        track: track,
        press: () {},
      );
    }
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          child: PlaylistSectionTitle(
            title: title,
            isPlaylist: true,
            playlist: playlist,
            press: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: tracks
        
              ),
        ),
      ],
    );
  }
}

class TrackCard extends StatelessWidget {
  const TrackCard({
    Key? key,
    required this.track, 
    required this.title,
    required this.image,
    required this.press,
    required this.author,
  }) : super(key: key);

  final String title, image, author;
  final Track track;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      child: GestureDetector(
        onTap: () {
          playTrack(faketrackdata.defaultTrack);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NowPlayingContent(playedTrack: track)),
          );
        },
        child: SizedBox(
          width: getProportionateScreenWidth(150),
          height: getProportionateScreenWidth(150),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(.0),
                        Colors.black.withOpacity(.8),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10.0),
                      vertical: getProportionateScreenWidth(10),
                    ),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "$author\n",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
