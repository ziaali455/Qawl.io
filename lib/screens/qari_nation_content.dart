import 'package:first_project/model/user.dart';
import 'package:first_project/widgets/categories_widget.dart';
import 'package:flutter/material.dart';
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
              return Center(child: Text('No users yet!'));
            }
          }
        },
      ),
    );
  }
}








/*

import 'package:first_project/model/user.dart';
import 'package:first_project/widgets/categories_widget.dart';
import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore if not already imported
// Adjust with your Firestore service

import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';

class QariNationContent extends StatefulWidget {
  final String countryName;

  const QariNationContent(this.countryName, {Key? key}) : super(key: key);

  @override
  _QariNationContentState createState() => _QariNationContentState();
}

class _QariNationContentState extends State<QariNationContent> {
  late Future<List<QawlUser>> _usersFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _usersFuture = QawlUser.getUsersByCountry(widget.countryName);
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
      _usersFuture = QawlUser.getUsersByCountry(widget.countryName, query: _searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.countryName),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              cursorColor: Colors.green,
              
              controller: _searchController,
              decoration: InputDecoration(
                iconColor: Colors.green,
                hintText: 'Search users...',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _updateSearchQuery('');
                  },
                ),
              ),
              onChanged: _updateSearchQuery,
            ),
          ),
        ),
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return QariColumnCard(
                    user: users[index],
                    width: MediaQuery.of(context).size.width / 2 - 40,
                  );
                },
              );
            } else {
              return Center(child: Text('No users yet!'));
            }
          }
        },
      ),
    );
  }
}


*/
