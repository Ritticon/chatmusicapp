import 'package:chatmusicapp/models/chat_server.dart';
import 'package:chatmusicapp/models/playlist_provider.dart';
import 'package:chatmusicapp/models/song.dart';
import 'package:chatmusicapp/page/login.dart';
import 'package:chatmusicapp/page/popupSongPage.dart';
import 'package:chatmusicapp/page/streaming.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ChatOnlinePage extends StatefulWidget {
  const ChatOnlinePage({Key? key}) : super(key: key);

  @override
  State<ChatOnlinePage> createState() => _ChatOnlinePageState();
}

class _ChatOnlinePageState extends State<ChatOnlinePage> {
  
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatServer _chatServer = ChatServer();
  late ScrollController _scrollController; // Declare ScrollController
  late final PlaylistProvider playlistProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(); // Initialize ScrollController
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatServer.sendMessage(
          _auth.currentUser!.uid, _messageController.text);
      _messageController.clear();
    }
  }

  // void goToSong(int songIndex) {
  //   playlistProvider.currentSongStream = songIndex;
  //   print("Index Stream =${songIndex}");
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //      return GoRouter.of(context).push('/');
  //     },
  //   );
  // }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('You did not Log in'),
          content: const Text(
            'Please Log in',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Disable'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Login'),
              onPressed: () {
                GoRouter.of(context).push('/login');
              },
            ),
          ],
        );
      },
    );
  }

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Message')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("เข้าhaserror ");
          // context.go('/login');
        }
        print("snapdata = ${snapshot.data}");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          print("เข้าhasdata ");
          //  context.go('/login');
        }
        if (_auth.currentUser == null) {
          print("เข้าาจ้า ");
          // return Login();
          var messages = snapshot.data!.docs;
          return SafeArea(
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<PlaylistProvider>(builder: (context, value, child) {
                    final List<Song> playlist = value.playlist;
                    final currentSong = playlist[value.currentSongStream ?? 0];
                    print("เพลงงง = ${currentSong}");
                    return GestureDetector(
                      onTap: () {
                        GoRouter.of(context).push('/');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.only(
                                // topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: 8, left: 10, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          currentSong.albumArtImagePath,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 13),
                                  Text(
                                    currentSong.songName,
                                    style: TextStyle(
                                      fontFamily: 'atma',
                                      fontSize: 20,
                                      color: Color(0xFFFF6B00),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // Toggle mute/unmute functionality
                                      playlistProvider.toggleMute();
                                    },
                                    icon: Icon(
                                      playlistProvider.isMuted
                                          ? Icons.volume_off
                                          : Icons.volume_up,
                                      color: Color(0xFFFF6B00),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Text(
                            'Online Chat',
                            style: TextStyle(
                              fontFamily: 'atma',
                              fontSize: 35,
                              color: Color(0xFFFF6B00),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      shrinkWrap: true, // Add this line
                      padding: EdgeInsets.only(
                          bottom: 20), // Add padding to the bottom
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data!.docs[index]
                                          ["currentUserImage"] as String),
                                ),
                                Text(
                                  snapshot.data!.docs[index]["senderEmail"],
                                  style: TextStyle(
                                      fontFamily: 'aBeeZee',
                                      fontSize: 16,
                                      color: Color(0xFFFF6B00)),
                                ),
                                Text(
                                  snapshot.data!.docs[index]["message"],
                                  style: TextStyle(
                                      fontFamily: 'aBeeZee',
                                      fontSize: 16,
                                      color: Color(0xFFFF6B00)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
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
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.secondary,
                                contentPadding: const EdgeInsets.all(6),
                                hintText: 'chat',
                                hintStyle: const TextStyle(
                                  fontFamily: 'Inter',
                                  color: Color(0xFFFF6B00),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        IconButton(
                          onPressed: () => _dialogBuilder(context),
                          icon: Icon(
                            Icons.send,
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        var messages = snapshot.data!.docs;

        return SafeArea(
          child: Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<PlaylistProvider>(builder: (context, value, child) {
                  final List<Song> playlist = value.playlist;
                  final currentSong = playlist[value.currentSongStream ?? 0];
                  return GestureDetector(
                    onTap: () {
                      GoRouter.of(context).push('/');
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.only(
                              // topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: 8, left: 10, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        currentSong.albumArtImagePath,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 13),
                                Text(
                                  currentSong.songName,
                                  style: TextStyle(
                                    fontFamily: 'atma',
                                    fontSize: 20,
                                    color: Color(0xFFFF6B00),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Toggle mute/unmute functionality
                                    playlistProvider.toggleMute();
                                  },
                                  icon: Icon(
                                    playlistProvider.isMuted
                                        ? Icons.volume_off
                                        : Icons.volume_up,
                                    color: Color(0xFFFF6B00),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Online Chat',
                          style: TextStyle(
                            fontFamily: 'atma',
                            fontSize: 35,
                            color: Color(0xFFFF6B00),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    shrinkWrap: true, // Add this line
                    padding: EdgeInsets.only(
                        bottom: 20), // Add padding to the bottom
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      var alignment = (snapshot.data!.docs[index]
                                  ['senderEmail'] ==
                              _auth.currentUser!.email)
                          ? Alignment.centerRight
                          : Alignment.centerLeft;
                      return Container(
                        alignment: alignment,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: (snapshot.data!.docs[index]
                                        ["senderId"] ==
                                    _auth.currentUser!.uid)
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            mainAxisAlignment: (snapshot.data!.docs[index]
                                        ["senderId"] ==
                                    _auth.currentUser!.uid)
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data!
                                    .docs[index]["currentUserImage"] as String),
                              ),
                              Text(
                                snapshot.data!.docs[index]["senderEmail"],
                                style: TextStyle(
                                    fontFamily: 'aBeeZee',
                                    fontSize: 16,
                                    color: Color(0xFFFF6B00)),
                              ),
                              Text(
                                snapshot.data!.docs[index]["message"],
                                style: TextStyle(
                                    fontFamily: 'aBeeZee',
                                    fontSize: 16,
                                    color: Color(0xFFFF6B00)),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 5.0, 30.0, 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
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
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor:
                                  Theme.of(context).colorScheme.secondary,
                              contentPadding: const EdgeInsets.all(6),
                              hintText: 'chat',
                              hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFFFF6B00),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        onPressed: sendMessage,
                        icon: Icon(
                          Icons.send,
                          color: Color(0xFFFF6B00),
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
