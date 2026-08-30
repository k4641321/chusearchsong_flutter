import 'dart:developer';

import 'package:chusearchsong_flutter/function/list.dart';
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
  late final Directory path;
  List favoriteList = [];
  Map<String, dynamic> songsData = {};
  List<DropdownMenuEntry> dropdownMenuEntries = [
    DropdownMenuEntry(value: 'favorite', label: 'favorite'),
  ];
  String selectedName = 'favorite';

  Future<void> init() async {
    path = await getApplicationSupportDirectory();
    songsData = await loadSongs();
    await loadFavoriteList();
    await _returnfavoriteResults();
  }

  Future<void> loadFavoriteList() async {
    Map<String, dynamic> favoriteListSong = await loadFavoriteSong();
    List<DropdownMenuEntry> dropdownMenuEntries1 = [];
    List favoriteListSongKeys = favoriteListSong.keys.toList();
    for (var i in favoriteListSongKeys) {
      dropdownMenuEntries1.add(DropdownMenuEntry(value: i, label: '$i'));
    }
    setState(() {
      dropdownMenuEntries = dropdownMenuEntries1;
    });
    // print(favoriteList);
    // _returnfavoriteResults();
  }

  Future<void> _returnfavoriteResults() async {
    List<Widget> favoriteResults = [];
    Map<String, dynamic> favoriteListSong = await loadFavoriteSong();
    for (var i in favoriteListSong[selectedName]) {
      String versionname = '';
      late Map<String, dynamic> songbasedata;

      // int songid = i['id'];
      for (var j in songsData['songs']) {
        if (i == j['id']) {
          songbasedata = j;
          break;
        }
      }
      for (var j in songsData['versions']) {
        if (j['version'] == songbasedata['version']) {
          versionname = j['title'];
        }
      }

      // songresultWidget.add(const Divider());
      if (!mounted) return;
      favoriteResults.add(
        returnSongCard(
          songbasedata: songbasedata,
          versionname: versionname,
          context: context,
          onReturn: () => _returnfavoriteResults(),
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
    init();
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
                                await importFavoriteSong(context: context);
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
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              try {
                                await exportFavoriteSong(context: context);
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
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              try {
                                final TextEditingController controller =
                                    TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('输入名称'),
                                    content: TextField(controller: controller),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Map<String, dynamic>
                                          favoriteListSongs =
                                              await loadFavoriteSong();
                                          List favoriteListSongKeys =
                                              favoriteListSongs.keys.toList();
                                          if (favoriteListSongKeys.contains(
                                            controller.text,
                                          )) {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text('已存在相同文件'),
                                              ),
                                            );

                                            Navigator.pop(context);
                                            return;
                                          }
                                          favoriteListSongs[controller.text] =
                                              [];
                                          await saveFavoriteSong(
                                            favoriteListSongs,
                                          );
                                          await loadFavoriteList();
                                          await _returnfavoriteResults();
                                          if (!context.mounted) return;

                                          Navigator.pop(context);
                                        },
                                        child: Text('确定'),
                                      ),
                                    ],
                                  ),
                                );
                              } catch (e, strack) {
                                log('$e\n$strack');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('错误：$e\n$strack')),
                                );
                              }
                            },
                            child: Text('新建收藏夹'),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () async {
                              try {
                                List<Widget> children = [];
                                Map<String, dynamic> favoriteListSongs =
                                    await loadFavoriteSong();
                                List favoriteListSongsKeys = favoriteListSongs
                                    .keys
                                    .toList();
                                for (var i in favoriteListSongsKeys) {
                                  if (i == 'favorite') continue;
                                  children.add(
                                    ListTile(
                                      title: Text(i),
                                      onTap: () async {
                                        if (selectedName == i) {
                                          selectedName = 'favorite';
                                        }
                                        favoriteListSongs.remove(i);
                                        await saveFavoriteSong(
                                          favoriteListSongs,
                                        );
                                        await loadFavoriteList();
                                        await _returnfavoriteResults();
                                        if (!context.mounted) return;
                                        Navigator.pop(context);
                                      },
                                    ),
                                  );
                                }
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (context) => SimpleDialog(
                                    title: Text('选择收藏夹'),
                                    children: children,
                                  ),
                                );
                              } catch (e, strack) {
                                log('$e\n$strack');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('错误：$e\n$strack')),
                                );
                              }
                            },
                            child: Text('删除收藏夹'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: DropdownMenu(
                  key: ValueKey(selectedName),
                  menuHeight: 300,
                  selectOnly: true,
                  width: double.maxFinite,
                  initialSelection: selectedName,
                  onSelected: (value) => setState(() {
                    selectedName = value;
                    _returnfavoriteResults();
                  }),
                  dropdownMenuEntries: dropdownMenuEntries,
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
