import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/model/player.dart';
import 'package:first_project/model/sound_recorder.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:first_project/screens/record_audio_content.dart';
import 'package:first_project/screens/track_info_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:first_project/model/track.dart';

var qawl_green_gradient = const BoxDecoration(
  gradient: LinearGradient(
    colors: <Color>[
      Color.fromARGB(255, 13, 161, 99),
      Color.fromARGB(255, 22, 181, 93),
      Color.fromARGB(255, 32, 220, 85),
    ],
  ),
);

//REPLACE THIS WITH A MODAL BOTTOM SHEET

class UploadOptionsContent extends StatefulWidget {
  const UploadOptionsContent({Key? key}) //required this.playlist
      : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<UploadOptionsContent> createState() => _UploadOptionsContentState();
}

class _UploadOptionsContentState extends State<UploadOptionsContent> {
  Widget build(BuildContext context) {
    return Column(
      children: [
        QawlBackButton(),
        Material(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 100.0),
              child: Center(
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 100.0),
                    child: Text(
                      "Share Your Recitation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: RecordPageButton(),
                  ),
                  UploadPageButton()
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RecordPageButton extends StatelessWidget {
  const RecordPageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromARGB(255, 13, 161, 99),
                    Color.fromARGB(255, 22, 181, 93),
                    Color.fromARGB(255, 32, 220, 85),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              fixedSize: Size(250, 70),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.only(left: 50, right: 50),
              textStyle: const TextStyle(fontSize: 50),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecordAudioContent(),
                  ));
            },
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Record",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                )),
          ),
        ],
      ),
    );
  }
}

class UploadPageButton extends StatelessWidget {
  const UploadPageButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color.fromARGB(255, 13, 161, 99),
                    Color.fromARGB(255, 22, 181, 93),
                    Color.fromARGB(255, 32, 220, 85),
                  ],
                ),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              fixedSize: Size(250, 70),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20),
              textStyle: const TextStyle(fontSize: 50),
            ),
            onPressed: () async {
              debugPrint("clicked upload");

              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                File file = File(result.files.single.path!);
                Uint8List? fileBytes =
                    result.files.first.bytes; // fileBytes is nullable
                String fileName = result.files.first.name;

                if (fileBytes != null) {
                  //upload to firebase storage
                  //         await FirebaseStorage.instance
                  //           .ref('recordings/$fileName')
                  //         .putFile(file);
                }

                TaskSnapshot uploadTask = await FirebaseStorage.instance
                    .ref('recordings/$fileName')
                    .putFile(file);
                String downloadUrl = await uploadTask.ref.getDownloadURL();

                //upload to cloud firestore
                await FirebaseFirestore.instance.collection('tracks').add({
                  'fileUrl': downloadUrl,
                  'timestamp': FieldValue.serverTimestamp(),
                  //'surah' : surah
                });
              } else {
                // User canceled the picker
              }
            },
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Upload",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                )),
          ),
        ],
      ),
    );
  }
}
