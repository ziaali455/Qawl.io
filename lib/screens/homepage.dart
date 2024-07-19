import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/model/player.dart';
import 'package:first_project/screens/homepage_content.dart';
import 'package:first_project/screens/explore_content.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/screens/profile_content.dart';
import 'package:first_project/deprecated/profile_content_DEPRECATED.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../widgets/now_playing_bar.dart';

import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1; // Set initial index to 1 for ExploreContent
  bool isPlaying = false; // Track whether audio is playing

  final List<Widget> screens = [
    const HomePageContent(),
    const ExploreContent(),
    ProfileContent(isPersonal: true),
  ];

  @override
  void initState() {
    super.initState();
    // Start listening to track playing status when the widget initializes
    _startListeningToTrackPlaying();
  }

  void _startListeningToTrackPlaying() {
    // Periodically check the playing status and update UI
    Timer.periodic(Duration(seconds: 1), (timer) {
      _updateIsPlaying();
    });
  }

  Future<void> _updateIsPlaying() async {
    bool playing = await trackIsPlaying();
    setState(() {
      isPlaying = playing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex], // Current tab content
      floatingActionButton: isPlaying ? NowPlayingFloatingButtonWidget() : null,
      bottomNavigationBar: GNav(
        backgroundColor: Colors.black,
        color: Colors.white,
        activeColor: Colors.green,
        onTabChange: (index) {
          setState(() {
            currentIndex = index;
          });
          // print(currentIndex);
        },
        tabs: const [
          GButton(icon: Icons.home),
          GButton(icon: Icons.search),
          GButton(icon: Icons.person),
        ],
        selectedIndex: currentIndex, // Set the selected index
      ),
    );
  }
}


class NowPlayingFloatingButtonWidget extends StatelessWidget {
  const NowPlayingFloatingButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
            width: 95.0, // Default size of FloatingActionButton
            height: 65.0,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: <Color>[
                  Color.fromARGB(255, 13, 161, 99),
                  Color.fromARGB(255, 22, 181, 93),
                  Color.fromARGB(255, 32, 220, 85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlayingContent(
                      playedTrack: getCurrentTrack(),
                    ),
                  ),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor:
                  Colors.transparent, // Make the background transparent
              elevation: 0, // Remove the shadow
               // Display SoundWaveformWidget inside the FloatingActionButton
               child: SoundWaveformWidget(),
            ),
          ),
        ],
      );
  }
}
