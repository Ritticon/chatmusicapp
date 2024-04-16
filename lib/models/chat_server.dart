
// import 'package:chatmusic/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatServer extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance.collection('userProfile').snapshots(),

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    // final String currentUserImage = _firestore.collection('userProfile').doc(currentUserId).get();
    String? currentUserImage;

    final QuerySnapshot userSnapshots = await _firestore.collection('userProfile').where('username', isEqualTo: currentUserEmail).get();

    if (userSnapshots.docs.isNotEmpty) {
      final DocumentSnapshot userSnapshot = userSnapshots.docs.first;
      final Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      currentUserImage = userData['imageProfile'] as String;
      // ทำสิ่งที่ต้องการกับ currentUserImage
      print("Omageee = ${currentUserImage}");
    } else {
      print('ไม่มี');
    }


    final Timestamp timestamp = Timestamp.now();

    DocumentReference docRef = _firestore.collection("Message").doc();
    Map<String, dynamic> MessageData = {
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'message' : message,
      'timestamp' :timestamp,
      'currentUserImage': currentUserImage,
    };
      docRef.set(MessageData).then((value) {
      print("Message can send");
      print("messagee = ${MessageData}");
    }).catchError((error) {
      print("fail: $error");
    });

  }
}