import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildButton(context, '4', 'Uploads'),
          buildButton(context, '#3', 'Ranking'),
          buildButton(context, '50', 'Followers'),
        ],
      );

  buildButton(BuildContext context, String value, String text) {
    return MaterialButton(
      onPressed: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(height: 2),
          Text(text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
        ],
      ),
    );
  }
}
