// import 'package:chatmusic/models/profile.dart';
// import 'package:chatmusic/pages/searchMusic.dart';
// import 'package:chatmusic/pages/setting.dart';
// import 'package:chatmusic/pages/streaming.dart';
import 'package:chatmusicapp/page/streaming.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('userProfile').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
              child:
                  Text('No data available')); // Handle case when data is null
        }
        var documents = snapshot.data!.docs; // Null check before accessing 'docs'
        if (documents.isEmpty) {
          return Center(
              child: Text(
                  'No documents available')); // Handle case when there are no documents
        }
        var imageUrl =
            documents[0]['imageProfile']; // Accessing 'docs' after null check

        // Display image
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            flexibleSpace: Center(
              child: Text(
                "My Profile",
                style: TextStyle(
                  fontFamily: 'atma',
                  fontSize: 33,
                  color: Color(0xFFFF6B00),
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 80,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    auth.currentUser?.email ?? '',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StreamingPage()),
                      );
                      // Navigator.pushNamedAndRemoveUntil(context, '/streaming', (route) => false);
                    });
                  },
                  child: Transform.rotate(
                    angle: 3.14,
                    child: Icon(
                      Icons.logout_sharp,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/setting');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.settings),
                      SizedBox(width: 8),
                      const Text("S E T T I N G"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        ;
      },
    );
  }
}
