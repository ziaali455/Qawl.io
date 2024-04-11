import 'package:first_project/model/player.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/widgets/explore_track_widget_block.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/track.dart';

//FIX THE TEXT UPDATING TO GREEN WHEN U TAP IT
class TrackWidget extends StatelessWidget {
  final Track track;
  const TrackWidget({
    Key? key,
    required this.track,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("the user id is " + track.userId);
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: InkWell(
        onTap: () {
          playTrack(track);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NowPlayingContent(playedTrack: track)),
          );
        },
        child: FutureBuilder<QawlUser?>(
          future: QawlUser.getQawlUser(track.userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Placeholder while loading
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final user = snapshot.data;
              if (user != null) {
                return Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(user.imagePath,
                                fit: BoxFit.cover),
                          ),
                        ),
                        selectedTileColor: Colors.green,
                        title: Text(SurahMapper.getSurahNameByNumber(
                            track.surahNumber)),
                        subtitle: Text(user.name),
                      ),
                    ],
                  ),
                );
              } else {
                return Text(
                    'User not found with userID: '); // Handle case where user is null
              }
            }
          },
        ),
      ),
    );
  }

  Widget buildCoverImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Image border
      child: SizedBox.fromSize(
        // Image radius
        child: Image.network(track.coverImagePath, fit: BoxFit.cover),
      ),
    );
  }

  Widget buildTitle(bool isPlaying) {
    Color titleColor;
    if (trackIsPlaying()) {
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

//potentially a better track widget visually?
// Card(
//         child: Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const ListTile(
//           leading: Icon(Icons.album),
//           title: Text('The Enchanted Nightingale'),
//           subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
//         ),
//       ],
//     ));
