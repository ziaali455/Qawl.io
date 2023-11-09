import 'package:first_project/model/user.dart';
import 'package:first_project/screens/profile_content.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  final User user;
  const NumbersWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildButton(context, '4', 'Uploads'),
              buildButton(context, '#3', 'Ranking'),
              buildButton(context, user.followers.toString(), 'Followers'),
            ],
          ),
          
        ],
      );

  buildButton(BuildContext context, String value, String text) {
    return Column(
      children: [
        MaterialButton(
          onPressed: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 2),
              Text(text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
