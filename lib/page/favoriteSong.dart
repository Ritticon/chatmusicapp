// import 'dart:ffi';

// import 'package:chatmusic/models/playlist_provider.dart';
// import 'package:chatmusic/pages/popupSongPage.dart';
import 'package:chatmusicapp/models/playlist_provider.dart';
import 'package:chatmusicapp/models/song.dart';
import 'package:chatmusicapp/page/popupSongPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:chatmusic/models/song.dart';

class FavoriteSong extends StatefulWidget {
  const FavoriteSong({super.key});

  @override
  State<FavoriteSong> createState() => _FavoriteSongState();
}

class _FavoriteSongState extends State<FavoriteSong> {
  late final PlaylistProvider playlistProvider;

  String search = '';
  String songname = '';
  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PopupSong()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<PlaylistProvider>(builder: (context, value, child) {
              // get playlist
              final List<Song> playlist = value.playlist;

              List<Song> favoriteSongs =
                  playlist.where((song) => song.isFavorite).toList();
              final currentSong = playlist[value.currentSongIndex ?? 0];
              // return List view UI
              return Column(
                children: [
                  Column(
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
                              GestureDetector(
                                onTap: value.pauseOrResume,
                                child: Container(
                                  child: Icon(
                                    playlistProvider.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Color(0xFFFF6B00),
                                    size: 40,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: value.playNextSong,
                                child: Container(
                                  child: Icon(
                                    Icons.skip_next,
                                    color: Color(0xFFFF6B00),
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Row(
                          children: [
                            Text(
                              'Favorite List',
                              style: TextStyle(
                                fontFamily: 'atma',
                                fontSize: 32,
                                color: Color(0xFFFF6B00),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                // padding: EdgeInsets.symmetric(horizontal: 12),
                                width: 90,
                                height: 30, 
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
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor:
                                        Theme.of(context).colorScheme.secondary,
                                    contentPadding: const EdgeInsets.all(6),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      songname = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                                           SizedBox(width: 4),
                Icon(
                  Icons.search,
                  color: Color(0xFFFF6B00),
                )
                          ],
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: favoriteSongs.length,
                    itemBuilder: (context, index) {
                      //get individual
                      final Song song = favoriteSongs[index];
                      if(songname.isEmpty || song.songName.toLowerCase().contains(songname.toLowerCase())){
                                              print("isfavorite = ${song.isFavorite}");
                      print("index =${song}");
                      return ListTile(
                        title: Row(
                          children: [
                            Text(
                              '${index + 1} ',
                              style: TextStyle(
                                fontFamily: 'atma',
                                fontSize: 25,
                                color: Color(0xFFFF6B00),
                              ),
                            ),
                            SizedBox(width: 20),
                            Image.asset(
                              song.albumArtImagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  song.songName,
                                  style: TextStyle(
                                    fontFamily: 'atma',
                                    color: Color(0xFFFF6B00),
                                  ),
                                ),
                                Text(
                                  song.artistName,
                                  style: TextStyle(
                                    fontFamily: 'atma',
                                    color: Color(0xFFFF6B00),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            // if (song.isFavorite) {
                            //     goToSong(index);
                            //   }
                          },
                          child: Icon(
                            song.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: song.isFavorite
                                ? Colors.red
                                : Color(0xFFFF6B00),
                          ),
                        ),
                        onTap: () => goToSong(playlist.indexOf(song)),
                      );
                      }
                      return Container();
                      // if(song.isFavorite[index]){

                      // }
                      //return list tile UI
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
