import 'package:first_project/model/countries_data.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/size_config.dart';
import 'package:flutter/material.dart';

import '../neu_box.dart';

class CountryExploreContent extends StatefulWidget {
  const CountryExploreContent({Key? key}) //required this.playlist
      : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<CountryExploreContent> createState() =>
      _CountryExploreContentState();
}

class _CountryExploreContentState extends State<CountryExploreContent> {
  late String playlistTitle;
  _CountryExploreContentState();
  @override
  Widget build(BuildContext context) {
 
    SizeConfig().init(context);
    return Scaffold(
      body:Column(
      children: [
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: QawlBackButton()
        ),
        Expanded(
          child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            
            crossAxisCount: 2,
            // Generate 100 widgets that display their index in the List.
            children: List.generate(allcountries.countries.length, (index) {
              return Container(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        allcountries.countries[index]["emoji"],
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        allcountries.countries[index]["countryName"],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    ));
  }
}
