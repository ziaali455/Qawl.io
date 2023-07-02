import 'package:first_project/model/faketrackdata.dart';
import 'package:first_project/model/fakeuserdata.dart';
import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'section_title.dart';

class ExploreTrackWidget extends StatelessWidget {
  const ExploreTrackWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
          child: SectionTitle(
            title: "Top 100",
            press: () {},
          ),
        ),
        GridView.count( //this needs to be fixed
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: new NeverScrollableScrollPhysics(),
          children: [
            TrackCard(
              image: faketrackdata.fakeTrack1.coverImagePath,
              title: faketrackdata.fakeTrack1.trackName,
              press: () {},
            ),
            TrackCard(
              image: faketrackdata.fakeTrack2.coverImagePath,
              title: faketrackdata.fakeTrack2.trackName,
              press: () {},
            ),
            TrackCard(
              image: faketrackdata.fakeTrack3.coverImagePath,
              title: faketrackdata.fakeTrack3.trackName,
              press: () {},
            ),
          ],
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
  }) : super(key: key);

  final String title, image;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Container(
          width: 75,
          height: 50,
          decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(image), fit: BoxFit.fill),
              borderRadius: BorderRadius.all(Radius.circular(20))
          )
      ),
      Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Text(title),
      ),
    ]);
    // return Padding(
    //   padding: EdgeInsets.all(getProportionateScreenWidth(10)),
    //   child: GestureDetector(
    //     onTap: press,
    //     child: SizedBox(
    //       width: getProportionateScreenWidth(20),
    //       height: getProportionateScreenWidth(20),
    //       child: ClipRRect(
    //         borderRadius: BorderRadius.circular(20),
    //         child: Stack(
    //           children: [
    //             Image.network(image, fit: BoxFit.fill),
    //             Container(
    //               decoration: BoxDecoration(
    //                 gradient: LinearGradient(
    //                   begin: Alignment.topCenter,
    //                   end: Alignment.bottomCenter,
    //                   colors: [
    //                     Color(0xFF343434).withOpacity(0.4),
    //                     Color(0xFF343434).withOpacity(0.15),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.symmetric(
    //                 horizontal: getProportionateScreenWidth(15.0),
    //                 vertical: getProportionateScreenWidth(10),
    //               ),
    //               child: Text.rich(
    //                 TextSpan(
    //                   style: TextStyle(color: Colors.white),
    //                   children: [
    //                     TextSpan(
    //                       text: "$title\n",
    //                       style: TextStyle(
    //                         fontSize: getProportionateScreenWidth(18),
    //                         fontWeight: FontWeight.bold,
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
