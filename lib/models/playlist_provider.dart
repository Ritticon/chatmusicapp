import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatmusicapp/models/song.dart';
import 'package:flutter/material.dart';

class PlaylistProvider extends ChangeNotifier {
  int? _currentSongIndex;
  int? _currentSongStream;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _audioPlayers = AudioPlayer();

  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  Duration _streamDuration = Duration.zero;
  Duration _totalStreamDuration = Duration.zero;

  PlaylistProvider() {
    listenToDuration();
  }

  final List<Song> _playlist = [
    Song(
        songName: "เผื่อเธอจะกลับมา",
        artistName: "guncharlie ",
        albumArtImagePath: "assets/image/guncharlie.jpg",
        audioPath: "audio/song1.mp3",
        isFavorite: false),
    Song(
        songName: "กันตรึมสกา",
        artistName: "guncharlie2 ",
        albumArtImagePath: "assets/image/ยิ่งยง.jpg",
        audioPath: "audio/กันตึมสกา.mp3",
        isFavorite: false),
    Song(
        songName: "SHEESH",
        artistName: "babymonster ",
        albumArtImagePath: "assets/image/babymonster.jpg",
        audioPath: "audio/SHEESH.mp3",
        isFavorite: false),
    Song(
        songName: "TwoGhosts",
        artistName: "Harry Styles ",
        albumArtImagePath: "assets/image/twoghosts.jpg",
        audioPath: "audio/TwoGhosts.mp3",
        isFavorite: false),
    Song(
        songName: "Don't Look Back In Anger",
        artistName: "oasis",
        albumArtImagePath: "assets/image/oasis.jpg",
        audioPath: "audio/Don'tLookBackInAnger.mp3",
        isFavorite: false),
    Song(
        songName: "ถ้าเราเจอกันอีก",
        artistName: "tilly birds",
        albumArtImagePath: "assets/image/tillybirds.jpg",
        audioPath: "audio/UntilThen.mp3",
        isFavorite: false),
    Song(
        songName: "Wish",
        artistName: "Blackbeans",
        albumArtImagePath: "assets/image/blackbeans.jpg",
        audioPath: "audio/Wish.mp3",
        isFavorite: false),
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
    // await _audioPlayer.stop();
    await _audioPlayers.play(AssetSource(path));
    _isPlayings = true;
    // เพื่อบอกว่าข้อมูลได้มีการเปลี่ยนแปลงแล้ว
    notifyListeners();
  }

  // pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    _audioPlayers.pause();

    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // pause current song
  void pauses() async {
    await _audioPlayers.pause();
    _isPlayings = false;
    notifyListeners();
  }

  // resume playing
  void resumes() async {
    await _audioPlayers.resume();
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
    _audioPlayers.pause();
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

  // play next song
  void playNextSongs() {
    if (_currentSongStream != null) {
      // ถึงเพลงสุดท้ายหรือยัง
      if (_currentSongStream! < _playlist.length - 1) {
        // go to next song if its not the last song
        shuffleAndPlay();
        // plays();
      } else {
        // if last song, back to first song
        _currentSongStream = 0;
        plays();
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

    _audioPlayers.onDurationChanged.listen((Duration) {
      _totalStreamDuration = Duration;
      notifyListeners();
    });
    // listen for current duration
    _audioPlayers.onPositionChanged.listen((Position) {
      _streamDuration = Position;
      notifyListeners();
    });
    // listen for song complete
    _audioPlayers.onPlayerComplete.listen((event) {
      playNextSongs();
    });
  }

  // Method เพื่ออัปเดตสถานะของเพลง
  void updateFavoriteStatus(int index, bool isFavorite) {
    _playlist[index].isFavorite = isFavorite;
    notifyListeners();
  }

  // random music in playlist
  void shuffleAndPlay() {
    if (_playlist.isNotEmpty) {
      Random random = Random();
      int randomIndex = random.nextInt(_playlist.length);
      _currentSongStream = randomIndex;
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
    isMuted = !isMuted;
    _audioPlayers.setVolume(isMuted ? 0 : 1);
  }

  List<Song> get playlist => _playlist;

  int? get currentSongIndex => _currentSongIndex;
  int? get currentSongStream => _currentSongStream;

  bool get isPlaying => _isPlaying;
  bool get isPlayings => _isPlayings;

  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  Duration get streamDuration => _streamDuration;
  Duration get totalStreamDuration => _totalStreamDuration;

  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }

  set currentSongStream(int? newindex) {
    _currentSongStream = newindex;
    if (newindex != null) {
      plays();
    }
    notifyListeners();
  }
}
