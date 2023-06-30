import 'package:first_project/playlistbuttoncontent.dart';
import 'package:flutter/material.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20), //how big the buttons are
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        children: <Widget>[
          PlaylistButtonWidget(title: 'Favorites'),
          PlaylistButtonWidget(title: 'Recents'),
        ],
      ),
    );
  }
}


