import 'package:flutter/material.dart';

import '../../../size_config.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: getProportionateScreenWidth(30),
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Text(
              "See More",
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize:getProportionateScreenWidth(15) )
              ,
            ),
          ),
        ],
      ),
    );
  }
}
