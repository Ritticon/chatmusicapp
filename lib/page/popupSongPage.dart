import 'package:chatmusicapp/models/playlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class PopupSong extends StatelessWidget {
  const PopupSong({super.key});

  String formatTime(Duration duration) {
    String twoDigitSecond =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "${duration.inMinutes}:$twoDigitSecond";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(builder: ((context, value, child) {
      final playlist = value.playlist;

      final currentSong = playlist[value.currentSongIndex ?? 0];

      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 25),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Color(0xFFFF6B00),
                        size: 30,
                      ),
                    )
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            child: GestureDetector(
                              onTap: value.playPreviousSong,
                              child: Container(
                                child: Icon(
                                  Icons.skip_previous,
                                  color: Color(0xFFFF6B00),
                                  size: 40,
                                ),
                              ),
                            ),
                          ),
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
                          Expanded(
                            child: GestureDetector(
                              onTap: value.playNextSong,
                              child: Container(
                                  child: Icon(
                                Icons.skip_next,
                                color: Color(0xFFFF6B00),
                                size: 40,
                              )),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
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
                            formatTime(value.currentDuration),
                            style: const TextStyle(
                              fontFamily: 'atma',
                              fontSize: 13,
                              color: Color(0xFFFF6B00),
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 0),
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          activeColor: Color(0xFF733000),
                          inactiveColor: Color(0xFFFF6B00),
                          onChanged: (double double) {},
                          onChangeEnd: (double double) {
                            value.seek(Duration(seconds: double.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }));
  }
}
