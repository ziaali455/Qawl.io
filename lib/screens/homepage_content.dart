import 'package:first_project/model/fake_playlists_data.dart';
import 'package:first_project/widgets/playlist_list_widget.dart';
import 'package:first_project/widgets/playlist_button_widget_block.dart';
import 'package:first_project/widgets/search_field.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import '../../../../size_config.dart';

class HomePageContent extends StatefulWidget {
  //final Playlist playlist;
  //final List<Playlist> playlists;

  const HomePageContent({Key? key}) : super(key: key);
  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  // late List<Playlist> playlists;

  // _HomePageContentState(List<Playlist> playlists) {
  //   this.playlists = playlists;
  // }

  // late Playlist playlist;

  // _HomePageContentState(Playlist playlist) {
  //   this.playlist = playlist;
  // }

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
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            const SearchField(),
            GridView.count(
              shrinkWrap: true,
              primary: false,
              padding: const EdgeInsets.all(20), //how big the buttons are
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              children: <Widget>[
                PlaylistButtonWidget(
                    playlist: fake_playlist_data.homeExample1),
                PlaylistButtonWidget(
                    playlist: fake_playlist_data.homeExample2),
                PlaylistButtonWidget(
                    playlist: fake_playlist_data.homeExample3),
                PlaylistButtonWidget(
                    playlist: fake_playlist_data.homeExample4),
                
              ],
            ),
            SectionTitle(
              title: "More Playlists",
              press: () {},
            ),
            PlaylistListWidget(playlists_List: [
              fake_playlist_data.recents,
              fake_playlist_data.homeExample5,
              fake_playlist_data.homeExample6
            ]),
          ],
        ),
      ),
    );
  }
}
