import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class PlayMusic extends StatefulWidget {
  final Map<String, dynamic> song;
  final int songid;
  const PlayMusic({super.key, required this.song, required this.songid});

  @override
  State<PlayMusic> createState() => _PlayMusic();
}

class _PlayMusic extends State<PlayMusic> {
  final _musicplayer = AudioPlayer();
  IconData button = Icons.play_arrow;
  int playerstate = 0;
  double songvalue = 0;
  double position = 0;
  final List<StreamSubscription> _subscription = [];

  @override
  void initState() {
    super.initState();
    _loadMusic();
    _subscriptionadd();
  }

  Future<void> _loadMusic() async {
    try {
      _musicplayer.setReleaseMode(ReleaseMode.stop);
      await _musicplayer.setSourceUrl(
        'https://assets2.lxns.net/chunithm/music/${widget.songid}.mp3',
      );
      log('加载歌曲');
      if (!mounted) return;
      _subscription.add(
        _musicplayer.onPositionChanged.listen((p) {
          final newPos = p.inMilliseconds.toDouble();
          position = newPos > songvalue ? songvalue : newPos;

          setState(() {});
        }),
      );

      _subscription.add(
        _musicplayer.onPlayerStateChanged.listen((state) {
          log('播放器状态: $state');
          setState(() {
            playerstate = state.index;
            log('播放器状态: $playerstate');
          });
        }),
      );
      _subscription.add(
        _musicplayer.onPlayerComplete.listen((_) async {
          await _musicplayer.stop();
          if (!mounted) return;
          setState(() {
            button = Icons.play_arrow;
            playerstate = 0;
          });
        }),
      );
    } catch (e) {
      log('$e', name: 'PlayMusic', level: 1000);
      log('歌曲加载失败');
      try {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('错误'),
              content: Text('歌曲加载失败'),
              actions: [
                TextButton(
                  child: Text('确定'),
                  onPressed: () {
                    Navigator.pop(context);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        log('$e', name: 'PlayMusic', level: 1000);
        if (!mounted) return;
        Navigator.pop(context);
        if (context.mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  Future<void> _subscriptionadd() async {
    try {
      _subscription.add(
        _musicplayer.onDurationChanged.listen((duration) {
          log('歌曲时长: $duration');
          if (!mounted) return;
          setState(() {
            songvalue = duration.inMilliseconds.toDouble();
            log('歌曲时长: $songvalue');
          });
        }),
      );
    } catch (e) {
      log('$e', name: 'musicpage', level: 1000);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('获取歌曲时长失败')));
    }
  }

  @override
  void dispose() {
    for (var subscription in _subscription) {
      subscription.cancel();
    }
    _subscription.clear();
    _musicplayer.dispose();
    if (!mounted) return;
    super.dispose();
  }

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('歌曲试听'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
      ),
      body: Center(
        child: Scrollbar(
          controller: _controller,
          child: SingleChildScrollView(
            controller: _controller,
            child: Column(
              children: [
                Image.network(
                  'https://assets2.lxns.net/chunithm/jacket/${widget.songid}.png',
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('图片加载失败');
                  },
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        '  ${widget.song['title']}',
                        style: TextStyle(fontSize: 20),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '   ${widget.song['artist']}',
                        style: TextStyle(fontSize: 15),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                Slider(
                  value: position,
                  activeColor: Theme.of(context).colorScheme.primary,
                  inactiveColor: Theme.of(context).colorScheme.secondary,
                  onChanged: (value) async {
                    await _musicplayer.seek(
                      Duration(milliseconds: value.toInt()),
                    );
                    setState(() {
                      position = value;
                      log('$value');
                    });
                  },
                  min: 0.0,
                  max: songvalue,
                  allowedInteraction: SliderInteraction.tapAndSlide,
                ),
                Row(
                  children: [
                    Text('${Duration(milliseconds: position.toInt())}'),
                    Expanded(
                      child: Text(
                        '${Duration(milliseconds: songvalue.toInt())}',
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      iconSize: 50,
                      icon: Icon(button),
                      onPressed: () async {
                        try {
                          switch (playerstate) {
                            case 0:
                              await _musicplayer.resume();
                              button = Icons.pause;
                              break;
                            case 1:
                              await _musicplayer.pause();
                              button = Icons.play_arrow;
                              break;
                            case 2:
                              _musicplayer.resume();
                              button = Icons.pause;
                              break;
                            case 3:
                              await _musicplayer.resume();
                              button = Icons.pause;
                              break;
                          }
                        } catch (e) {
                          log('$e', name: 'musicpage', level: 1000);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('歌曲播放失败 $e')));
                        }

                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop),
                      onPressed: () async {
                        try {
                          if (playerstate == 3) {
                            button = Icons.play_arrow;
                            playerstate = 0;
                            await _musicplayer.seek(Duration.zero);
                            setState(() {});
                          }
                          await _musicplayer.pause();
                          button = Icons.play_arrow;
                          playerstate = 0;
                          await _musicplayer.seek(Duration.zero);
                          setState(() {});
                        } catch (e) {
                          log('$e', name: 'PlayMusic', level: 1000);
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('歌曲停止失败 $e')));
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
