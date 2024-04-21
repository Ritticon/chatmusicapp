import 'dart:typed_data';
import 'dart:io';
// import 'package:chatmusic/models/add_data.dart';
// import 'package:chatmusic/models/profile.dart';
// import 'package:chatmusic/pages/login.dart';
import 'package:chatmusicapp/models/add_data.dart';
import 'package:chatmusicapp/models/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  late Profile profile;

  void initState() {
    super.initState();
    profile = Profile(email: '', password: '', image: '');
  }

  Uint8List? _image;
  File? selectedImage;
  String _password = '';
  String _confirmPassword = '';

  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final CollectionReference _usernameCollection =
      FirebaseFirestore.instance.collection("userProfile");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Error"),
            ),
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              flexibleSpace: Center(
                child: Text(
                  "Register",
                  style: TextStyle(
                    fontFamily: 'atma',
                    fontSize: 33,
                    color: Color(0xFFFF6B00),
                  ),
                ),
              ),
            ),
            body: Container(
              child: Center(
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Stack(
                          children: <Widget>[
                            _image != null
                                ? CircleAvatar(
                                    radius: 80,
                                    backgroundImage: MemoryImage(_image!),
                                  )
                                : const CircleAvatar(
                                    radius: 80,
                                    backgroundImage:
                                        AssetImage("assets/image/logo.png"),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: ((builder) => bottomSheet()),
                                  );
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 60, 25, 0),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Color(0xFFFF6B00),
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                          child: Form(
                            key: formkey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Username',
                                      style: TextStyle(
                                        fontFamily: 'Kreon',
                                        fontSize: 18,
                                        color: Color(0xFFFF6B00),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: 270,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        validator: RequiredValidator(
                                            errorText: "Please assign Email"),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onSaved: (String? email) {
                                          if (email != null) {
                                            setState(() {
                                              profile.email = email;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Password',
                                      style: TextStyle(
                                        fontFamily: 'Kreon',
                                        fontSize: 18,
                                        color: Color(0xFFFF6B00),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: 270,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        validator: RequiredValidator(
                                            errorText:
                                                "Please assign Password"),
                                        obscureText: true,
                                        onChanged: (value) {
                                          _password = value;
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Confirm Password',
                                      style: TextStyle(
                                        fontFamily: 'Kreon',
                                        fontSize: 18,
                                        color: Color(0xFFFF6B00),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: 270,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black,
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: TextFormField(
                                        onChanged: (value) =>
                                            _confirmPassword = value,
                                        validator: (value) {
                                          if (value != _password) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                        obscureText: true,
                                        onSaved: (String? password) {
                                          if (password != null) {
                                            setState(() {
                                              profile.password = password;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                Container(
                                  width: 150,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black,
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (formkey.currentState!.validate()) {
                                          formkey.currentState!.save();

                                          // ตรวจสอบรูปแบบอีเมล
                                          final emailRegExp = RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                          if (!emailRegExp
                                              .hasMatch(profile.email!)) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  title: Text("Warning"),
                                                  content: Text(
                                                      "Please enter a valid email address with @gmail.com"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            return; // หยุดการทำงานของฟังก์ชันเมื่อไม่ผ่านการตรวจสอบอีเมล
                                          }

                                          if (_image == null) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  title: Text("Warning"),
                                                  content: Text(
                                                      "Please select an image"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            String resp =
                                                await StoreData().saveData(
                                              username: profile.email,
                                              password: profile.password,
                                              file: _image!,
                                            );

                                            print('imaggg = ${resp}');
                                            try {
                                              await FirebaseAuth.instance
                                                  .createUserWithEmailAndPassword(
                                                    email: profile.email ?? '',
                                                    password:
                                                        profile.password ?? '',
                                                  )
                                                  .then(
                                                    (value) => showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title:
                                                              Text("Success"),
                                                          content: Text(
                                                              "Your account has been successfully created."),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text('OK'),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  );

                                              formkey.currentState!.reset();
                                              GoRouter.of(context).push('/');
                                            } on FirebaseAuthException catch (e) {
                                              print("error = ${e.message}");
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                    title: Text("Error"),
                                                    content: Text(e.message ??
                                                        "An error occurred"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      child: Text(
                                        "Register",
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 15,
                                          color: Color(0xFFFF6B00),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 130,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          Text(
            "Choose Image",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              color: Color(0xFFFF6B00),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              InkWell(
                onTap: () {
                  _pickImage(ImageSource.camera);
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.secondary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          color: Color(0xFFFF6B00),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Camera",
                          style: TextStyle(
                            color: Color(0xFFFF6B00),
                            fontFamily: 'Inter',
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Container(
                  width: 100,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.secondary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: Color(0xFFFF6B00),
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            color: Color(0xFFFF6B00),
                            fontFamily: 'Inter',
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;
    final pickedImageFile = File(pickedImage.path);
    final pickedImageBytes = await pickedImageFile.readAsBytes();
    setState(() {
      selectedImage = pickedImageFile;
      _image = pickedImageBytes;
    });
    Navigator.of(context).pop();
  }
}
