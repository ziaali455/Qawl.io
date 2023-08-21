import 'package:first_project/model/playlist.dart';
import 'package:first_project/widgets/search_field.dart';
import 'package:first_project/widgets/explore_track_widget_block.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/fake_user_data.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/size_config.dart';

import '../widgets/categories_widget.dart';
import '../widgets/qari_card_widget.dart';

class ExploreContent extends StatefulWidget {
    //  final Playlist playlist;
  const ExploreContent({Key? key}) : super(key: key);
  @override
  State<ExploreContent> createState() => _ExploreContentState();
}

class _ExploreContentState extends State<ExploreContent> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenWidth;
    return SafeArea(
        child: SingleChildScrollView(
            child: Column(children: [
      const SearchField(),
      Categories(playlist: Playlist(author: "ali", name: "ali", list: []),),
      const ExploreTrackWidget(title: "Top 100"),
      const ExploreTrackWidget(title: "New Releases"),
      SectionTitle(title: "Popular Qaris", press: () {}, isPlaylist: true,),
      const QariCardRow(
        user: fakeuserdata.user0,
      ),
    ])));
  }
}

class QariCardRow extends StatelessWidget {
  const QariCardRow({
    Key? key,
    this.width = 175,
    this.aspectRetio = 1.02,
    required this.user,
  }) : super(key: key);

  final double width, aspectRetio;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(0)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            QariCard(width: width, user: user),
            QariCard(width: width, user: fakeuserdata.user1),
            QariCard(width: width, user: fakeuserdata.user2),
          ],
        ),
      ),
    );
  }
}

