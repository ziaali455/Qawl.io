import 'package:first_project/constants.dart';
import 'package:first_project/search_field.dart';
import 'package:first_project/exploretrackwidget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/fakeuserdata.dart';
import 'package:first_project/profilewidget.dart';
import 'package:first_project/trackwidget.dart';
import 'package:flutter/material.dart';
import 'package:first_project/model/user.dart';
import 'package:first_project/numberswidget.dart';
import 'package:first_project/model/track.dart';
import 'package:first_project/model/faketrackdata.dart';
import 'package:first_project/size_config.dart';
import 'package:first_project/categories.dart';

class ExploreContent extends StatefulWidget {
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
      SearchField(),
      Categories(),
      ExploreTrackWidget(title: "Top 100"),
      ExploreTrackWidget(title: "New Releases"),
      ExploreTrackWidget(title: "For You"),
    ])));
  }
}
