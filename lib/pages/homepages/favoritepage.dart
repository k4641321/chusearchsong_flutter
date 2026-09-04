import 'dart:developer';

import 'package:chusearchsong_flutter/function/list.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
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

  /// 操作按钮（带图标的 chip 风格）
  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final effectiveColor = color ?? Theme.of(context).colorScheme.primary;

    return Expanded(
      child: Material(
        color: effectiveColor.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 22, color: effectiveColor),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: effectiveColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      // ── 操作按钮行 ──
                      Row(
                        children: [
                          _buildActionChip(
                            icon: Icons.file_download_outlined,
                            label: '导入',
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
                          ),
                          const SizedBox(width: 8),
                          _buildActionChip(
                            icon: Icons.file_upload_outlined,
                            label: '导出',
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
                          ),
                          const SizedBox(width: 8),
                          _buildActionChip(
                            icon: Icons.create_new_folder_outlined,
                            label: '新建',
                            onTap: () async {
                              try {
                                final controller = TextEditingController();
                                if (!context.mounted) return;
                                final result = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('新建收藏夹'),
                                    content: TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        hintText: '输入名称',
                                        border: OutlineInputBorder(),
                                      ),
                                      autofocus: true,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('取消'),
                                      ),
                                      FilledButton(
                                        onPressed: () async {
                                          final favoriteListSongs =
                                              await loadFavoriteSong();
                                          if (favoriteListSongs.keys.contains(
                                            controller.text,
                                          )) {
                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text('已存在相同名称'),
                                              ),
                                            );
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
                                        child: const Text('确定'),
                                      ),
                                    ],
                                  ),
                                );
                              } catch (e, stack) {
                                log('$e\n$stack');
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('错误：$e')),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 8),
                          _buildActionChip(
                            icon: Icons.delete_outline,
                            label: '删除',
                            color: Theme.of(context).colorScheme.error,
                            onTap: () async {
                              try {
                                final favoriteListSongs =
                                    await loadFavoriteSong();
                                final keys = favoriteListSongs.keys
                                    .where((k) => k != 'favorite')
                                    .toList();
                                if (!context.mounted) return;
                                showDialog(
                                  context: context,
                                  builder: (context) => SimpleDialog(
                                    title: const Text('选择要删除的收藏夹'),
                                    children: keys.map((name) {
                                      return ListTile(
                                        title: Text(name),
                                        onTap: () async {
                                          if (selectedName == name) {
                                            selectedName = 'favorite';
                                          }
                                          favoriteListSongs.remove(name);
                                          await saveFavoriteSong(
                                            favoriteListSongs,
                                          );
                                          await loadFavoriteList();
                                          await _returnfavoriteResults();
                                          if (!context.mounted) return;
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              } catch (e, stack) {
                                log('$e\n$stack');
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('错误：$e')),
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ── 下拉菜单 ──
                      DropdownMenu(
                        key: ValueKey(selectedName),
                        menuHeight: 300,
                        selectOnly: true,
                        expandedInsets: EdgeInsets.zero,
                        leadingIcon: const Icon(Icons.folder_outlined),
                        label: const Text('收藏夹'),
                        width: double.maxFinite,
                        initialSelection: selectedName,
                        onSelected: (value) => setState(() {
                          selectedName = value;
                          _returnfavoriteResults();
                        }),
                        dropdownMenuEntries: dropdownMenuEntries,
                      ),
                    ],
                  ),
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
