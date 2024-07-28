import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/model/user.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DangerZone extends StatelessWidget {
  QawlUser user;

  DangerZone({
    Key? key,
    required this.user,
  }) : super(key: key);

  void _showDangerZoneOptions(BuildContext context) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.block, color: Colors.red),
                title: const Text('Block'),
                onTap: () {
                  // Handle block action
                  Navigator.of(context).pop();
                  blockUser(user, context);
                  // Implement your block functionality here
                },
              ),
              ListTile(
                leading: const Icon(Icons.report, color: Colors.red),
                title: const Text('Report'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showReportDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    TextEditingController reportController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report User'),
        content: TextField(
          controller: reportController,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Enter details of your report here...',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle report submission
              String reportDetails = reportController.text;
              // Implement your report submission functionality here
              reportUser(user, reportDetails);
              Navigator.of(context).pop();
              print('Report submitted: $reportDetails for user: ${user.name}');
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(Colors.green),
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> reportUser(QawlUser user, String details) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final reporterId = currentUser.uid;

      await FirebaseFirestore.instance.collection('QawlUserReports').add({
        'userId': user.id,
        'reporterId': reporterId,
        'details': details,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } else {
      print('No user currently signed in.');
    }
  }

Future<void> blockUser(QawlUser user, BuildContext context) async {
  // Get the current logged-in user's ID
  String? currentUserId = QawlUser.getCurrentUserUid();
  
  // Check if the current user is logged in
  if (currentUserId != null) {
    try {
      // Reference to the Firestore document of the user to be blocked
      DocumentReference userRef = FirebaseFirestore.instance.collection('QawlUsers').doc(user.id);
      
      // Update the user document with the current user's ID in the blockedBy list, creating the field if it doesn't exist
      await userRef.update({
        'blockedBy': FieldValue.arrayUnion([currentUserId])
      });
      
      // Show a success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully blocked ${user.name}.'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Handle any errors
      print('Error blocking user: $e');
      
      // Show an error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to block ${user.name}.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  } else {
    print('No user is currently logged in.');
  }
}





  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.flag, color: Colors.red),
          onPressed: () => _showDangerZoneOptions(context),
        ),
      ],
    );
  }
}