import 'dart:io';

import 'package:first_project/model/player.dart';
import 'package:first_project/model/sound_recorder.dart';
import 'package:first_project/screens/now_playing_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordAudioContent extends StatefulWidget {
  const RecordAudioContent({Key? key}) //required this.playlist
      : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<RecordAudioContent> createState() => _RecordAudioContentState();
}

class _RecordAudioContentState extends State<RecordAudioContent> {
  // final recorder = FlutterSoundRecorder();
  // Future record() async {
  //   await recorder.startRecorder(toFile: 'audio');
  // }

  // Future stop() async {
  //   await recorder.stopRecorder();
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   initRecorder();
  // }

  // @override
  // void dispose() {
  //   recorder.closeAudioSession();
  //   super.dispose();
  // }

  // _RecordAudioContentState();

  final record = Record();
  Future start() async {
    if (await record.hasPermission()) {
      // Start recording
      await record.start(
        path: '/Users/alizia/first_project/lib/assets/test_recording.m4a',
        encoder: AudioEncoder.aacLc, // by default
        bitRate: 128000, // by default
      );
      debugPrint("it worked");
    }
  }
// Check and request permission

// Get the state of the recorder
  Future isRecording() async {
    bool isRecording = await record.isRecording();
    return isRecording;
  }

  void stopRecording() {
    record.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            QawlBackButton(),
            Center(
                child: ElevatedButton(
              child: Icon(Icons.mic),
              onPressed: () async {
                if (await isRecording()) {
                  stopRecording();
                } else {
                  await start();
                }
              },
            )),
            Center(
                child: ElevatedButton(
              child: Icon(Icons.play_arrow),
              onPressed: () async {
                if (await isRecording()) {
                } else {
                  main_player.setUrl(
                      '/Users/alizia/first_project/lib/assets/test_recording.m4a');
                  main_player.play();
                }
              },
            )),
          ],
        ));
  }

  // Future initRecorder() async {
  //   final status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     throw 'Mic permission not granted';
  //   }
  //   await recorder.openAudioSession();
  // }
}
