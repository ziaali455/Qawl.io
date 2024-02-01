import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:first_project/screens/record_audio_content.dart';
import 'package:first_project/screens/track_info_content.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class AddToLibraryWidget extends StatelessWidget {
  const AddToLibraryWidget

({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              title: Text(
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green),
                  'Add to Favorites'),
              leading: Icon(Icons.favorite, color: Colors.green, size: 30.0),
              onTap: () {
                Navigator.pop(context);
                
              }),
          ListTile(
            title: Text(
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                'Add to Playlist..'),
            leading: Icon(Icons.playlist_add,
                color: Colors.green, size: 30.0),
            onTap: () async {
              Navigator.pop(context);
              //Add a small screen to pick a playlsit to add to
            },
          ),
        ],
      ),
    ));
  }
}
