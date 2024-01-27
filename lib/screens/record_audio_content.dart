import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:first_project/model/player.dart';
import 'package:first_project/model/sound_recorder.dart';
import 'package:first_project/screens/now_playing_content.dart';
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

class RecordAudioContent extends StatefulWidget {
  const RecordAudioContent({Key? key}) //required this.playlist
      : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<RecordAudioContent> createState() => _RecordAudioContentState();
}

class _RecordAudioContentState extends State<RecordAudioContent> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final record = Record();
  String? _recordedFilePath;
  DateTime? recordingStartTime;

  AudioPlayer main_player = AudioPlayer();

  bool isCapturing = false;
  bool isPlaying = false;
  PlayerController controller = PlayerController(); // Initialise
  bool showWaveforms = false;
  bool showCheck = false;
  bool doneRecording = false;

//using a temporary filepath to store the file locally, then delete the path after stopping the recording
  Future<void> start() async {
    if (await record.hasPermission()) {
      // Delete the previous recording if it exists
      if (_recordedFilePath != null) {
        File previousRecording = File(_recordedFilePath!);
        if (await previousRecording.exists()) {
          await deleteLocalFile(previousRecording);
        }
      }

      recordingStartTime = DateTime.now();
      _recordedFilePath = await getTemporaryFilePath(); // Set the new file path
      await record.start(path: _recordedFilePath);
      debugPrint("Recording started");
    }
  }

// user id plus milliseconds
  Future<String> getTemporaryFilePath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    return '$tempPath/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
  }

// delete the local file after uploading to storage
  Future<void> deleteLocalFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        debugPrint("Local file deleted successfully.");
      }
    } catch (e) {
      debugPrint("Error deleting local file: $e");
    }
  }

