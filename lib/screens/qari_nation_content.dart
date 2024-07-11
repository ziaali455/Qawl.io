import 'package:first_project/model/user.dart';
import 'package:first_project/widgets/categories_widget.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore if not already imported
// Adjust with your Firestore service

class QariNationContent extends StatefulWidget {
  final String countryName;

  const QariNationContent(this.countryName, {Key? key}) : super(key: key);

  @override
  _QariNationContentState createState() => _QariNationContentState();
}

class _QariNationContentState extends State<QariNationContent> {
  late Future<List<QawlUser>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = QawlUser.getUsersByCountry(widget.countryName); // Adjust with your current user logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
      ),
      body: FutureBuilder<List<QawlUser>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.green));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<QawlUser>? users = snapshot.data;
            if (users != null && users.isNotEmpty) {
              return GridView.builder(
                padding: EdgeInsets.all(20.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust the number of items per row
                  crossAxisSpacing: 20.0, // Adjust spacing as needed
                  mainAxisSpacing: 20.0, // Adjust spacing as needed
                  childAspectRatio: 0.75, // Adjust aspect ratio as needed
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return QariColumnCard(
                    user: users[index],
                    width: MediaQuery.of(context).size.width / 2 - 40, // Adjust width
                  );
                },
              );
            } else {
              return Center(child: Text('No users available'));
            }
          }
        },
      ),
    );
  }
}

