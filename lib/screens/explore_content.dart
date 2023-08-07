import 'package:first_project/constants.dart';
import 'package:first_project/model/playlist.dart';
import 'package:first_project/screens/profile_content.dart';
import 'package:first_project/widgets/search_field.dart';
import 'package:first_project/widgets/explore_track_widget.dart';
import 'package:first_project/widgets/section_title_widget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/fake_user_data.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/size_config.dart';
import 'package:first_project/widgets/categories_widget.dart';

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
     //  Categories(playlist: playlist),
      const ExploreTrackWidget(title: "Top 100"),
      const ExploreTrackWidget(title: "New Releases"),
      SectionTitle(title: "Popular Qaris", press: () {}),
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

class QariCard extends StatelessWidget {
  const QariCard({
    super.key,
    required this.width,
    required this.user,
  });

  final double width;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      child: SizedBox(
        width: getProportionateScreenWidth(width),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const ProfileContent()),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: .75,
                child: Container(
                  padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                  decoration: BoxDecoration(
                    color: kSecondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: "hi",
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(user.imagePath)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.name,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(20),
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
