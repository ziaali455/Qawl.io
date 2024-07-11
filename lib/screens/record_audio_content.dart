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
  //final record = Record();
  String? _recordedFilePath;
  DateTime? recordingStartTime;
  late final RecorderController recorderController; // new recorder for waves
  late final PlayerController playerController;
  AudioPlayer main_player = AudioPlayer();

  bool isCapturing = false;
  bool isPlaying = false;
  PlayerController controller = PlayerController(); // Initialise
  bool showWaveforms = false;
  bool showCheck = false;
  bool doneRecording = false;

  @override
  void initState() {
    super.initState();
    _initialiseController();
    initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    recorderController.dispose();
    playerController.dispose();
    main_player.dispose();
  }

  void _initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
    playerController = PlayerController();
  }

  Future<void> initRecorder() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        print('Mic permission not granted'); // Debug print
        //throw 'Mic permission not granted';
      } else {
        print('Mic permission granted'); // Debug print
      }
    } else {
      print('Mic permission already granted'); // Debug print
    }
  }

//using a temporary filepath to store the file locally, then delete the path after stopping the recording
  Future<void> start() async {
    // if (await Permission.microphone.isGranted) {
    // Delete the previous recording if it exists
    if (_recordedFilePath != null) {
      File previousRecording = File(_recordedFilePath!);
      if (await previousRecording.exists()) {
        await deleteLocalFile(previousRecording);
      }
    }

    recordingStartTime = DateTime.now();
    _recordedFilePath = await getTemporaryFilePath(); // Set the new file path
    // await record.start(path: _recordedFilePath);
    playerController.preparePlayer(path: _recordedFilePath!);
    await recorderController.record(path: _recordedFilePath!);

    setState(() {
      showWaveforms = true;
      isCapturing = true;
    });
    debugPrint("Recording started");
    // }  else {
    //    await initRecorder();
    //    if (await Permission.microphone.isGranted) {
    //      await start();
    //    }
    //}
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
    // bool isRecording = await record.isRecording();
    bool isRecording = await recorderController.isRecording;
    return isRecording;
  }

  void stopRecording() async {
    await recorderController.stop();
    //await record.stop();
    debugPrint("Recording stopped");
    setState(() {
      showWaveforms = false;
      isCapturing = false;
      doneRecording = true;
    });
  }

  Future<void> playAudio() async {
    if (_recordedFilePath == null) {
      debugPrint("No recording has been made yet");
      return;
    }
    try {
      await main_player.setFilePath(_recordedFilePath!);
      await playerController.preparePlayer(path: _recordedFilePath!);
      //main_player.play();
      playerController.startPlayer();

      main_player.positionStream.listen((position) {
        playerController.seekTo(position.inMilliseconds);
      });

      main_player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() {
            isPlaying = false;
          });
          debugPrint("Playback completed");
        }
      });

      setState(() {
        isPlaying = true;
      });

      debugPrint("Playback started");
    } catch (e) {
      debugPrint("Error during playback: $e");
    }
  }

//temp widget for waveform
  Widget QawlWaveforms() {
    if (isCapturing) {
      return AudioWaveforms(
        enableGesture: true,
        size: Size(MediaQuery.of(context).size.width, 100),
        recorderController: recorderController,
        waveStyle: const WaveStyle(
          waveColor: Colors.green,
          extendWaveform: true,
          waveThickness: 4.0,
          scaleFactor: 125.0,
          showMiddleLine: false,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xFF1E1B26),
        ),
        padding: const EdgeInsets.only(left: 18),
        margin: const EdgeInsets.symmetric(horizontal: 15),
      );
    } else if (isPlaying) {
      return AudioFileWaveforms(
        size: Size(MediaQuery.of(context).size.width, 100),
        playerController: playerController,
        playerWaveStyle: const PlayerWaveStyle(
          scaleFactor: 150.0,
          fixedWaveColor: Colors.green,
          liveWaveColor: Colors.green,
          waveCap: StrokeCap.butt,
        ),
      );
    } else {
      return Container(
        height: 100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        // Use SingleChildScrollView to handle overflow
        child: Column(
          children: [
            const SizedBox(height: 20),
            buildTopBar(), // Extracted widget for top bar controls
            buildWaveformDisplay(), // Waveform display
            const SizedBox(height: 20),
            buildControlButtons(), // Control buttons like record, play, etc.
            const SizedBox(height: 40),
            buildActionButtons(), // Actions like delete, confirm
          ],
        ),
      ),
    );
  }

  Widget buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: QawlBackButton(),
    );
  }

  Widget buildWaveformDisplay() {
    return Column(
      children: [
        QawlWaveforms(),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget buildControlButtons() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QawlRecordButton(),
            const SizedBox(width: 10),
            QawlPlayBackButton(),
          ],
        ),
      ),
    );
  }

  Widget buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        QawlDeleteRecordingButton(),
        QawlConfirmRecordingButton(),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   bool _visible = true;
  //   return Scaffold(
  //       backgroundColor: Colors.black,
  //       body: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Center(
  //             child: Column(
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.only(bottom: 250.0),
  //                   child: QawlBackButton(),
  //                 ),
  //                 // AudioFileWaveforms(
  //                 //   size: Size(MediaQuery.of(context).size.width, 100.0),
  //                 //   playerController: playerController,
  //                 // ),

  //                 QawlWaveforms(),
  //                 SizedBox(height: 10),
  //                 Center(
  //                   child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: QawlRecordButton()),
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: QawlPlayBackButton(),
  //                     ),
  //                   ],
  //                 ),
  //                 SizedBox(height: 100),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: QawlDeleteRecordingButton(),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(15.0),
  //                       child: QawlConfirmRecordingButton(),
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ));
  // }

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
                fixedSize: Size(125, 70),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.only(left: 10, right: 10),
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
                fixedSize: Size(125, 70),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.only(left: 10, right: 10),
                textStyle: const TextStyle(fontSize: 50),
              ),
              onPressed: () {
                if (_recordedFilePath != null) {
                  // Check that the recorded file path is not null
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackInfoContent(
                          trackPath:
                              _recordedFilePath!, // Pass the non-null recorded file path
                        ),
                      ));
                } else {
                  // Inform the user that the file path is not available
                  debugPrint("Recorded file path is null");
                }
              },
              // onPressed: () {
              //   Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (context) => TrackInfoContent(
              //           trackPath: _recordedFilePath!,
              //         ),
              //       ));
              // },
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
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
        ElevatedButton(
            child: isCapturing
                ? Icon(Icons.stop, size: 80.0)
                : Icon(Icons.mic, size: 80.0),

            // Icon(
            //   Icons.mic,
            //   size: 50.0,
            // ),
            onPressed: () async {
              if (isCapturing) {
               stopRecording();
              } else {
                await start();
              }
            },
            // onPressed: () async {
            //   setState(() {
            //     isCapturing = !isCapturing;
            //   });
            //   if (await isRecording()) {
            //     // popup for surah name,
            //     stopRecording();
            //     doneRecording = !doneRecording;
            //     showCheck = !showCheck;

            //     //VERIFICATION BUTTON
            //     //uploadRecording();
            //   } else {
            //     await start();
            //     Icons.stop;
            //   }
            // },
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            ))
      ]);
    }
  }

  Widget QawlPlayBackButton() {
    return ElevatedButton(
        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 60.0),
        onPressed: () async {
          if (isPlaying) {
            await main_player.stop();
            setState(() {
              isPlaying = false;
            });
          } else {
            // playerController.startPlayer();
            await playAudio();
            // setState(() {
            //   isPlaying = true;
            // });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        ));
    //   return doneRecording
    //       ? Row(
    //           children: [
    //             Stack(children: <Widget>[
    //               Positioned.fill(
    //                 child: Container(
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.circular(4),
    //                     gradient: LinearGradient(
    //                       colors: <Color>[
    //                         Color.fromARGB(255, 13, 161, 99),
    //                         Color.fromARGB(255, 22, 181, 93),
    //                         Color.fromARGB(255, 32, 220, 85),
    //                       ],
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               ElevatedButton(
    //                   child: isPlaying
    //                       ? Icon(Icons.pause, size: 60.0)
    //                       : Icon(Icons.play_arrow, size: 60.0),
    //                   onPressed: () async {
    //                     setState(() {
    //                       showWaveforms = !showWaveforms;
    //                       isPlaying = !isPlaying;
    //                     });

    //                     debugPrint(_recordedFilePath);
    //                     //AudioWaveforms version of playback
    //                     if (isPlaying) {
    //                       await playAudio();
    //                     } else {
    //                       main_player
    //                           .stop(); // Stop the player if already playing
    //                     }
    //                   },
    //                   style: ElevatedButton.styleFrom(
    //                     backgroundColor: Colors.transparent,
    //                     shadowColor: Colors.transparent,
    //                     padding:
    //                         EdgeInsets.symmetric(horizontal: 30, vertical: 30),
    //                   ))
    //             ]),
    //           ],
    //         )
    //       : Container(
    //           height: 0,
    //         );
    // }
  }
}
