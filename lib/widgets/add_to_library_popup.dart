import 'package:first_project/model/playlist.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/model/user.dart';

import 'package:flutter/material.dart';

class AddToLibraryWidget extends StatelessWidget {
  final Track track; // New parameter

  const AddToLibraryWidget({
    Key? key,
    required this.track, // Required parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text(
                'Add to Favorites',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              ),
              leading:
                  const Icon(Icons.favorite, color: Colors.green, size: 30.0),
              onTap: () async {
                QawlUser? user = await QawlUser.getCurrentQawlUser();
                if (user != null) {
                  QawlPlaylist.updateFavorites(user, track);
                } else {
                  print("User null");
                }
                Navigator.pop(context);
              },
            ),
            // ListTile(
            //   title: const Text(
            //     'Add to Playlist..',
            //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            //   ),
            //   leading: const Icon(Icons.playlist_add, color: Colors.green, size: 30.0),
            //   onTap: () async {
            //     Navigator.pop(context);
            //     // Add a small screen to pick a playlist to add to
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
