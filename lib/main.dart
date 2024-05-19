import 'package:first_project/model/player.dart';
import 'package:first_project/screens/auth_gate.dart';
import 'package:first_project/screens/login_content.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//sql-like queries that you can call in main()
// void updateGendersToMale() async {
//   try {
//     // Query all documents in the 'QawlUsers' collection
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('QawlUsers')
//         .get();

//     // Iterate through each document and update the gender field to 'm'
//     for (QueryDocumentSnapshot doc in snapshot.docs) {
//       await doc.reference.update({'gender': 'm'});
//     }

//     print('All genders updated to "m" successfully.');
//   } catch (e) {
//     print('Error updating genders: $e');
//   }
// }


Future<void>main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
   // name: 'qawl-io',
    //options: DefaultFirebaseOptions.currentPlatform,
  );
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qawl',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.hippieBlue,
        darkIsTrueBlack: true,
      ),
      home: const AuthGate(),
      
    );
  }
  
}

