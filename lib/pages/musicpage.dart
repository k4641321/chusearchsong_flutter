import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayMusic extends StatefulWidget {
  final int songid;
  const PlayMusic({super.key, required this.songid});

  @override
  State<PlayMusic> createState() => _PlayMusic();
}

class _PlayMusic extends State<PlayMusic> {
  final _musicplayer = AudioPlayer();
  String button = "播放";
  int playerstate = 0;

  @override
  void initState() {
    super.initState();
    _musicplayer.setUrl(
      'https://assets2.lxns.net/chunithm/music/${widget.songid}.mp3',
    );
  }

  @override
  void dispose() {
    _musicplayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('歌曲试听'),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(
              'https://assets2.lxns.net/chunithm/jacket/${widget.songid}.png',
              errorBuilder: (context, error, stackTrace) {
                return const Text('图片加载失败');
              },
            ),
            TextButton(
              onPressed: () {
                if (playerstate == 0) {
                  _musicplayer.play();
                  button = "暂停";
                } else if (playerstate == 1) {
                  _musicplayer.pause();
                  button = "播放";
                }
                setState(() {});
              },
              child: Text(button, style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
