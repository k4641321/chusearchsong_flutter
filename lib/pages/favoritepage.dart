import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../tools/fun.dart';

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
            await interSongInfo(
              i: i,
              context: context,
              versionname: versionname,
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
