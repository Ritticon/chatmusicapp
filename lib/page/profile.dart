// import 'package:chatmusic/models/profile.dart';
// import 'package:chatmusic/pages/searchMusic.dart';
// import 'package:chatmusic/pages/setting.dart';
// import 'package:chatmusic/pages/streaming.dart';
import 'package:chatmusicapp/page/streaming.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
        // if (!(snapshot.data is QuerySnapshot<Map<String, dynamic>>)) {
        //   return Center(
        //       child:
        //           Text('เข้าแล้วจ้า'));
        //     }
        // User? user = FirebaseAuth.instance.currentUser;
        Reference profileImageRef = FirebaseStorage.instance.ref().child('ProfileImage');
        // var imageUrl = documents['userProfile']['imageProfile']; 
        print("Imageeeee = ${profileImageRef}"); // Accessing 'docs' after null check
        print("Profile = มาจ้าาา ${snapshot.data}");
        

// สร้าง Future สำหรับการเรียก getDownloadURL()
Future<String> imageUrlFuture = profileImageRef.getDownloadURL();

return FutureBuilder<String>(
  future: imageUrlFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      // ในระหว่างการโหลด URL ของรูปภาพ
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      // กรณีเกิดข้อผิดพลาดในการโหลด URL ของรูปภาพ
      return Text('Error: ${snapshot.error}');
    } else {
      // กรณีที่สามารถโหลด URL ของรูปภาพได้
      String imageUrl = snapshot.data!;
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
                    auth.currentUser != null ? auth.currentUser!.email ?? '' : 'Not logged in',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B00),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (auth.currentUser != null) {
                      auth.signOut().then((value) {
                         Navigator.of(context).pop(context);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => StreamingPage()),
                        // );
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('You are not logged in!')),
                      );
                    }
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
      // ใช้ URL ของรูปภาพใน NetworkImage
      return CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 80,
      );
    }
  },
);


        ;
      },
    );
  }
}
