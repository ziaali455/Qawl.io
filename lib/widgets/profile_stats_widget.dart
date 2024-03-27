import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/screens/profile_content_DEPRECATED.dart';
import 'package:flutter/material.dart';


class NumbersWidget extends StatelessWidget {
  final QawlUser user;

  const NumbersWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildButton(context, user.followers.toString(), 'Followers'),
          ],
        ),
      ],
    );
  }

  Future<int> fetchFollowersCount(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('QawlUsers')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final followers = userDoc.get('followers');
        return followers as int? ?? 0;
      } else {
        return 0; // Return 0 if the document doesn't exist
      }
    } catch (e) {
      print("Error fetching followers count: $e");
      return 0; // Return 0 in case of an error
    }
  }

  buildButton(BuildContext context, String rank, String label) {
    return FutureBuilder<int>(
      future: fetchFollowersCount(user.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Display a loading indicator while fetching data
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error state
          return Text('Error: ${snapshot.error}');
        } else {
          // Data fetched successfully, display the followers count
          final followers = snapshot.data ?? 0;
          return Column(
            children: [
              MaterialButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('$followers',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    const SizedBox(height: 2),
                    Text('$label',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10)),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}

class FollowButton extends StatefulWidget {
  const FollowButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  final QawlUser user;

  @override
  State<FollowButton> createState() => _FollowButtonState();
  
}

class _FollowButtonState extends State<FollowButton> {
  bool following = false;
  int followerCount = 0; // Add a local variable to keep track of follower count

 @override
  void initState() {
    super.initState();
    // Initialize the follower count
    followerCount = widget.user.followers;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 120.0, right: 120.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 13, 161, 99),
                      Color.fromARGB(255, 22, 181, 93),
                      Color.fromARGB(255, 32, 220, 85),
                    ],
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(2.0),
                textStyle: const TextStyle(fontSize: 15),
              ),
              onPressed: () {
                setState(() {
                  // Toggle the following state
                  following = !following;
                  // Update the follower count based on the follow/unfollow action
                  followerCount = following ? followerCount + 1 : followerCount - 1;
                  // Update follower count in the database only if following
                    updateUserFollowerCount(widget.user.id, followerCount);
                });
              },
              child: Align(
                alignment: Alignment.center,
                child: following
                    ? const Text(
                        "Unfollow",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Text(
                        "Follow",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateUserFollowerCount(String userId, int followerCount) async {
    try {
      await FirebaseFirestore.instance
          .collection('QawlUsers')
          .doc(userId)
          .update({'followers': followerCount});
    } catch (e) {
      print("Error updating follower count: $e");
      // Handle error
    }
  }
}


// class NumbersWidget extends StatelessWidget {
//   final QawlUser user;
//   const NumbersWidget({super.key, required this.user});

//   @override
//   Widget build(BuildContext context) => Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               // buildButton(context, '4', 'Uploads'),
//               // buildButton(context, '#3', 'Ranking'),
//               buildButton(context, user.followers.toString(), 'Followers'),
//             ],
//           ),
//         ],
//       );

//   buildButton(BuildContext context, String rank, String followers) {

//     return Column(
//       children: [
//         MaterialButton(
//           splashColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           onPressed: () {},
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: <Widget>[
//               Text(rank,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 24)),
//               const SizedBox(height: 2),
//               Text(followers,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.bold, fontSize: 10)),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }