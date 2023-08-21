import 'package:first_project/model/sound_recorder.dart';
import 'package:flutter/material.dart';

class RecordAudioContent extends StatefulWidget {
  const RecordAudioContent({Key? key}) //required this.playlist
      : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<RecordAudioContent> createState() => _RecordAudioContentState();
}

class _RecordAudioContentState extends State<RecordAudioContent> {
  final recorder = SoundRecorder();
  @override
  void initState() {
    super.initState();
    recorder.init();
  }

  @override
  void dispose() {
    recorder.dispose();
    super.dispose();
  }

  _RecordAudioContentState();

  @override
  Widget build(BuildContext context) {
    final isRecording = recorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic;
    final text = isRecording ? "STOP" : "START";
    final color = isRecording ? Colors.red : Colors.white;
    return Material(
      child: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(80.0),
              child: Text("RECORD"),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                  label: Text(text),
                  icon: Icon(icon),
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(175, 50),
                      backgroundColor: color,
                      foregroundColor: Colors.black),
                  onPressed: () async {
                    final isRecording = await recorder.toggleRecording();
                    print("tapped");
                    setState(() {});
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
