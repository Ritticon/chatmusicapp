import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatmusicapp/models/song.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:chatmusic/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  //playlist
  // late final CollectionReference _songsCollection;
  // late List<Song> _playlist = [];
  int? _currentSongIndex;
  int? _currentSongStream;
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
        albumArtImagePath: "assets/image/guncharlie.jpg",
        audioPath: "audio/song1.mp3",
        isFavorite: false),
    //song2
    Song(
        songName: "กันตรึมสกา",
        artistName: "guncharlie2 ",
        albumArtImagePath: "assets/image/ยิ่งยง.jpg",
        audioPath: "audio/กันตึมสกา.mp3",
        isFavorite: false),
    //song3
    Song(
        songName: "SHEESH",
        artistName: "babymonster ",
        albumArtImagePath: "assets/image/babymonster.jpg",
        audioPath: "audio/SHEESH.mp3",
        isFavorite: false),
    //song4
    Song(
        songName: "TwoGhosts",
        artistName: "Harry Styles ",
        albumArtImagePath: "assets/image/twoghosts.jpg",
        audioPath: "audio/TwoGhosts.mp3",
        isFavorite: false),
    //song5
    // Song(
    //     songName: "Run it Up",
    //     artistName: "LiL Hustle HFML",
    //     albumArtImagePath: "assets/image/runitup.png",
    //     audioPath: "audio/runitup",
    //     isFavorite: false),
    //song6
    Song(
        songName: "Don't Look Back In Anger",
        artistName: "oasis",
        albumArtImagePath: "assets/image/oasis.jpg",
        audioPath: "audio/Don'tLookBackInAnger.mp3",
        isFavorite: false),
    //song7
    Song(
        songName: "ถ้าเราเจอกันอีก",
        artistName: "tilly birds",
        albumArtImagePath: "assets/image/tillybirds.jpg",
        audioPath: "audio/UntilThen.mp3",
        isFavorite: false),
    //song8
    Song(
        songName: "Wish",
        artistName: "Blackbeans",
        albumArtImagePath: "assets/image/blackbeans.jpg",
        audioPath: "audio/Wish.mp3",
        isFavorite: false),
    //song3
    Song(
        songName: "Dance With Me ",
        artistName: "Blackbeans",
        albumArtImagePath: "assets/image/danceWithme.jpg",
        audioPath: "audio/DanceWithMe.mp3",
        isFavorite: false),

    Song(
        songName: "Run it Up",
        artistName: "LiL Hustle HFML",
        albumArtImagePath: "assets/image/runitup.png",
        audioPath: "audio/runitup.mp3",
        isFavorite: false),

    Song(
        songName: "StayAroundMe",
        artistName: "mind",
        albumArtImagePath: "assets/image/StayAroundMe.png",
        audioPath: "audio/StayAroundMe.mp3",
        isFavorite: false),

    Song(
        songName: "Rain",
        artistName: "PiXXiE",
        albumArtImagePath: "assets/image/rain.png",
        audioPath: "audio/rain.mp3",
        isFavorite: false),
  ];

  addData() async {
    for (var element in playlist) {
      // แปลงอ็อบเจกต์ Song เป็น Map<String, dynamic>
      Map<String, dynamic> songData = {
        'songName': element.songName,
        'artistName': element.artistName,
        'albumArtImagePath': element.albumArtImagePath,
        'audioPath': element.audioPath,
        'isFavorite': element.isFavorite,
        // เพิ่มข้อมูลอื่น ๆ ตามต้องการ
      };

      // เพิ่มข้อมูลลงในคอลเล็กชันของ Firestore
      FirebaseFirestore.instance.collection('Playlist').add(songData);
    }
    print('all data added');
  }

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
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    // เพื่อบอกว่าข้อมูลได้มีการเปลี่ยนแปลงแล้ว
    notifyListeners();
  }

  bool _isPlayings = false;
  void plays() async {
    final String path = _playlist[_currentSongStream!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlayings = true;
    // เพื่อบอกว่าข้อมูลได้มีการเปลี่ยนแปลงแล้ว
    notifyListeners();
  }

  // void switchs() {
  //   _isPlaying = !_isPlaying ;
  // }
  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pauses() async {
    await _audioPlayer.pause();
    _isPlayings = false;
    notifyListeners();
  }

  // resume playing
  void resumes() async {
    await _audioPlayer.resume();
    _isPlayings = true;

    notifyListeners();
  }

  void pausesOrResumes() async {
    if (_isPlayings) {
      pauses();
    } else {
      resumes();
    }
    notifyListeners();
  }

  // pause or resume
  void pauseOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to specific position in current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // play next song
  void playNextSong() {
    if (_currentSongIndex != null) {
      // ถึงเพลงสุดท้ายหรือยัง
      if (_currentSongIndex! < _playlist.length - 1) {
        // go to next song if its not the last song
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        // if last song, back to first song
        currentSongIndex = 0;
      }
    }
  }

  // prevoius song
  void playPreviousSong() async {
    // if more 2 seconds pass , if not restart current song
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
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
      _currentSongStream = randomIndex;
      print("SongStream = ${_currentSongStream}");
      plays();
    }
  }

  bool _isMuted = false; // Define _isMuted
  bool get isMuted => _isMuted;
  set isMuted(bool value) {
    _isMuted = value;
    notifyListeners();
  }

  void toggleMute() {
    isMuted = !isMuted; // Toggle the value of isMuted
    if (_audioPlayer != null) {
      if (isMuted) {
        _audioPlayer.setVolume(0);
      } else {
        _audioPlayer.setVolume(1);
      }
    }
  }

  // dispose
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  int? get currentSongStream => _currentSongStream;
  bool get isPlaying => _isPlaying;
  bool get isPlayings => _isPlayings;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  //setting
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
      debugPrint('${currentDuration.toString()} mmmm');
    }
    notifyListeners();
  }

  set currentSongStream(int? newindex) {
    _currentSongStream = newindex;
    if (newindex != null) {
      plays();
      print('มาแล้วสูๆๆๆ mmmm');
    }
    notifyListeners();
  }
}
