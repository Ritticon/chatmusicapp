import 'package:chatmusicapp/models/playlist_provider.dart';
import 'package:chatmusicapp/models/song.dart';
import 'package:chatmusicapp/page/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class StreamingPage extends StatefulWidget {
  const StreamingPage({super.key});

  @override
  State<StreamingPage> createState() => _StreamingPageState();
}

class _StreamingPageState extends State<StreamingPage> {
  late PlaylistProvider _playlistProvider;

  @override
  void initState() {
    super.initState();
    _playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    if (_playlistProvider.currentSongStream != null) {
      _playlistProvider.resumes();
    } else {
      _playlistProvider.shuffleAndPlay();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_playlistProvider.isPlaying == true) {
      _playlistProvider.pause();
    }
  }

  String formatTime(Duration duration) {
    String twoDigitSecond =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:$twoDigitSecond";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Message')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData) {
          return const Center(child: Text('No documents available'));
        }
        return Consumer<PlaylistProvider>(
          builder: (context, value, child) {
            List<Song> playlist = value.playlist;
            Song currentSong = playlist[value.currentSongStream ?? 0];
            User? user = FirebaseAuth.instance.currentUser;

            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: Column(
                      children: [
                        _buildSongInfoSection(currentSong),
                        const SizedBox(height: 25),
                        _buildPlayerControls(value),
                        const SizedBox(height: 25),
                        _buildCurrentTimeAndDuration(value, currentSong),
                        const SizedBox(height: 15),
                        _buildProgressSlider(value),
                        const SizedBox(height: 15),
                        _buildOnlineChatButton(user, snapshot),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSongInfoSection(Song currentSong) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentSong.songName,
                  style: const TextStyle(
                    fontFamily: 'atma',
                    color: Color(0xFFFF6B00),
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                currentSong.albumArtImagePath,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerControls(PlaylistProvider value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: GestureDetector(
            onTap: value.toggleMute,
            child: Container(
              child: Icon(
                value.isMuted ? Icons.volume_off : Icons.volume_up,
                color: const Color(0xFFFF6B00),
                size: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentTimeAndDuration(
      PlaylistProvider value, Song currentSong) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          currentSong.songName,
          style: const TextStyle(
            fontFamily: 'atma',
            fontSize: 13,
            color: Color(0xFFFF6B00),
          ),
        ),
        Text(
          formatTime(value.streamDuration),
          style: const TextStyle(
            fontFamily: 'atma',
            fontSize: 13,
            color: Color(0xFFFF6B00),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSlider(PlaylistProvider value) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
      ),
      child: Slider(
        min: 0,
        max: value.totalStreamDuration.inSeconds.toDouble(),
        value: value.streamDuration.inSeconds.toDouble(),
        activeColor: const Color(0xFF733000),
        inactiveColor: const Color(0xFFFF6B00),
        onChanged: (_) {},
        onChangeEnd: (double position) {},
      ),
    );
  }

  Widget _buildOnlineChatButton(
      User? user, AsyncSnapshot<QuerySnapshot> snapshot) {
    return Container(
      width: 300,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () {
            if (user != null) {
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    snapshot.data!.docs.first["currentUserImage"] as String),
                radius: 30,
              ),
              const SizedBox(width: 30),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        snapshot.data!.docs.first["senderEmail"],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Color(0xFFFF6B00),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        snapshot.data!.docs.first["message"],
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: Color(0xFFFF6B00),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
