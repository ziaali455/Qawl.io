import 'package:first_project/screens/homepage_content.dart';
import 'package:first_project/screens/explore_content.dart';
import 'package:first_project/screens/profile_content.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../widgets/now_playing_bar.dart';

class HomePage extends StatefulWidget {
  //final List<Playlist> playlists;

  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final screens = [
    const HomePageContent(),
    const ExploreContent(),
    const PersonalProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NowPlayingBarWidget(),
          GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.green,
              onTabChange: (index) {
                setState(() {
                  currentIndex = index;
                });
                print(currentIndex);
              },
              tabs: const [
                GButton(icon: Icons.home),
                GButton(icon: Icons.search),
                GButton(icon: Icons.person)
              ]),
        ],
      ),
    );
  }
}