// Get the state of the recorder
  Future<bool> isRecording() async {
    bool isRecording = await record.isRecording();
    return isRecording;
  }

  void stopRecording() async {
    await record.stop();
    debugPrint("Recording stopped");

    //popup for surah name and then call upload storeUrlInFirestore to add with surah name
    if (_recordedFilePath != null) {
     // debugPrint("here");
     // File audioFile = File(_recordedFilePath!);
     // String? fileUrl = await uploadRecording(_recordedFilePath);
     // if (fileUrl != null) {
   //     await storeUrlInFirestore(fileUrl);
        // await deleteLocalFile(audioFile); // Delete the local file
   //   }
      // _recordedFilePath = null; // Reset the file path?
    }
  }

  //takes in the url and uploads it to cloud firestore
  // Future<void> storeUrlInFirestore(String fileUrl) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('tracks').add({
  //       'fileUrl': fileUrl,
  //       'timestamp': FieldValue.serverTimestamp(),
  //       //'surah' : surah
  //     });
  //     debugPrint('File URL stored in Firestore successfully.');
  //   } catch (e) {
  //     debugPrint('Error storing file URL in Firestore: $e');
  //   }
  // }

  //upload the recording file itself to firebase storage
  // Future<String?> uploadRecording(String? filePath) async {
  //   debugPrint("Uploading recording...");
  //   File file;
  //   if (filePath != null) {
  //     file = File(filePath);

  //     try {
  //       String fileName =
  //           'recordings/${DateTime.now().millisecondsSinceEpoch}.m4a';
  //       TaskSnapshot uploadTask =
  //           await FirebaseStorage.instance.ref(fileName).putFile(file);
  //       String downloadUrl = await uploadTask.ref.getDownloadURL();
  //       return downloadUrl;
  //     } catch (e) {
  //       debugPrint("Error uploading audio file: $e");
  //       return null;
  //     }
  //   } else {
  //     debugPrint("null filepath parameter ");
  //   }
  // }

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Mic permission not granted';
    }
    //await  recordopenAudioSession();
  }

  Future<void> playAudio() async {
    if (_recordedFilePath == null) {
      debugPrint("No recording has been made yet");
      return;
    }
    try {
      await main_player
          .setFilePath(_recordedFilePath!); // Set the local file path
      await main_player.play(); // Play the audio
      //add the waveforms here

      // Listen to the player state
      main_player.playerStateStream.listen((state) async {
        // Check if the player has finished playing
        if (state.processingState == ProcessingState.completed) {
          // Delete the local file after playback
          await deleteLocalFile(File(_recordedFilePath!));

          // Reset the recorded file path to null
          _recordedFilePath = null;
        }
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

//temp widget for waveform
  Widget QawlWaveforms() {
    if (showWaveforms) {
      return AudioFileWaveforms(
        size: Size(MediaQuery.of(context).size.width, 100.0),
        playerController: controller,
        enableSeekGesture: true,
        waveformType: WaveformType.long,
        waveformData: [],
        playerWaveStyle: const PlayerWaveStyle(
          fixedWaveColor: Colors.green,
          liveWaveColor: Colors.blueAccent,
          spacing: 6,
        ),
      );
    } else {
      return Container(height: 0);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 250.0),
              child: QawlBackButton(),
            ),
            //Waveforms
            //QawlWaveforms(),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: QawlRecordButton()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: QawlPlayBackButton(),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: QawlDeleteRecordingButton(),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: QawlConfirmRecordingButton(),
            ),
          ],
        ));
  }

  Widget QawlDeleteRecordingButton() {
    if (doneRecording) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(children: <Widget>[
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
                 //should go back one step to recording main screen
                Navigator.pop(context);
                File file = File(_recordedFilePath!);
                deleteLocalFile(file);
                debugPrint(_recordedFilePath);
              },
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Delete",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )),
            ),
          ]));
    } else {
      return Container(
        height: 0,
      );
    }
  }
    Widget QawlConfirmRecordingButton() {
    if (doneRecording) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Stack(children: <Widget>[
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
                  builder: (context) => TrackInfoContent(
                    trackPath: _recordedFilePath!,
                  ),
                ));
              },
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Confirm",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  )),
            ),
          ]));
    } else {
      return Container(
        height: 0,
      );
    }
  }

  Widget QawlRecordButton() {
    if (doneRecording) {
      return Container(height: 0);
    } else {
      return Stack(children: <Widget>[
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
            ), ElevatedButton(
          child: isCapturing
              ? Icon(Icons.stop, size: 50.0)
              : Icon(Icons.mic, size: 50.0),
          
          // Icon(
          //   Icons.mic,
          //   size: 50.0,
          // ),
          onPressed: () async {
            setState(() {
              isCapturing = !isCapturing;
            });
            if (await isRecording()) {
              // popup for surah name,
              stopRecording();
              doneRecording = !doneRecording;
              showCheck = !showCheck;

              //VERIFICATION BUTTON
              //uploadRecording();
            } else {
              await start();
              Icons.stop;
            }
          },
          
          style: ElevatedButton.styleFrom(
             shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          ))]);
    }
  }

  Widget QawlPlayBackButton() {
    return doneRecording
        ? Stack(children: <Widget>[
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
            ), ElevatedButton(
            child: isPlaying
                ? Icon(Icons.pause, size: 50.0)
                : Icon(Icons.play_arrow, size: 50.0),
            onPressed: () async {
              setState(() {
                showWaveforms = !showWaveforms;
                isPlaying = !isPlaying;
              });

              debugPrint(_recordedFilePath);
              //AudioWaveforms version of playback
              if (isPlaying) {
                await playAudio();
              } else {
                main_player.stop(); // Stop the player if already playing
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            ))])
        : Container(
            height: 0,
          );
  }
}



                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(
                  //       child: ElevatedButton(
                  //     child: Icon(Icons.upload_file, size: 50.0),
                  //     onPressed: () async {
                  //       debugPrint("clicked upload");

                  //       FilePickerResult? result =
                  //           await FilePicker.platform.pickFiles();

                  //       if (result != null) {
                  //         File file = File(result.files.single.path!);
                  //         Uint8List? fileBytes =
                  //             result.files.first.bytes; // fileBytes is nullable
                  //         String fileName = result.files.first.name;

                  //         if (fileBytes != null) {
                  //           //upload to firebase storage
                  //           //         await FirebaseStorage.instance
                  //           //           .ref('recordings/$fileName')
                  //           //         .putFile(file);
                  //         }

                  //         TaskSnapshot uploadTask = await FirebaseStorage
                  //             .instance
                  //             .ref('recordings/$fileName')
                  //             .putFile(file);
                  //         String downloadUrl =
                  //             await uploadTask.ref.getDownloadURL();

                  //         //upload to cloud firestore
                  //         await FirebaseFirestore.instance
                  //             .collection('tracks')
                  //             .add({
                  //           'fileUrl': downloadUrl,
                  //           'timestamp': FieldValue.serverTimestamp(),
                  //           //'surah' : surah
                  //         });
                  //       } else {
                  //         // User canceled the picker
                  //       }
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.green,
                  //       padding:
                  //           EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  //     ),
                  //   )),
                  // ),