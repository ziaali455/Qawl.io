import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/screens/homepage_content.dart';
import 'package:first_project/screens/explore_content.dart';
import 'package:first_project/screens/profile_content.dart';
import 'package:first_project/deprecated/profile_content_DEPRECATED.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../widgets/now_playing_bar.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 1; // Set initial index to 1 for ExploreContent
  
  final List<Widget> screens = [
    const HomePageContent(),
    const ExploreContent(),
    ProfileContent(isPersonal: true),
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
              GButton(icon: Icons.person),
            ],
            selectedIndex: currentIndex, // Set the selected index
          ),
        ],
      ),
    );
  }
}

