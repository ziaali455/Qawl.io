import 'package:first_project/model/tracklistview.dart';
import 'package:first_project/playlistbuttoncontent.dart';
import 'package:first_project/search_field.dart';
import 'package:first_project/section_title.dart';
import 'package:first_project/constants.dart';
import 'package:flutter/material.dart';
import '../../../size_config.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({Key? key}) : super(key: key);
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // return Padding(
    //   padding: const EdgeInsets.only(top: 80.0),
    //   child: Column(
    //     children: [
    //       GridView.count(
    //         crossAxisCount: 2,
    //         primary: false,
    //         padding: const EdgeInsets.all(2),
    //         crossAxisSpacing: 2,
    //         mainAxisSpacing: 2,
    //         children: <Widget>[
    //           PlaylistButtonWidget(title: 'Favorites'),
    //           PlaylistButtonWidget(title: 'Recents'),
    //           PlaylistButtonWidget(title: "New")
    //         ],
    //       ),
    //       //SizedBox(height: 20),

    //     ],
    //   ),
    // );
  SizeConfig().init(context);
    // OG implementation
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            SearchField(),
             GridView.count(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(20), //how big the buttons are
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 2,
                children: <Widget>[
                  PlaylistButtonWidget(title: 'Favorites'),
                  PlaylistButtonWidget(title: 'Recents'),
                  PlaylistButtonWidget(title: 'Quran 1'),
                  PlaylistButtonWidget(title: 'Quran 2'),
                ],
              ),
      
            SectionTitle(title: "Playlists", press: () {}),
            TrackList(),
            
          ],
        ),
      ),
    );
  }
}
