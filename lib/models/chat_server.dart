
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
    final Timestamp timestamp = Timestamp.now();

    DocumentReference docRef = FirebaseFirestore.instance.collection("Message").doc();
    Map<String, dynamic> MessageData = {
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'message' : message,
      'timestamp' :timestamp,
    };
      docRef.set(MessageData).then((value) {
      print("Message can send");
    }).catchError((error) {
      print("fail: $error");
    });

  }
}