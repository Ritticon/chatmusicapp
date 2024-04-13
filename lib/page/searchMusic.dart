// import 'dart:ffi';

import 'dart:ffi';

// import 'package:chatmusic/models/playlist_provider.dart';
// import 'package:chatmusic/pages/popupSongPage.dart';
import 'package:chatmusicapp/models/playlist_provider.dart';
import 'package:chatmusicapp/models/song.dart';
import 'package:chatmusicapp/page/popupSongPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
// import 'package:chatmusic/models/song.dart';

class searchMusic extends StatefulWidget {
  const searchMusic({super.key});

  @override
  State<searchMusic> createState() => _searchMusicState();
}

class _searchMusicState extends State<searchMusic> {
  late final PlaylistProvider playlistProvider;
  String CurrentSongName = "";
  String CurrentIMage = "";
  int? CurrentIndex ; 
  String search = '';
  String songname = '';

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
    // String Song =  FirebaseFirestore.instance.collection('Playlist').get();
    // playlistProvider.addData();
  }

 void goToSong(int songIndex ) {
  playlistProvider.currentSongIndex = songIndex;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return PopupSong();
    },
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
              // int? songIndex;
              // final music = value.playlist;
              final currentSong = playlist[value.currentSongIndex ?? 0];
             
              print("currentSonggg = ${currentSong}");
              
              print("playlistจ้าา = ${playlist}");
              print("เพลงตอนนี้ = ${currentSong.artistName}");
              // return List view UI

              return 
              
              
              Column(
                children: [
                          Container(
                            color:Theme.of(context).colorScheme.secondary, 
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8, left: 10,right: 8),
                              child: Row(
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
                                      )
                                    ),
                                    
                                      
                               ),
                               SizedBox(width: 13),
                               Text(
                                        currentSong.songName,
                                        style: TextStyle(
                                          fontFamily: 'atma',
                                          fontSize: 24,
                                          color: Color(0xFFFF6B00), 
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: value.pauseOrResume,
                                    child: Container(
                                  child: Icon(playlistProvider.isPlaying ? Icons.pause : Icons.play_arrow ,
                                  color: Color(0xFFFF6B00),
                                  size: 40,
                                  )
                                                                ),
                                                              ),
                              GestureDetector(
                                  onTap: value.playNextSong, 
                                  child: Container(child: Icon(Icons.skip_next,
                                    color: Color(0xFFFF6B00),
                                    size: 40,
                                    )
                                  ),
                                ),
                              
                                   ]
                              ),
                            ),
                          ),  
                              const SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 20.0, 8.0, 3.0),
                child: Text(
                  'Search List',
                  style: TextStyle(
                    fontFamily: 'atma',
                    fontSize: 32,
                    color: Color(0xFFFF6B00),
                  ),
                ),
              ),
            ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: playlist.length,
                    itemBuilder: (context, index) {
                      //get individual
                    final Song song = playlist[index];
                    print("isFav = ${song}");
                    if(songname.isEmpty){
                                           
                                    
                      //return list tile UI
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
                            ),
                            
                          ],
                        ),
                        
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              song.isFavorite = !song.isFavorite;
                              playlistProvider.updateFavoriteStatus(
                                index,
                                song.isFavorite,
                              );
                            });
                          },
                          child: Icon(
                            song.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                song.isFavorite ? Colors.red : Color(0xFFFF6B00),
                          ),
                        ),
                        onTap: () {
                           playlistProvider.currentSongIndex = index;
                          print("index!! = ${index}");
                          setState(() {
                            // CurrentIndex = playlistProvider.currentSongIndex;
                            CurrentSongName = song.songName ;
                            CurrentIMage = song.albumArtImagePath ;
                            print("indexxx ${CurrentIndex}");
                            print("เพลง รูป = ${CurrentSongName + CurrentIMage}");
                            print("เพลงต่อไปยัง ${playlistProvider.playNextSong}");
                            print("เล่นอยู่มั้ยย ${playlistProvider.isPlaying}");
                          });
                          
                        } ,                          
                        
                                    
                                    
                                    // subtitle: Text(song.artist),
                            
                            
                                    
                      );
                    }
                    if(song.songName.toString().toLowerCase().contains(songname.toLowerCase())){
                               print("เข้าการค้นหาเพลง")  ;         
                     return SingleChildScrollView(
                        child: ListTile(
                          
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
                              ),
                              
                            ],
                          ),
                          
                          trailing: GestureDetector(
                            onTap: () {
                              setState(() {
                                song.isFavorite = !song.isFavorite;
                                playlistProvider.updateFavoriteStatus(
                                  index,
                                  song.isFavorite,
                                );
                              });
                            },
                            child: Icon(
                              song.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color:
                                  song.isFavorite ? Colors.red : Color(0xFFFF6B00),
                            ),
                          ),
                          onTap: () {
                             playlistProvider.currentSongIndex = index;
                            print("index!! = ${index}");
                            setState(() {
                              // CurrentIndex = playlistProvider.currentSongIndex;
                              CurrentSongName = song.songName ;
                              CurrentIMage = song.albumArtImagePath ;
                              print("indexxx ${CurrentIndex}");
                              print("เพลง รูป = ${CurrentSongName + CurrentIMage}");
                              print("เพลงต่อไปยัง ${playlistProvider.playNextSong}");
                              print("เล่นอยู่มั้ยย ${playlistProvider.isPlaying}");
                            });
                            
                          } ,                          
                          
                                      
                                      
                                      // subtitle: Text(song.artist),
                              
                              
                                      
                        ),
                      );
                    }

                    },
                  ),
                ],
              );
            }),
            Padding(
              padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
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
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.secondary,
                          contentPadding: const EdgeInsets.all(6),
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                            fontFamily: 'Inter',
                            color: Color(0xFFFF6B00),
                            fontSize: 14,
                          ),
                          prefixIcon: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              size: 20,
                              color: Color(0xFFFF6B00),
                            ),
                          ),
                        ),
                        onChanged: (val){
                          setState(() {
                            songname = val ;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.send,
                    color: Color(0xFFFF6B00),
                  ),
                ],
              ),
            ),
            // SizedBox(height: 20),
            // SizedBox(
            //   height: 20,
            // )
          ],
        ),
      ),
    );
  }
}
