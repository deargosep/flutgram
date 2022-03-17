import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class MusicScreen extends HookWidget {
  MusicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Music music = Get.put(Music(), tag: 'music');
    final AudioPlayer audioPlayer = music.audioPlayer;
    final buffered = useState(Duration.zero);
    final playing = useState(false);
    audioPlayer.playingStream.listen((event) {
      playing.value = event;
    });
    audioPlayer.bufferedPositionStream.listen((event) {
      buffered.value = event;
    });
    return Scaffold(
      body: StreamBuilder<SequenceState?>(
        stream: audioPlayer.sequenceStateStream,
        builder: (context, snapshot) {
          final state = snapshot.data;
          final sequence = state?.sequence ?? [];

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // return Container();
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    for (var i = 0; i < sequence.length; i++)
                      ListTile(
                        selected: i == state?.currentIndex,
                        // leading: Image.network(sequence[i].tag.artwork),
                        title: Text(sequence[i].tag),
                        onTap: state?.currentIndex == i
                            ? () {
                                playing.value
                                    ? audioPlayer.pause()
                                    : audioPlayer.play();
                              }
                            : () {
                                audioPlayer.seek(Duration.zero, index: i);
                                audioPlayer.play();
                              },
                      ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                height: MediaQuery.of(context).size.height / 7,
                child: StreamBuilder<Duration>(
                    stream: audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Text(state?.currentSource?.tag),
                          SizedBox(
                            height: 10,
                          ),
                          ProgressBar(
                            total:
                                state!.currentSource!.duration ?? Duration.zero,
                            progress: snapshot.data ?? Duration.zero,
                            buffered: buffered.value,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: audioPlayer.hasPrevious
                                      ? () {
                                          audioPlayer.seekToPrevious();
                                        }
                                      : null,
                                  icon: Icon(Icons.skip_previous)),
                              IconButton(
                                  onPressed: () {
                                    if (playing.value) {
                                      audioPlayer.pause();
                                    } else {
                                      audioPlayer.play();
                                    }
                                  },
                                  icon: Icon(playing.value
                                      ? Icons.pause
                                      : Icons.play_arrow)),
                              IconButton(
                                  onPressed: () {
                                    audioPlayer.seekToNext();
                                  },
                                  icon: Icon(Icons.skip_next))
                            ],
                          )
                        ],
                      );
                    }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Music {
  late ConcatenatingAudioSource _playlist;
  final AudioPlayer audioPlayer = Get.put(AudioPlayer(), tag: 'audioPlayer');
  void _setInitialPlaylist() async {
    const prefix = 'https://www.soundhelix.com/examples/mp3';
    final song1 = Uri.parse('$prefix/SoundHelix-Song-1.mp3');
    final song2 = Uri.parse('$prefix/SoundHelix-Song-2.mp3');
    final song3 = Uri.parse('$prefix/SoundHelix-Song-3.mp3');
    _playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(song1, tag: 'Song 1'),
      AudioSource.uri(song2, tag: 'Song 2'),
      AudioSource.uri(song3, tag: 'Song 3'),
    ]);
    audioPlayer.setAudioSource(_playlist);
  }

  Music() {
    print('Music is initialized');
    _setInitialPlaylist();
  }
}
