import 'package:flutter/material.dart';

class TrackList extends StatelessWidget {
  const TrackList({
    Key? key, 
    //required EdgeInsets padding, required List<Widget> children,
   
  }) : super(key: key);

@override
  Widget build(BuildContext context) {
return ListView(
  padding: const EdgeInsets.all(8),
  children: <Widget>[
    Container(
      height: 50,
      color: Colors.green[500],
      child: const Center(child: Text('Playlist A')), // pass in playlist content here
    ),
    Container(
      height: 50,
      color: Colors.green[400],
      child: const Center(child: Text('Playlist B')),
    ),
    Container(
      height: 50,
      color: Colors.green[300],
      child: const Center(child: Text('Playlist C')),
    ),
  ],
);  
}

 
} 