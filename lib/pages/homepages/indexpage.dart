import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/commonfun.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:chusearchsong_flutter/function/toolsfun/levelcompletionprogresspagefun/sharelevelcompletionprogresspagefun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/playerinfopagefun.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';

class Indexpage extends StatefulWidget {
  const Indexpage({super.key});

  @override
  State<Indexpage> createState() => _IndexpageState();
}

class _IndexpageState extends State<Indexpage> {
  Map<String, dynamic> playerInfoData = {};
  String _filter = 'week';
  Map<String, dynamic> weekData = {};
  Map<String, dynamic> monthData = {};
  Map<String, dynamic> songsData = {};
  List<Widget> weekWidgets = [Text('加载中...')];
  List<Widget> monthWidgets = [Text('加载中...')];
  List<Widget> listChildren = [];
  bool isLoading = true;

  Widget _buildWeekSongCard(Map<String, dynamic> songData) {
    int songid = songData['id'];
    Map<String, dynamic> songbasedata = {};
    for (var j in songsData['songs']) {
      if (songData['id'] == j['id']) {
        songbasedata = j;
        if (((j['difficulties'] as List).last as Map).containsKey(
          'origin_id',
        )) {
          songid = ((j['difficulties'] as List).last as Map)['origin_id'];
        }
        break;
      }
    }

    return InkWell(
      onTap: () => interSongInfo(
        songbasedata: songbasedata,
        songsData: songsData,
        context: context,
      ),
      child: Card(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(right: 5),
                child: CachedNetworkImage(
                  imageUrl:
                      'https://assets2.lxns.net/chunithm/jacket/$songid.png',
                  height: 75,
                  width: 75,
                  errorWidget: (context, url, error) => Text('图片加载失败'),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      songData['title'],
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      songData['artist'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Card(
                      color: diffcolor(diffindex: songData['level_index']),
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(5),
                        child: Text(
                          '${songData['level']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.only(left: 5),
                child: Column(
                  children: [
                    Text('${songData['rank']}'),
                    songData['previous_rank'] == null
                        ? const Text('NEW')
                        : songData['rank'] == songData['previous_rank']
                        ? const Text('-')
                        : Text(
                            "${songData['previous_rank'] - songData['rank']}",
                            style: TextStyle(
                              color:
                                  songData['previous_rank'] - songData['rank'] >
                                      0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> init() async {
    try {
      playerInfoData = await (await ReadData.create()).readPlayerInfoData();
      songsData = SongDataStore.instance.songsData;
      weekData = jsonDecode(await requestHotSong('week'))['data'];
      monthData = jsonDecode(await requestHotSong('month'))['data'];
      setState(() {});
      _update();
    } catch (e, s) {
      log('$e\n$s');
    }
  }

  Future<void> _update() async {
    if (isLoading == true) {
      List<Widget> weekWidgetsResult = [];
      for (var i in weekData['songs']) {
        weekWidgetsResult.add(_buildWeekSongCard(i));
      }
      List<Widget> weekWonthResult = [];
      for (var i in monthData['songs']) {
        weekWonthResult.add(_buildWeekSongCard(i));
      }
      weekWidgets = weekWidgetsResult;
      monthWidgets = weekWonthResult;
    }
    setState(() {
      if (_filter == 'week') {
        listChildren = weekWidgets;
      } else {
        listChildren = monthWidgets;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('主页'), backgroundColor: Colors.transparent),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Card(
              child: Padding(
                padding: EdgeInsetsGeometry.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PLAYER OVERVIEW', textAlign: TextAlign.left),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (playerInfoData['character'] != null)
                          CachedNetworkImage(
                            width: 100,
                            height: 100,
                            imageUrl:
                                'https://assets2.lxns.net/chunithm/character/${playerInfoData['character']['id']}.png',
                            errorWidget: (context, error, stackTrace) =>
                                Text('图片加载失败'),
                          ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${playerInfoData.isNotEmpty ? playerInfoData['name'] : null}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                // SizedBox(width: 10),
                                // Text('PLAYER NAME'),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                                color: playerInfoData.isNotEmpty
                                    ? returnTrophyBackgroundColor(
                                        playerInfoData['trophy']?['color'],
                                      )
                                    : null,
                              ),
                              padding: EdgeInsets.all(6),
                              child: Text(
                                playerInfoData.isNotEmpty
                                    ? (playerInfoData['trophy']?['name'] ??
                                          'null')
                                    : 'null',

                                style: TextStyle(
                                  color: returnTrophyColor(
                                    playerInfoData.isNotEmpty
                                        ? (playerInfoData['trophy']?['color'])
                                        : null,
                                  ),
                                  shadows: [
                                    Shadow(
                                      color: returnTrophyColor(
                                        playerInfoData.isNotEmpty
                                            ? (playerInfoData['trophy']?['color'])
                                            : null,
                                      ),
                                      blurRadius: 3.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '${playerInfoData.isNotEmpty ? playerInfoData['rating'] : null}',
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(width: 10),
                                Text('TOTAL RATING'),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'LV. ${playerInfoData.isNotEmpty ? playerInfoData['level'] : null}',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Row(
                    //   children: [
                    //     Text.rich(
                    //       TextSpan(
                    //         text: 'Best35',
                    //         children: [TextSpan(text: '154')],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Text(
            '热门歌曲',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Expanded(
                child: SegmentedButton(
                  segments: [
                    ButtonSegment(value: 'week', label: Text('周')),
                    ButtonSegment(value: 'month', label: Text('月')),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (Set<String> newSelection) {
                    setState(() {
                      _filter = newSelection.first; // 单选时取第一个
                    });
                    _update();
                  },
                ),
              ),
            ],
          ),
          Expanded(child: ListView(children: listChildren)),
        ],
      ),
    );
  }
}
