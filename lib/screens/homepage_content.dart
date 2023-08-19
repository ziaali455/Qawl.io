import 'package:first_project/model/fake_playlists_data.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/widgets/playlist_list_widget.dart';
import 'package:first_project/widgets/playlist_button_widget.dart';
import 'package:first_project/widgets/search_field.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import '../../../../size_config.dart';
import '../model/track.dart';

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
        padding: const EdgeInsets.only(top: 50.0),
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
              children:  <Widget>[
             
              
              PlaylistButtonWidget(playlist: fake_playlist_data.defaultPlaylist),
              PlaylistButtonWidget(playlist: fake_playlist_data.defaultPlaylist),
              PlaylistButtonWidget(playlist: fake_playlist_data.defaultPlaylist),
              PlaylistButtonWidget(playlist: fake_playlist_data.defaultPlaylist),

              ],
            ),

            SectionTitle(title: "Playlists", press: () {}, isPlaylist: true,),
            
           PlaylistListWidget(playlists_List: [fake_playlist_data.defaultPlaylist, fake_playlist_data.defaultPlaylist, fake_playlist_data.defaultPlaylist]),

          ],
        ),
      ),
    );
  }
}
