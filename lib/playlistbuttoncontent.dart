import 'package:first_project/nowplayingcontent.dart';
import 'package:flutter/material.dart';

class PlaylistButtonWidget extends StatelessWidget {
  final String title;
  const PlaylistButtonWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        var snackBar = SnackBar(content: Text('Add the now playing content'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.green,
        ),
        child: Center(
            child: Text(title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
      ),
    );
  }
}
