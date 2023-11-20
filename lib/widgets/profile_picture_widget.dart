import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final String country;

  const ProfilePictureWidget({
    Key? key,
    required this.imagePath,
    required this.country,
    required this.onClicked,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: buildImage(country),
    );
  }

  Widget buildImage(String country) {
    final image = NetworkImage(imagePath);
    return Stack(children: [
      ClipOval(
          child: Material(
              color: Colors.transparent,
              child: Ink.image(
                image: image,
                fit: BoxFit.cover,
                width: 128,
                height: 128,
              ))),
      Positioned(
        bottom: 0,
        right: 4,
        child: buildCountryIcon(country),
      ),
    ]);
  }

  Widget buildCountryIcon(String country) => buildCircle(
        color: Colors.black,
        all: 3,
        child: buildCircle(
          color: Colors.green,
          all: 3,
          child: Padding(
            padding: const EdgeInsets.only(left: 3.0, right: 3.0),
            child: Text(country, style: const TextStyle(fontSize: 25)),
          ),
        ),
      );
  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
