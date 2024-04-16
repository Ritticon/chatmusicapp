import 'package:chatmusicapp/models/playlist_provider.dart';
import 'package:chatmusicapp/models/song.dart';
import 'package:chatmusicapp/page/chatOnline.dart';
import 'package:chatmusicapp/page/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
// import 'package:chatmusic/pages/SearchMusic.dart';
import 'package:provider/provider.dart';

class StreamingPage extends StatefulWidget {
  const StreamingPage({super.key});

  @override
  State<StreamingPage> createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  String formatTime(Duration duration) {
    String twoDigitSecond =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    String formatTime = "${duration.inMinutes}:${twoDigitSecond}";

    return formatTime;
  }

  late PlaylistProvider _playlistProvider;

  // @override
  void initState() {
    super.initState();
    _playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    _playlistProvider.shuffleAndPlay();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Message').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          
          // Accessing 'docs' after null check
          // var documents = snapshot.data!.docs;
          // var imageUrl = documents[0]['imageProfile'];
          // print("Imageeeee = ${imageUrl}");
          if (!snapshot.hasData) {
            return Center(child: Text('No documents available'));
          }


          return Consumer<PlaylistProvider>(builder: ((context, value, child) {
            //get playlist

            List<Song> playlist = value.playlist;
            // List<Song> playlist = playlistProvider.playlist;
            final currentSong = playlist[value.currentSongIndex ?? 0];
            User? user = FirebaseAuth.instance.currentUser;
            print("USERR = ${user}");

            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            currentSong.songName,
                                            style: const TextStyle(
                                              fontFamily: 'atma',
                                              color: Color(0xFFFF6B00),
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),

                              //ยังไม่ได้เพิ่มกรอบให้รูป
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF773200),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    currentSong.albumArtImagePath,
                                  ),
                                ),
                              ),
                              SizedBox(height: 25),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: GestureDetector(
                                      onTap: value.pauseOrResume,
                                      child: Container(
                                          child: Icon(
                                        value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                        color: Color(0xFFFF6B00),
                                        size: 40,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      currentSong.songName,
                                      style: TextStyle(
                                        fontFamily: 'atma',
                                        fontSize: 13,
                                        color: Color(0xFFFF6B00),
                                      ),
                                    ),
                                    Text(
                                      formatTime(value.currentDuration),
                                      style: TextStyle(
                                        fontFamily: 'atma',
                                        fontSize: 13,
                                        color: Color(0xFFFF6B00),
                                      ),
                                    ),
                                  ]),
                              SliderTheme(
                                // ทำให้เส้นที่เล่นเพลงไม่มีวงกลม
                                data: SliderTheme.of(context).copyWith(
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 0),
                                ),
                                child: Slider(
                                  min: 0,
                                  max: value.totalDuration.inSeconds.toDouble(),
                                  value: value.currentDuration.inSeconds
                                      .toDouble(),
                                  activeColor: Color(0xFF733000),
                                  inactiveColor: Color(0xFFFF6B00), //
                                  onChanged: (double double) {},
                                  onChangeEnd: (double double) {
                                    // slider finfish, go to position in song duration
                                    value.seek(
                                        Duration(seconds: double.toInt()));
                                  },
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Online chat",
                                    style: TextStyle(
                                      fontFamily: 'atma',
                                      fontSize: 13,
                                      color: Color(0xFFFF6B00),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                  width: 300,
                                  height: 100,
                                  
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
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
                                        onPressed: () {
                                          if (user != null) {
                                            ChatOnlinePage();
                                            // GoRouter.of(context).pushReplacement('/chat');
                                            //  Navigator.pushNamed(context, '/chat');
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           ChatOnlinePage()),
                                            // );
                                            // Navigator.pushReplacement(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         ChatOnlinePage(),
                                            //   ),
                                            // );
                                          } else {
                                            print("streaming เข้า else");
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Login()),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                        
                                        child: Row(
                                          children: [

                                              CircleAvatar(
                                                backgroundImage: NetworkImage(snapshot.data!.docs.first["currentUserImage"] as String),
                                                radius: 40,
                                              ),
                                            SizedBox(width: 15),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs.first["senderEmail"],
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 13,
                                                    color: Color(0xFFFF6B00),
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data!.docs.first["message"],
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontSize: 13,
                                                    color: Color(0xFFFF6B00),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                        ),
                                        
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }));
        });
  }
}
