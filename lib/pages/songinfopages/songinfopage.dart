import 'dart:convert';
import 'dart:developer';
import 'package:chusearchsong_flutter/function/texttranslate.dart';
import 'package:flutter/material.dart';
import 'musicpage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../function/songinfofun/songinfopagefun.dart';
import '../../function/fun.dart';
import './songshareviewpage.dart';

class SongInfoPage extends StatefulWidget {
  final Map<String, dynamic> songbasedata;
  final String versionname;
  final int originid;
  final List<Widget> alias;
  // final List<Widget> information;

  const SongInfoPage({
    super.key,
    required this.songbasedata,
    required this.versionname,
    required this.originid,
    required this.alias,
    // required this.information,
  });

  @override
  State<SongInfoPage> createState() => _SongInfoPageState();
}

class _SongInfoPageState extends State<SongInfoPage> {
  IconData icon = Icons.favorite_border;
  List<Widget> relatedCollectibles = [Text('加载中')];
  List<Widget> information = [Text('加载中')];
  Widget worldsendinformation = SizedBox.shrink();
  Widget difficultyChartInfo = CircularProgressIndicator();
  List<Widget> alias = [];
  Widget translationtext = SizedBox.shrink();

  //添加收藏
  Future<void> _add() async {
    try {
      Map<String, dynamic> favoriteSongs = await loadFavoriteSong();

      if (!mounted) return;
      List<Widget> children = [];
      for (var i in favoriteSongs.keys.toList()) {
        children.add(
          ListTile(
            title: Text(i),
            onTap: () {
              try {
                if (!(favoriteSongs[i] as List).contains(
                  widget.songbasedata['id'],
                )) {
                  favoriteSongs[i].add(widget.songbasedata['id']);
                } else {
                  return;
                }
                saveFavoriteSong(favoriteSongs);
                _buttonIcon();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('成功')));
                Navigator.pop(context);
              } catch (e, strack) {
                log('$e\n$strack');
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('错误：$e\n$strack')));
              }
            },
          ),
        );
      }
      children.add(
        ListTile(
          title: Text('+', textAlign: TextAlign.center),
          onTap: () {
            try {
              final TextEditingController controller = TextEditingController();
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
                        Map<String, dynamic> favoriteListSongs =
                            await loadFavoriteSong();
                        List favoriteListSongKeys = favoriteListSongs.keys
                            .toList();
                        if (favoriteListSongKeys.contains(controller.text)) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('已存在相同文件')));

                          Navigator.pop(context);
                          return;
                        }
                        favoriteListSongs[controller.text] = [];
                        favoriteListSongs[controller.text].add(
                          widget.songbasedata['id'],
                        );
                        await saveFavoriteSong(favoriteListSongs);
                        if (!context.mounted) return;
                        _buttonIcon();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('确定'),
                    ),
                  ],
                ),
              );
            } catch (e, strack) {
              log('$e\n$strack');
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('错误：$e\n$strack')));
            }
          },
        ),
      );
      await showDialog(
        context: context,
        builder: (context) =>
            SimpleDialog(title: Text('选择收藏夹'), children: children),
      );
    } catch (e, strack) {
      log('$e\n$strack', name: 'songinfopage', level: 1000);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('添加失败\n$e\n$strack')));
    }
  }

  //移除收藏
  Future<void> _remove() async {
    try {
      Map<String, dynamic> favoriteSongs = await loadFavoriteSong();
      List<Widget> children = [];

      for (var i in favoriteSongs.keys.toList()) {
        if ((favoriteSongs[i] as List).contains(widget.songbasedata['id'])) {
          children.add(
            ListTile(
              title: Text(i),
              onTap: () {
                favoriteSongs[i].remove(widget.songbasedata['id']);
                saveFavoriteSong(favoriteSongs);
                if (!mounted) return;
                setState(() {
                  icon = Icons.favorite_border;
                });
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('成功')));
                Navigator.pop(context);
              },
            ),
          );
        }
      }
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) =>
            SimpleDialog(title: Text('选择删除的文件夹'), children: children),
      );
    } catch (e, strack) {
      log('$e\n$strack', name: 'songinfopage', level: 1000);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败\n$e\n$strack')));
    }
  }

  //收藏按钮状态
  Future<void> _buttonIcon() async {
    try {
      Map<String, dynamic> favoriteSongs = await loadFavoriteSong();
      bool isFavorite = false;

      for (var i in favoriteSongs.keys.toList()) {
        if ((favoriteSongs[i] as List).contains(widget.songbasedata['id'])) {
          isFavorite = true;
          log('已收藏');
        }
      }

      if (!mounted) return;

      setState(() {
        icon = isFavorite ? Icons.favorite : Icons.favorite_border;
      });
    } catch (e) {
      log('错误', name: 'songinfopage', level: 1000);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('检查收藏状态失败')));
    }
  }

  //加载收藏品
  Future<void> loadrelatedCollectibles() async {
    List<Widget> result = await returnRelatedCollectibles(
      id: widget.songbasedata['id'],
      context: context,
    );
    if (!mounted) return;
    setState(() {
      relatedCollectibles = result;
    });
  }

  //加载歌曲其余信息
  Future<void> loadinformation() async {
    List<Widget> result = await returnSongInformation(
      songid: widget.songbasedata['id'],
      context: context,
      color: Theme.of(context).colorScheme.primary,
    );
    if (!mounted) return;
    setState(() {
      information = result;
    });
  }

  //加载世界末日信息
  Future<void> loadworldsendinformation({
    required Map<String, dynamic> songbasedata,
  }) async {
    List<Widget> result = [];
    List songInfoDiffs = songbasedata['difficulties'];
    final kanji = songInfoDiffs.lastWhere(
      (d) => d.keys.contains('kanji'),
      orElse: () => null,
    );
    if (kanji != null) {
      final kanjiText = kanji['kanji'];
      result.add(
        InkWell(
          onLongPress: () =>
              copytext(text: kanjiText.toString(), context: context),
          child: Row(
            children: [
              Icon(
                Icons.tune,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(width: 4),
              SizedBox(
                width: 80,
                child: Text('谱面属性: ', style: const TextStyle(fontSize: 15)),
              ),
              SizedBox(width: 50),
              Expanded(child: Text(kanjiText)),
            ],
          ),
        ),
      );
    }

    final star = songInfoDiffs.lastWhere(
      (d) => d.keys.contains('star'),
      orElse: () => null,
    );
    if (star != null) {
      final starValue = star['star'];
      result.add(
        Row(
          children: [
            Icon(
              Icons.star,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 4),
            SizedBox(
              width: 80,
              child: Text('星数:', style: const TextStyle(fontSize: 15)),
            ),
            SizedBox(width: 50),
            Expanded(child: Text(starValue.toString())),
          ],
        ),
      );
    }
    if (result.isEmpty) {
      return;
    } else {
      result.insert(0, SizedBox(height: 10));
      result.insert(
        0,
        Row(
          children: [
            Text(
              'World\'s End信息',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
      if (!mounted) return;
      setState(() {
        worldsendinformation = Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(children: result),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
    }
  }

  //加载谱面信息与成绩
  Future<void> loadChartInfoAndSocre() async {
    try {
      Widget result = await returnChartInfoAndSocre(
        songid: widget.songbasedata['id'],
        color: Theme.of(context).colorScheme.secondaryContainer,
        context: context,
      );
      if (!mounted) return;
      setState(() {
        difficultyChartInfo = result;
      });
    } catch (e, strack) {
      log('$e \n $strack', name: 'songinfopage.dart', level: 1000);
      if (!mounted) return;
      setState(() {
        difficultyChartInfo = Text('错误 $e \n $strack');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _buttonIcon();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadinformation();
      loadrelatedCollectibles();
      loadworldsendinformation(songbasedata: widget.songbasedata);
      loadChartInfoAndSocre();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // appBar: AppBar(
      //   title: InkWell(
      //     onLongPress: () =>
      //         copytext(text: widget.songbasedata['title'], context: context),
      //     child: Text('${widget.songbasedata['title']}    - 歌曲详情'),
      //   ),

      // ),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            title: autoMarqueeText(widget.songbasedata['title']),
            flexibleSpace: FlexibleSpaceBar(
              background: InkWell(
                child: Image.network(
                  height: 350,
                  width: 350,
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.3),
                  colorBlendMode: isDark ? BlendMode.darken : BlendMode.lighten,
                  fit: BoxFit.contain,
                  'https://assets2.lxns.net/chunithm/jacket/${widget.originid}.png',
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('图片加载失败');
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlayMusic(
                        song: widget.songbasedata,
                        songid: widget.originid,
                      ),
                    ),
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  try {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Songshareviewpage(
                          songid: widget.songbasedata['id'],
                        ),
                      ),
                    );
                  } catch (e) {
                    log('错误$e', name: 'songinfopage.dart', level: 1000);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('分享失败')));
                  }
                },
                icon: Icon(Icons.share),
              ),
              IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text('选择操作'),
                      children: [
                        ListTile(
                          title: Text('添加'),
                          onTap: () {
                            _add();
                            Navigator.of(context).pop();
                          },
                        ),
                        ListTile(
                          title: Text('删除'),
                          onTap: () {
                            _remove();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(icon),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    try {
                      String selectdiff = '';
                      List<Widget> difflist = [];
                      for (var i in widget.songbasedata['difficulties']) {
                        switch (i['difficulty']) {
                          case 0:
                            difflist.add(
                              ListTile(
                                title: Text('Basic'),
                                onTap: () => Navigator.of(context).pop('Basic'),
                              ),
                            );
                          case 1:
                            difflist.add(
                              ListTile(
                                title: Text('Advanced'),
                                onTap: () =>
                                    Navigator.of(context).pop('Advanced'),
                              ),
                            );
                          case 2:
                            difflist.add(
                              ListTile(
                                title: Text('Expert'),
                                onTap: () =>
                                    Navigator.of(context).pop('Expert'),
                              ),
                            );
                          case 3:
                            difflist.add(
                              ListTile(
                                title: Text('Master'),
                                onTap: () =>
                                    Navigator.of(context).pop('Master'),
                              ),
                            );
                          case 4:
                            difflist.add(
                              ListTile(
                                title: Text('Ultimate'),
                                onTap: () =>
                                    Navigator.of(context).pop('Ultimate'),
                              ),
                            );
                          case 5:
                            difflist.add(
                              ListTile(
                                title: Text('World\'s End'),
                                onTap: () =>
                                    Navigator.of(context).pop('World\'s End'),
                              ),
                            );
                        }
                      }

                      selectdiff = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('选择难度'),
                            content: SizedBox(
                              height: 300,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: difflist,
                              ),
                            ),
                          );
                        },
                      );
                      final Uri url = Uri.parse(
                        'bilibili://search?keyword=${widget.songbasedata['title']} $selectdiff 谱面确认',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else if (!await canLaunchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    } catch (e, strack) {
                      log('$e\n$strack', name: 'songinfopage', level: 1000);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('打开B站失败')));
                    }
                  },
                  child: Text(
                    '前往B站搜索谱面确认',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      String result = await translateText(
                        sourceText: widget.songbasedata['title'],
                        context: context,
                      );
                      if (!context.mounted) return;
                      setState(() {
                        translationtext = Text(result);
                      });
                    } catch (e, strack) {
                      log('$e\n$strack', name: 'songinfopage', level: 1000);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('翻译失败')));
                    }
                  },
                  child: Text(
                    '翻译歌曲标题',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                translationtext,
                Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '基本信息',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onLongPress: () => copytext(
                                      context: context,
                                      text: widget.songbasedata['id']
                                          .toString(),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.numbers,
                                          size: 18,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        SizedBox(width: 4),
                                        SizedBox(
                                          width: 80,
                                          child: const Text(
                                            '落雪id：',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Expanded(
                                          child: Text(
                                            '${widget.songbasedata['id']}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  InkWell(
                                    onLongPress: () => copytext(
                                      context: context,
                                      text: widget.songbasedata['title']
                                          .toString(),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.music_note,
                                          size: 18,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        SizedBox(width: 4),
                                        SizedBox(
                                          width: 80,
                                          child: const Text(
                                            '曲名：',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Expanded(
                                          child: Text(
                                            '${widget.songbasedata['title']}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  InkWell(
                                    onLongPress: () => copytext(
                                      context: context,
                                      text: widget.songbasedata['genre']
                                          .toString(),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.category,
                                          size: 18,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        SizedBox(width: 4),
                                        SizedBox(
                                          width: 80,
                                          child: const Text(
                                            '分类：',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Expanded(
                                          child: Text(
                                            '${widget.songbasedata['genre']}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  InkWell(
                                    onLongPress: () => copytext(
                                      text: widget.versionname.toString(),
                                      context: context,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.update,
                                          size: 18,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        SizedBox(width: 4),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            '版本：',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Expanded(
                                          child: Text(widget.versionname),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  InkWell(
                                    onLongPress: () => copytext(
                                      text: widget.songbasedata['bpm']
                                          .toString(),
                                      context: context,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.speed,
                                          size: 18,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        SizedBox(width: 4),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            'BPM：',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Expanded(
                                          child: Text(
                                            '${widget.songbasedata['bpm']}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  InkWell(
                                    onLongPress: () => copytext(
                                      text: widget.songbasedata['artist']
                                          .toString(),
                                      context: context,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: 18,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        SizedBox(width: 4),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            '曲师：',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 50),
                                        Expanded(
                                          child: Text(
                                            ' ${widget.songbasedata['artist']}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Column(children: information),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                children: widget.alias,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.secondaryContainer,
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(8),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10,
                                runSpacing: 5,
                                children: relatedCollectibles,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                worldsendinformation,
                difficultyChartInfo,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
