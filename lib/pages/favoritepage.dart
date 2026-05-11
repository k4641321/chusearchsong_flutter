import 'package:flutter/material.dart';
import '../tools/request.dart';
import 'dart:developer';
import './songinfopage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Widget> favorite = [];

  Future<void> _returnfavoriteResults() async {
    List<Widget> favoriteResults = [];
    //加载收藏曲目
    final favoriteJsonPath =
        '${(await getApplicationSupportDirectory()).path}/files/favorite.json';
    String favoriteJsonStr = await File(favoriteJsonPath).readAsString();
    List<dynamic> favoriteJson = json.decode(favoriteJsonStr);
    //加载曲目数据
    final dataPath = await getApplicationSupportDirectory();
    String jsonString = await File(
      '${dataPath.path}/res/songs.json',
    ).readAsString();
    Map<String, dynamic> songData = json.decode(jsonString);
    for (var i in favoriteJson) {
      String versionname = '';
      for (var j in songData['versions']) {
        if (j['version'] == i['version']) {
          versionname = j['title'];
        }
      }
      // songresultWidget.add(const Divider());
      favoriteResults.add(
        InkWell(
          key: ValueKey(i['id']),
          onTap: () async {
            List<DataRow> songData = [];
            Map<String, dynamic> songInfo = {};
            List<dynamic> songInfoDiffs = [];
            try {
              songData = await returnSongInfo(i['id']);
            } catch (e) {
              log('error $e', name: 'search.dart', level: 1000);
            }
            try {
              songInfo = await getSongInfo(i['id']);
              songInfoDiffs = songInfo['difficulties'];
            } catch (e) {
              log('error $e', name: 'search.dart', level: 1000);
            }

            List<Widget> information = [];
            int songid = i['id'];
            if (songInfo.keys.contains('map')) {
              information.add(
                Text(
                  '地图: ${songInfo['map']}',
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }
            if (songInfo.keys.contains('locked')) {
              if (songInfo['locked'] == true) {
                information.add(
                  Text('需解锁', style: const TextStyle(fontSize: 20)),
                );
              } else {
                information.add(
                  Text('无需解锁', style: const TextStyle(fontSize: 20)),
                );
              }
            }
            if (songInfo.keys.contains('rights')) {
              information.add(
                Text(
                  '版权: ${songInfo['rights']}',
                  style: const TextStyle(fontSize: 20),
                ),
              );
            }

            final kanji = songInfoDiffs.lastWhere(
              (d) => d.keys.contains('kanji'),
              orElse: () => null,
            );
            if (kanji != null) {
              final kanjiText = kanji['kanji'];
              information.add(
                Text('谱面属性: $kanjiText', style: const TextStyle(fontSize: 20)),
              );
            }

            final star = songInfoDiffs.lastWhere(
              (d) => d.keys.contains('star'),
              orElse: () => null,
            );
            if (star != null) {
              final starValue = star['star'];
              information.add(
                Text('星数: $starValue', style: const TextStyle(fontSize: 20)),
              );
            }

            if (information.isEmpty) {
              information.add(
                Text('无信息', style: const TextStyle(fontSize: 20)),
              );
            }

            final originid = songInfoDiffs.lastWhere(
              (d) => d.keys.contains('origin_id'),
              orElse: () => null,
            );
            if (originid != null) {
              songid = originid['origin_id'];
            }

            if (!mounted) return;
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SongInfoPage(
                  song: i,
                  versionname: versionname,
                  rowsData: songData,
                  information: information,
                  songid: songid,
                ),
              ),
            );
            _returnfavoriteResults();
            // log('未完成 ${i['id']}');
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: Text(
                '${i['id']} - ${i['title']}      ${i['genre']} - $versionname',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
    setState(() {
      favorite = favoriteResults;
    });
  }

  @override
  void initState() {
    super.initState();
    _returnfavoriteResults();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [Expanded(child: ListView(children: favorite))],
      ),
    );
  }
}
