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
    Song(
        songName: "Ransom.mp3",
        artistName: "Lil Tecca",
        albumArtImagePath: "assets/image/Ransom.png",
        audioPath: "audio/Ransom.mp3",
        isFavorite: false),
    Song(
        songName: "ตื่นขึ้นมาเติม",
        artistName: "1MILL",
        albumArtImagePath: "assets/image/ตื่นเช้าขึ้นมาเติม.jpg",
        audioPath: "audio/ตื่นเช้าขึ้นมาเติม.mp3",
        isFavorite: false),
    Song(
        songName: "Travis Scott",
        artistName: "I KNOW",
        albumArtImagePath: "assets/image/IKNOW.jpg",
        audioPath: "audio/IKNOW.mp3",
        isFavorite: false),
    Song(
        songName: "Noticed",
        artistName: "Lil Mosey",
        albumArtImagePath: "assets/image/Noticed.jpg",
        audioPath: "audio/Noticed.mp3",
        isFavorite: false),
    Song(
        songName: "Trap Queen",
        artistName: "Fetty Wap",
        albumArtImagePath: "assets/image/Trap Queen.jpg",
        audioPath: "audio/Trap Queen.mp3",
        isFavorite: false),
    Song(
        songName: "Keep cold",
        artistName: "Numcha",
        albumArtImagePath: "assets/image/Keep cold.jpg",
        audioPath: "audio/Keep cold.mp3",
        isFavorite: false),
    Song(
        songName: "Love Yourself",
        artistName: "Justin Bieber",
        albumArtImagePath: "assets/image/Love Yourself.png",
        audioPath: "audio/Love Yourself.mp3",
        isFavorite: false),
    Song(
        songName: "ROCKSTAR",
        artistName: "The Weekend",
        albumArtImagePath: "assets/image/ROCKSTAR.jpg",
        audioPath: "audio/ROCKSTAR.mp3",
        isFavorite: false),
    Song(
        songName: "20 Min",
        artistName: "Lil Uzi Vert",
        albumArtImagePath: "assets/image/20min.jpg",
        audioPath: "audio/20min.mp3",
        isFavorite: false),
    Song(
        songName: "Kill Bill)",
        artistName: "SZA",
        albumArtImagePath: "assets/image/Kill Bill.jpg",
        audioPath: "audio/Kill Bill.mp3",
        isFavorite: false),
    Song(
        songName: "Sunflower",
        artistName: "Post Malone",
        albumArtImagePath: "assets/image/Sunflower.jpg",
        audioPath: "audio/Sunflower.mp3",
        isFavorite: false),
    Song(
        songName: "Shut Up My Moms Calling",
        artistName: "Hotel Ugly",
        albumArtImagePath: "assets/image/Shut Up My Moms Calling.jpg",
        audioPath: "audio/Shut Up My Moms Calling.mp3",
        isFavorite: false),
    Song(
        songName: "Magnetic",
        artistName: "ILLIT",
        albumArtImagePath: "assets/image/Magnetic.jpg",
        audioPath: "audio/Magnetic.mp3",
        isFavorite: false),
    Song(
        songName: "HIGHEST IN THE ROOM",
        artistName: "Travis Scott",
        albumArtImagePath: "assets/image/HIGHEST IN THE ROOM.png",
        audioPath: "audio/HIGHEST IN THE ROOM.mp3",
        isFavorite: false),
    Song(
        songName: "I'm Scare",
        artistName: "HK",
        albumArtImagePath: "assets/image/I'm Scare.jpg",
        audioPath: "audio/I'm Scare.mp3",
        isFavorite: false),
    Song(
        songName: "HUMBLE",
        artistName: "Kendrick Lamar",
        albumArtImagePath: "assets/image/HUMBLE.jpg",
        audioPath: "audio/HUMBLE.mp3",
        isFavorite: false),
    Song(
        songName: "Hotline Bling",
        artistName: "Drake",
        albumArtImagePath: "assets/image/Hotline Bling.jpg",
        audioPath: "audio/Hotline Bling.mp3",
        isFavorite: false),
    Song(
        songName: "Write This Down",
        artistName: "Ice Cube X Dr.Dre X MC Ren",
        albumArtImagePath: "assets/image/Write This Down.jpg",
        audioPath: "audio/Write This Down.mp3",
        isFavorite: false),
    Song(
        songName: "In Da Club",
        artistName: "50 Cent",
        albumArtImagePath: "assets/image/In Da Club.jpg",
        audioPath: "audio/In Da Club.mp3",
        isFavorite: false),
    Song(
        songName: "The Box",
        artistName: "Roddy Ricch",
        albumArtImagePath: "assets/image/The Box.jpg",
        audioPath: "audio/The Box.mp3",
        isFavorite: false),
    Song(
        songName: "Snooze",
        artistName: "SZA",
        albumArtImagePath: "assets/image/Snooze.jpg",
        audioPath: "audio/Snooze.mp3",
        isFavorite: false),
    Song(
        songName: "Wake Up In The Sky",
        artistName: "Bruno Mars",
        albumArtImagePath: "assets/image/Wake Up In The Sky.png",
        audioPath: "audio/Wake Up In The Sky.mp3",
        isFavorite: false),
    Song(
        songName: "Young Wild and Free",
        artistName: "Wiz Khalifa",
        albumArtImagePath: "assets/image/Young Wild and Free.jpg",
        audioPath: "audio/Young Wild and Free.mp3",
        isFavorite: false),
    Song(
        songName: "Kiss Me More",
        artistName: "Doja Cat",
        albumArtImagePath: "assets/image/Kiss Me More.png",
        audioPath: "audio/Kiss Me More.mp3",
        isFavorite: false),
    Song(
        songName: "Hoo Hoo",
        artistName: "Dept",
        albumArtImagePath: "assets/image/Hoo Hoo.jpg",
        audioPath: "audio/Hoo Hoo.mp3",
        isFavorite: false),
    Song(
        songName: "Candy Shop",
        artistName: "50 Cent",
        albumArtImagePath: "assets/image/Candy Shop.jpg",
        audioPath: "audio/Candy Shop.mp3",
        isFavorite: false),
    Song(
        songName: "Smack That",
        artistName: "Akon",
        albumArtImagePath: "assets/image/Smack That.jpg",
        audioPath: "audio/Smack That.mp3",
        isFavorite: false),
    Song(
        songName: "OMG",
        artistName: "NewJeans",
        albumArtImagePath: "assets/image/OMG.jpg",
        audioPath: "audio/OMG.mp3",
        isFavorite: false),
    Song(
        songName: "Reminder",
        artistName: "The Weeknd",
        albumArtImagePath: "assets/image/Reminder.jpg",
        audioPath: "audio/Reminder.mp3",
        isFavorite: false),
    Song(
        songName: "Matsuri",
        artistName: "Fujii Kaze",
        albumArtImagePath: "assets/image/Matsuri.png",
        audioPath: "audio/Matsuri.mp3",
        isFavorite: false),
    Song(
        songName: "Seven",
        artistName: "Jung Kook",
        albumArtImagePath: "assets/image/Seven.jpg",
        audioPath: "audio/Seven.mp3",
        isFavorite: false),
    Song(
        songName: "Sprinter",
        artistName: "Central Cee",
        albumArtImagePath: "assets/image/Sprinter.jpg",
        audioPath: "audio/Sprinter.mp3",
        isFavorite: false),
    Song(
        songName: "Starboy",
        artistName: "The Weekend",
        albumArtImagePath: "assets/image/Starboy.png",
        audioPath: "audio/Starboy.mp3",
        isFavorite: false),
    Song(
        songName: "Paint The Town Red",
        artistName: "Doja Cat",
        albumArtImagePath: "assets/image/Paint The Town Red.jpg",
        audioPath: "audio/Paint The Town Red.mp3",
        isFavorite: false),
    Song(
        songName: "Bad Habit",
        artistName: "Steve Lacy",
        albumArtImagePath: "assets/image/Bad Habit.jpg",
        audioPath: "audio/Bad Habit.mp3",
        isFavorite: false),
    Song(
        songName: "You know how we do it",
        artistName: "Ice cube",
        albumArtImagePath: "assets/image/You know how we do it.jpg",
        audioPath: "audio/You know how we do it.mp3",
        isFavorite: false),
    Song(
        songName: "Heat Waves",
        artistName: "Glass Animals",
        albumArtImagePath: "assets/image/Heat Waves.png",
        audioPath: "audio/Heat Waves.mp3",
        isFavorite: false),
    Song(
        songName: "Beautiful Girls",
        artistName: "Sean Kingston",
        albumArtImagePath: "assets/image/Beautiful Girls.jpg",
        audioPath: "audio/Beautiful Girls.mp3",
        isFavorite: false),
    Song(
        songName: "The Hills",
        artistName: "The Weeknd",
        albumArtImagePath: "assets/image/The Hills.jpg",
        audioPath: "audio/The Hills.mp3",
        isFavorite: false),
    Song(
        songName: "One Of The Girls",
        artistName: "The Weeknd",
        albumArtImagePath: "assets/image/One Of The Girls.jpg",
        audioPath: "audio/One Of The Girls.mp3",
        isFavorite: false),
    Song(
        songName: "Goosebumps",
        artistName: "Travis Scott",
        albumArtImagePath: "assets/image/Goosebumps.jpg",
        audioPath: "audio/Goosebumps.mp3",
        isFavorite: false),
    Song(
        songName: "Mockingbird",
        artistName: "Eminem",
        albumArtImagePath: "assets/image/Mockingbird.jpg",
        audioPath: "audio/Mockingbird.mp3",
        isFavorite: false),
    Song(
        songName: "It Was a Good Day",
        artistName: "Ice Cube",
        albumArtImagePath: "assets/image/It Was a Good Day.jpg",
        audioPath: "audio/It Was a Good Day.mp3",
        isFavorite: false),
    Song(
        songName: "Blueberry Faygo",
        artistName: "Lil Mosey",
        albumArtImagePath: "assets/image/Blueberry Faygo.jpg",
        audioPath: "audio/.mp3",
        isFavorite: false),
    Song(
        songName: "1738",
        artistName: "Fetty Wap",
        albumArtImagePath: "assets/image/1738.jpg",
        audioPath: "audio/1738.mp3",
        isFavorite: false),
    Song(
        songName: "Sweater Weather",
        artistName: "The Neighbourhood",
        albumArtImagePath: "assets/image/Sweater Weather.jpg",
        audioPath: "audio/Sweater Weather.mp3",
        isFavorite: false),
    Song(
        songName: "Somebody That I Used To Know",
        artistName: "Gotye and Kimbra",
        albumArtImagePath: "assets/image/Somebody That I Used To Know.jpg",
        audioPath: "audio/Somebody That I Used To Know.mp3",
        isFavorite: false),
    Song(
        songName: "Do I Wanna Know",
        artistName: "Arctic Monkeys",
        albumArtImagePath: "assets/image/Do I Wanna Know.jpg",
        audioPath: "audio/Do I Wanna Know.mp3",
        isFavorite: false),
    Song(
        songName: "A Lot",
        artistName: "21 Savage",
        albumArtImagePath: "assets/image/A Lot.jpg",
        audioPath: "audio/A Lot.mp3",
        isFavorite: false),
    Song(
        songName: "SICKO MODE",
        artistName: "Travis Scott",
        albumArtImagePath: "assets/image/SICKO MODE.jpg",
        audioPath: "audio/SICKO MODE.mp3",
        isFavorite: false),
    Song(
        songName: "Hit 'Em Up",
        artistName: "Tupac",
        albumArtImagePath: "assets/image/Hit 'Em Up.jpg",
        audioPath: "audio/Hit 'Em Up.mp3",
        isFavorite: false),
    Song(
        songName: "KRYPTONITE",
        artistName: "PUN",
        albumArtImagePath: "assets/image/KRYPTONITE.jpg",
        audioPath: "audio/KRYPTONITE.mp3",
        isFavorite: false),
    Song(
        songName: "Money Trees",
        artistName: "Kendrick Lamar",
        albumArtImagePath: "assets/image/Money Trees.jpg",
        audioPath: "audio/Money Trees.mp3",
        isFavorite: false),
    Song(
        songName: "Here With Me",
        artistName: "d4vd",
        albumArtImagePath: "assets/image/Here With Me.jpg",
        audioPath: "audio/Here With Me.mp3",
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
