import 'package:first_project/homepagecontent.dart';
import 'package:first_project/explorecontent.dart';
import 'package:first_project/profilecontent.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final screens = [
    HomePageContent(),
    ExploreContent(),
    ProfileContent(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: GNav(
          backgroundColor: Colors.black,
          color: Colors.white,
          activeColor: Colors.green,
          onTabChange: (index) {
            setState(() { currentIndex = index; });
            print(currentIndex);
          },
          tabs: const [
            GButton(icon: Icons.home),
            GButton(icon: Icons.search),
            GButton(icon: Icons.person)
          ]),
    );
  }
}
