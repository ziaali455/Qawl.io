import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/model/user.dart';
import 'package:uuid/uuid.dart';

class Playlist {
  final String author;
  final String name;
  final List<Track> list;
  String coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg";
  String id;

  Playlist(
      {required this.author,
      required this.name,
      required this.list,
      required this.id});

  void addTrack(Track track) {
    list.add(track);
  }

  static Future<void> createPlaylist(Playlist playlist) async {
    try {
      await FirebaseFirestore.instance.collection('QawlPlaylists').add({
        'author': playlist.author,
        'name': playlist.name,
        'userId': playlist.author,
        'tracklist': playlist.list.map((track) => track.id).toList(),
      });
    } catch (error) {
      print("Error creating playlist: $error");
      // Handle error as necessary
    }
  }

  static Future<void> updateFavorites(QawlUser user, Track track) async {
    try {
      // Query Firestore for the "Favorites" playlist of the user
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('QawlPlaylists')
          .where('userId', isEqualTo: user.id)
          .where('name', isEqualTo: 'Favorites')
          .limit(1) // Assuming there's only one "Favorites" playlist per user
          .get();

      // Check if the "Favorites" playlist exists
      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference of the "Favorites" playlist
        DocumentReference playlistRef = querySnapshot.docs.first.reference;

        // Update the tracklist field by adding the track ID
        await playlistRef.update({
          'tracklist': FieldValue.arrayUnion([track.id]),
        });
      } else {
        String uniqueID = Uuid().v4();
        // "Favorites" playlist does not exist, create it
        await FirebaseFirestore.instance.collection('QawlPlaylists').add({
          'name': 'Favorites',
          'id': uniqueID,
          'userId': user.id,
          'tracklist': [track.id],
        });
      }
    } catch (error) {
      print("Error updating favorites: $error");
      // Handle error as necessary
    }
  }

  void removeTrack(Track track) {
    if (!empty()) {
      list.remove(track);
    } else {
      print("you can't remove from an empty list!");
    }
  }

  String getAuthor() {
    return author;
  }

  String getName() {
    return name;
  }
  //String getSurah() {
  //return surah;
  // }

  int getCount() {
    return list.length;
  }

  bool empty() {
    return list.isEmpty;
  }

  static Future<Playlist> getTop100Playlist() async {
    // Fetch top 100 tracks from Firestore and create a Playlist object
    List<Track> topTracks = await fetchTopTracks(); // Implement this method
    return Playlist(
        author: "Top 100", name: "Top 100", id: '0', list: topTracks);
  }

  static Future<Playlist> getNewReleasesPlaylist() async {
    // Fetch new releases from Firestore and create a Playlist object
    List<Track> newReleases = await fetchNewReleases(); // Implement this method
    return Playlist(
        author: "New Releases",
        name: "New Releases",
        id: '0',
        list: newReleases);
  }

  static Future<List<Track>> fetchTopTracks() async {
    try {
      // Query Firestore to get top tracks based on plays count
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('QawlTracks')
          .orderBy('plays',
              descending: true) // Order by plays count in descending order
          .limit(100) // Limit to top 100 tracks
          .get();

      // Map each document snapshot to a Track object
      List<Track> topTracks = querySnapshot.docs.map((doc) {
        return Track.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return topTracks;
    } catch (e) {
      print("Error fetching top tracks: $e");
      return [];
    }
  }

  static Future<List<Track>> fetchNewReleases() async {
    try {
      // Calculate the timestamp for one week ago
      DateTime oneWeekAgo = DateTime.now().subtract(Duration(days: 7));

      // Query Firestore to get new releases published in the last week
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('QawlTracks')
          .where('timeStamp',
              isGreaterThan:
                  oneWeekAgo) // Filter tracks published in the last week
          .orderBy('timeStamp',
              descending: true) // Order by timestamp in descending order
          .limit(100) // Limit to the latest 100 tracks
          .get();

      // Map each document snapshot to a Track object
      List<Track> newReleases = querySnapshot.docs.map((doc) {
        return Track.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return newReleases;
    } catch (e) {
      print("Error fetching new releases: $e");
      return [];
    }
  }

  static Future<Playlist?> getFavorites() async {
    try {
      QawlUser? user = await QawlUser.getCurrentQawlUser();
      if (user != null) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('QawlPlaylists')
            .where('userId', isEqualTo: user.id)
            .where('name', isEqualTo: 'Favorites')
            .limit(1)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot playlistDoc = querySnapshot.docs.first;
          Map<String, dynamic> data =
              playlistDoc.data() as Map<String, dynamic>;
          List<dynamic> trackIds = data['tracklist'] ?? [];
          List<Track> tracks = [];

          // Retrieve Track objects corresponding to trackIds
          for (var trackId in trackIds) {
            DocumentSnapshot trackDoc = await FirebaseFirestore.instance
                .collection('QawlTracks')
                .doc(trackId)
                .get();
            if (trackDoc.exists) {
              dynamic data = trackDoc.data(); // Get the data
              if (data is Map<String, dynamic>) {
                Track track = Track.fromFirestore(data, trackDoc.id);
                tracks.add(track);
              } else {
                // Handle the case where the data is not of type Map<String, dynamic>
                // This could be an error in your data structure or other unexpected scenario
                print('Error: Data is not of type Map<String, dynamic>');
              }
            }
          }

          return Playlist(
            author: data['userId'],
            name: data['name'],
            list: tracks,
            id: playlistDoc.id,
          );
        }
      }
      return null; // Return null if no Favorites playlist found or user is null
    } catch (error) {
      print("Error getting favorites: $error");
      return null; // Handle error as necessary
    }
  }
}
