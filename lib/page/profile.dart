import 'package:chatmusicapp/page/login.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

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

        if (auth.currentUser == null) {
          print("เข้าาจ้า ");
          return Login();
        }
        Map<String, String> emailImageMap = {};
        for (var document in snapshot.data!.docs) {
          var email = document['username'];
          var imageUrl = document['imageProfile'];
          emailImageMap[email] = imageUrl;
        }
        // var emailImageMap = snapshot.data as Map<String, String>;
        print("emailรูปภาพ ${emailImageMap}");
        var email = auth.currentUser?.email;
        var imageUrl = emailImageMap[email];
        print("imagee ${imageUrl}");

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
                  backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl)
                      : AssetImage('assets/image/profile.jpg')
                          as ImageProvider<Object>?,
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
                      //  StreamingPage();

                      // Home();
                      GoRouter.of(context).push('/');
                      //  Navigator.pushNamed(context, '/streaming');
                      // Navigator.pushNamedAndRemoveUntil(context, '/streaming', (route) => false);
                    });
                  },
                  child: Transform.rotate(
                    angle: 3.14,
                    child: Icon(
                      Icons.logout_sharp,
                      color: Color.fromARGB(255, 255, 100, 0),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).pushReplacement('/setting');
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)), // เปลี่ยนสีเป็นสีที่คุณต้องการ
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Color.fromARGB(255, 255, 100,
                            0), // เปลี่ยนสีของฟันเฟืองเป็นสีที่คุณต้องการ
                      ),
                      SizedBox(width: 8),
                      Text(
                        "S E T T I N G",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 100,
                              0), // เปลี่ยนสีข้อความเป็นสีที่คุณต้องการ
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
