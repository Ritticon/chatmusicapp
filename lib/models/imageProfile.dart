import 'package:cloud_firestore/cloud_firestore.dart';

Stream<Map<String, String>> getEmailImageMap() async* {
  // สร้างตัวแปรเก็บข้อมูลรูปภาพโปรไฟล์
  Map<String, String> emailImageMap = {};

  // ดึงข้อมูลจาก Firestore
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('userProfile')
      .orderBy('timestamp', descending: true)
      .get();

  // นำข้อมูลลงใน Map
  for (var document in snapshot.docs) {
    var email = document['username'];
    var imageUrl = document['imageProfile'];
    emailImageMap[email] = imageUrl;
  }
}
