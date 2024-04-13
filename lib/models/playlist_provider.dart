import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatmusicapp/models/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:chatmusic/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  
  //playlist
  // late final CollectionReference _songsCollection;
  // late List<Song> _playlist = [];
    int? _currentSongIndex;
  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();
  // duration
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;
  
  PlaylistProvider() {
    listenToDuration();
    // fetchMusic();
  }
  
  final List<Song> _playlist = [
    // song 1
    Song(
        songName: "เผื่อเธอจะกลับมา",
        artistName: "guncharlie ",
        albumArtImagePath: "assets/image/meee.png",
        audioPath: "audio/song1.mp3"),
    //song2
    Song(
        songName: "กันตรึมสกา",
        artistName: "guncharlie2 ",
        albumArtImagePath: "assets/image/ยิ่งยง.jpg",
        audioPath: "audio/กันตึมสกา.mp3"),
    //song3
    Song(
        songName: "SHEESH",
        artistName: "babymonster ",
        albumArtImagePath: "assets/image/babymonster.jpg",
        audioPath: "audio/SHEESH.mp3")
  ];



// Future<void> initialize() async {
//   await fetchMusic();
// }

// Future<void> fetchMusic() async {
//   QuerySnapshot querySnapshot = await _firestore.collection('playlistMusic').get();

//   if (querySnapshot.docs.isNotEmpty) {
//     for (var doc in querySnapshot.docs) {
//       String songName = doc['songName'];
//       String artistName = doc['artistName'];
//       String albumArtImagePath = doc['albumArtImagePath'];
//       String audioPath = doc['audioPath'];

//       Song song = Song(
//         songName: songName,
//         artistName: artistName,
//         albumArtImagePath: albumArtImagePath,
//         audioPath: audioPath,
//       );

//       _playlist.add(song);
//     }
//     print("playlistttt = ${_playlist}");
//   } else {
//     print('No user profile found for this email');
//   }
// }

  // initially not playing

  bool _isPlaying = false;
  // play song
  void play() async{
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    // เพื่อบอกว่าข้อมูลได้มีการเปลี่ยนแปลงแล้ว
    notifyListeners();
  }
  // pause current song
  void pause() async{
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }
  // resume playing
  void resume() async{
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async{
    if(_isPlaying){
      pause();
    }else {
      resume();
    }
    notifyListeners();
  }
  // seek to specific position in current song
  void seek(Duration position) async{
    await _audioPlayer.seek(position);
  }
  // play next song
  void playNextSong(){
    if(_currentSongIndex != null){
      // ถึงเพลงสุดท้ายหรือยัง
      if(_currentSongIndex! < _playlist.length-1){
        // go to next song if its not the last song
        currentSongIndex = _currentSongIndex! + 1;
      }else {
        // if last song, back to first song
        currentSongIndex = 0;
      }
    }
  }
  // prevoius song
  void playPreviousSong() async{
    // if more 2 seconds pass , if not restart current song
    if(_currentDuration.inSeconds > 2){
      seek(Duration.zero);
    }else {
      if(_currentSongIndex! > 0 ){
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        // if first song back to last song
        currentSongIndex = _playlist.length - 1;
      }
    }
  }
  // listen to duration
  void listenToDuration() {
    // listen duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });
      // listen for current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    // listen for song complete
    _audioPlayer.onPlayerComplete.listen((event) {
      playNextSong();
    });
  }
    // Method เพื่ออัปเดตสถานะของเพลง
  void updateFavoriteStatus(int index, bool isFavorite) {
    _playlist[index].isFavorite = isFavorite;
    notifyListeners(); 
  }
//   void updatePlaylist(List<Song> newPlaylist) {
//   _playlist.addAll(newPlaylist);
//   notifyListeners();
// }

  // random music in playlist
  void shuffleAndPlay() {
    if (_playlist.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(_playlist.length);
      currentSongIndex = randomIndex;
      play();
    }
  }

  // dispose
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying ;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  //setting
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if(newIndex != null){
      play();
      debugPrint('${currentDuration.toString()} mmmm');


    }
    notifyListeners();
  }
}
