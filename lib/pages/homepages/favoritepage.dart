import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import '../../function/fun.dart';
import '../../function/favoritepagefun.dart';
import '../../function/toolsfun/generateb50fun/generateb50.dart';

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
      List<Widget> songInfoDiffs = [];
      String versionname = '';
      int songid = i['id'];
      for (var j in songData['versions']) {
        if (j['version'] == i['version']) {
          versionname = j['title'];
        }
      }
      for (var k in i['difficulties']) {
        songInfoDiffs.add(
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(5)),
            ),
            color: diffcolor(diffindex: k['difficulty']),
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                left: 8,
                right: 8,
                top: 3,
                bottom: 3,
              ),

              child: Text(
                k['level_value'].toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
        if ((k as Map<String, dynamic>).containsKey('origin_id')) {
          songid = k['origin_id'];
        }
      }

      // songresultWidget.add(const Divider());
      if (!mounted) return;
      favoriteResults.add(
        returnSongCard(
          songbasedata: i,
          versionname: versionname,
          context: context,
        ),
        // InkWell(
        //   // key: ValueKey(i['id']),
        //   onTap: () async {
        //     interSongInfo(
        //       songbasedata: i,
        //       context: context,
        //       versionname: versionname,
        //     );
        //   },

        //   child: Card(
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(0.0),
        //     ),
        //     child: Padding(
        //       padding: EdgeInsetsGeometry.all(10.0),
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Padding(
        //             padding: EdgeInsetsGeometry.only(right: 10),
        //             child: CachedNetworkImage(
        //               imageUrl:
        //                   'https://assets2.lxns.net/chunithm/jacket/$songid.png',
        //               width: 95,
        //               height: 95,
        //               errorWidget: (context, url, error) => Text('加载失败'),
        //             ),
        //           ),
        //           Expanded(
        //             child: Column(
        //               children: [
        //                 Row(
        //                   children: [
        //                     Expanded(
        //                       child: Text(
        //                         '${i['title']}',
        //                         overflow: TextOverflow.ellipsis,
        //                         style: TextStyle(
        //                           fontSize: 20,
        //                           fontWeight: FontWeight.bold,
        //                         ),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     Expanded(
        //                       child: Text(
        //                         '${i['artist']}',
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Row(
        //                   children: [
        //                     Expanded(
        //                       child: Text(
        //                         '#${i['id']}   ${i['genre']} - $versionname',
        //                         overflow: TextOverflow.ellipsis,
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 Wrap(children: songInfoDiffs),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
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
