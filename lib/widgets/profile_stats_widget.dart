import 'package:first_project/model/user.dart';
import 'package:first_project/screens/profile_content_DEPRECATED.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  final QawlUser user;
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

  buildButton(BuildContext context, String rank, String followers) {
    return Column(
      children: [
        MaterialButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(rank,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24)),
              const SizedBox(height: 2),
              Text(followers,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}
