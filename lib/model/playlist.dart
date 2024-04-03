
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/model/track.dart';

class Playlist {
  final String author;
  final String name;
  int trackCount;
//  final String surah;
  final List<Track> list;
  String coverImagePath = "https://www.linkpicture.com/q/no_cover_1.jpg";
  // String id;

  Playlist(
      {required this.author,
      required this.name,
      this.trackCount = 0,
    //  required this.surah,
      required this.list,
      // required this.id
      });

  void addTrack(Track track) {
    list.add(track);
    trackCount++;
  }

  void removeTrack(Track track) {
    if (!empty()) {
      list.remove(track);
      trackCount--;
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
    return Playlist(author: "Top 100", name: "Top 100", list: topTracks);
  }

  static Future<Playlist> getNewReleasesPlaylist() async {
    // Fetch new releases from Firestore and create a Playlist object
    List<Track> newReleases = await fetchNewReleases(); // Implement this method
    return Playlist(author: "New Releases", name: "New Releases", list: newReleases);
  }
static Future<List<Track>> fetchTopTracks() async {
    try {
      // Query Firestore to get top tracks based on plays count
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('QawlTracks')
          .orderBy('plays', descending: true) // Order by plays count in descending order
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
          .where('timeStamp', isGreaterThan: oneWeekAgo) // Filter tracks published in the last week
          .orderBy('timeStamp', descending: true) // Order by timestamp in descending order
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
}
