import 'package:first_project/widgets/upload_popup_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class QawlRecordButton extends StatelessWidget {
  const QawlRecordButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        onTap: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child:
                  const UploadPopupWidget(), // Replace with your content widget
            ),
          );
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent, // Transparent background
          ),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: <Color>[
                  Color.fromARGB(255, 13, 161, 99),
                  Color.fromARGB(255, 22, 181, 93),
                  Color.fromARGB(255, 32, 220, 85),
                ],
              ).createShader(bounds);
            },
            blendMode:
                BlendMode.srcATop, // Ensures gradient only affects the icon
            child: const Row(
              children: [
                Center(
                  child: Icon(
                    Icons.add,
                    size: 35,
                    color: Colors.white, // Icon color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



//old button that floats
// class QawlRecordButton extends StatelessWidget {
//   const QawlRecordButton({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(3.0),
//       child: Container(
//         width: 60,
//         height: 60,
//         child: Container(
//           decoration: const BoxDecoration(
//             shape: BoxShape.circle,
//             gradient: LinearGradient(
//               colors: <Color>[
//                 Color.fromARGB(255, 13, 161, 99),
//                 Color.fromARGB(255, 22, 181, 93),
//                 Color.fromARGB(255, 32, 220, 85),
//               ],
//             ),
//           ),
//           child: FloatingActionButton(
//             backgroundColor: Colors.transparent,
//             splashColor: Colors.white,
//             onPressed: () {
//               showMaterialModalBottomSheet(
//                 context: context,
//                 builder: (context) => SingleChildScrollView(
//                   controller: ModalScrollController.of(context),
//                   child: const UploadPopupWidget(),
//                 ),
//               );
//             },
//             tooltip: 'Enter the record page',
//             child: const Icon(
//               Icons.add,
//               size: 35,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
// old implementation that doesnt work
//  // FutureBuilder for PlaylistPreviewWidget
//                 FutureBuilder<List<Track>>(
//                   future: user.getUploadedTracks(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     } else if (snapshot.hasError) {
//                       return Center(
//                         child: Text('Error: ${snapshot.error}'),
//                       );
//                     } else {
//                       List<Track> uploadedTracks = snapshot.data ?? [];
//                       print("The tracks are " + uploadedTracks.toString());
//                       return PlaylistPreviewWidget(
//                           playlist: Playlist(
//                               author: user.name,
//                               name: "Uploads",
//                               list: uploadedTracks));
//                     }
//                   },
//                 ),

//WORKING LOOP BUTTON
// IconButton(
//                             icon: Icon(Icons.loop),
//                             iconSize: 20.0,
//                             onPressed: () {
//                               // Add your onPressed code here!
//                               audioHandler
//                                   .setRepeatMode(AudioServiceRepeatMode.one);
//                             },
//                           ),