
import 'package:first_project/model/fake_track_data.dart';
import 'package:flutter/material.dart';

import '../../../../size_config.dart';
import '../screens/now_playing_content.dart';
import 'section_title_widget.dart';

class ExploreTrackWidget extends StatelessWidget {
  const ExploreTrackWidget({
    Key? key,
    required this.title
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
          child: SectionTitle(
            title: title,
            press: () {},
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              TrackCard(
                image: faketrackdata.fakeTrack1.coverImagePath,
                title: faketrackdata.fakeTrack1.trackName,
                author: faketrackdata.fakeTrack1.author,
                press: () {},
              ),
              TrackCard(
                image: faketrackdata.fakeTrack2.coverImagePath,
                title: faketrackdata.fakeTrack2.trackName,
                author: faketrackdata.fakeTrack2.author,
                press: () {},
              ),
              TrackCard(
                image: faketrackdata.fakeTrack3.coverImagePath,
                title: faketrackdata.fakeTrack3.trackName,
                author: faketrackdata.fakeTrack3.author,
                press: () {},
              ),
              TrackCard(
                image: faketrackdata.fakeTrack4.coverImagePath,
                title: faketrackdata.fakeTrack4.trackName,
                author: faketrackdata.fakeTrack4.author,
                press: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TrackCard extends StatelessWidget {
  const TrackCard({
    Key? key,
    required this.title,
    required this.image,
    required this.press,
    required this.author,
  }) : super(key: key);

  final String title, image, author;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    // return Row(children: <Widget>[
    //   Container(
    //       width: 75,
    //       height: 50,
    //       decoration: BoxDecoration(
    //           image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fill),
    //           borderRadius: BorderRadius.all(Radius.circular(20))
    //       )
    //   ),
    //   Padding(
    //     padding: const EdgeInsets.only(left: 3.0),
    //     child: Text(title),
    //   ),
    // ]);
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(10)),
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NowPlayingContent(playedTrack: faketrackdata.defaultTrack)),
          ),
        child: SizedBox(
          width: getProportionateScreenWidth(150),
          height: getProportionateScreenWidth(150),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  height: 150,
                  width: 150,
                  foregroundDecoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(.0),
                        Colors.black.withOpacity(.8),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(10.0),
                      vertical: getProportionateScreenWidth(10),
                    ),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: "$title\n",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: "$author\n",
                            style: TextStyle(
                              fontSize: getProportionateScreenWidth(18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
