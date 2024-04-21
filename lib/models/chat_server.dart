import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatServer extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final QuerySnapshot userSnapshots = await _firestore
        .collection('userProfile')
        .where('username', isEqualTo: currentUserEmail)
        .get();

    String? currentUserImage;

    if (userSnapshots.docs.isNotEmpty) {
      final DocumentSnapshot userSnapshot = userSnapshots.docs.first;
      final Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      currentUserImage = userData['imageProfile'] as String;
    } else {}

    final Timestamp timestamp = Timestamp.now();

    DocumentReference docRef = _firestore.collection("Message").doc();
    Map<String, dynamic> MessageData = {
      'senderId': currentUserId,
      'senderEmail': currentUserEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'currentUserImage': currentUserImage,
    };
    docRef.set(MessageData).then((value) {}).catchError((error) {});
  }
}
