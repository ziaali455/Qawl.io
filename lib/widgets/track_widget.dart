import 'package:first_project/model/player.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/widgets/explore_track_widget_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/track.dart';

//FIX THE TEXT UPDATING TO GREEN WHEN U TAP IT
class TrackWidget extends StatelessWidget {
  final Track track;
  final bool isPersonal;
  const TrackWidget({
    Key? key,
    required this.track,
    required this.isPersonal,
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
              return const CircularProgressIndicator(); // Placeholder while loading
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final user = snapshot.data;
              if (user != null) {
                return Card(
                  child: Stack(
                    children: [
                      Column(
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
                      if (isPersonal)
                        Positioned(
                          top: 10,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.delete_outline_rounded,
                                color: Colors.green),
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CupertinoAlertDialog(
                                    title: const Text("Confirm Deletion"),
                                    content: const Text(
                                        "Are you sure you want to delete?"),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: const Text("No", style: TextStyle(color: Colors.green),),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text("Yes", style: TextStyle(color: Colors.white),),
                                        onPressed: () {
                                          // Handle delete action here
                                          // For example:
                                          Track.deleteTrack(
                                              track); // Assuming you have a deleteTrack method
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            splashColor: Colors.transparent,
                          ),
                        ),
                    ],
                  ),
                );
              } else {
                return const Text(
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
    if (main_player.playing) {
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
