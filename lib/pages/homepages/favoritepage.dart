import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../../function/fun.dart';
import '../../function/favoritepagefun.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Widget> favorite = [];
  final ScrollController _scrollController = ScrollController();

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
      List<dynamic> songInfoDiffs = [];
      String versionname = '';
      for (var j in songData['versions']) {
        if (j['version'] == i['version']) {
          versionname = j['title'];
        }
      }
      for (var k in i['difficulties']) {
        songInfoDiffs.add(k['level_value']);
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
            if (!mounted) return;
            _returnfavoriteResults();
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(10.0),
              child: Text(
                '${i['id']} - ${i['title']}      ${i['genre']} - $versionname\n$songInfoDiffs',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }
    if (!mounted) return;
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Icon(Icons.arrow_upward),
        onPressed: () {
          _scrollController.jumpTo(0);
        },
      ),
      body: Center(
        child: Scrollbar(
          controller: _scrollController,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              try {
                                await importFavoriteSong();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('成功')),
                                );
                                _returnfavoriteResults();
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('导入失败')),
                                );
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(8),
                                child: Text(
                                  '导入收藏曲目',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              try {
                                await exportFavoriteSong();
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('成功')),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('导出失败')),
                                );
                              }
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsetsGeometry.all(8),
                                child: Text(
                                  '导出收藏曲目',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SliverList.builder(
                itemBuilder: (context, index) => favorite[index],
                itemCount: favorite.length,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
