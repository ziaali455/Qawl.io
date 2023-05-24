import 'package:flutter/material.dart';

class ExploreContent extends StatefulWidget {
  const ExploreContent({Key? key}) : super(key: key);
  @override
  State<ExploreContent> createState() => _ExploreContentState();
}

class _ExploreContentState extends State<ExploreContent> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('explore', style: TextStyle(fontSize: 60)));
  }
}