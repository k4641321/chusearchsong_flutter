import 'dart:convert';
import 'dart:developer';
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
  //添加收藏
  Future<void> _add() async {
    try {
      final favoriteJsonPath =
          '${(await getApplicationSupportDirectory()).path}/files/favorite.json';
      String favoriteJsonStr = await File(favoriteJsonPath).readAsString();
      List<dynamic> favoriteJson = json.decode(favoriteJsonStr);
      List<dynamic> willadd = [];
      final exists = favoriteJson.any(
        (item) => item['id'] == widget.songbasedata['id'],
      );
      if (exists) {
        log('已添加');
      } else {
        favoriteJson.add(widget.songbasedata);
        log('添加成功');
      }

      favoriteJson.addAll(willadd);
      favoriteJsonStr = json.encode(favoriteJson);
      File(favoriteJsonPath).writeAsStringSync(favoriteJsonStr);
      if (!mounted) return;
      setState(() {
        icon = Icons.favorite;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('成功')));
    } catch (e) {
      log('错误', name: 'songinfopage', level: 1000);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('添加失败')));
    }
  }

  //移除收藏
  Future<void> _remove() async {
    try {
      final favoriteJsonPath =
          '${(await getApplicationSupportDirectory()).path}/files/favorite.json';
      String favoriteJsonStr = await File(favoriteJsonPath).readAsString();
      List<dynamic> favoriteJson = json.decode(favoriteJsonStr);
      favoriteJson.removeWhere(
        (item) => item['id'] == widget.songbasedata['id'],
      );
      favoriteJsonStr = json.encode(favoriteJson);
      File(favoriteJsonPath).writeAsStringSync(favoriteJsonStr);
      if (!mounted) return;
      setState(() {
        icon = Icons.favorite_border;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('成功')));
    } catch (e) {
      log('错误', name: 'songinfopage', level: 1000);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('删除失败')));
    }
  }

  //收藏按钮状态
  Future<void> _buttonIcon() async {
    try {
      final favoriteJsonPath =
          '${(await getApplicationSupportDirectory()).path}/files/favorite.json';
      String favoriteJsonStr = await File(favoriteJsonPath).readAsString();
      List<dynamic> favoriteJson = json.decode(favoriteJsonStr) as List;
      bool isFavorite = false;
      for (var i in favoriteJson) {
        if (i['id'] == widget.songbasedata['id']) {
          isFavorite = true;
          log('已收藏');
          break;
        }
        if (!mounted) return;
      }
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
    setState(() {
      relatedCollectibles = result;
    });
  }

  //加载歌曲其余信息
  Future<void> loadinformation() async {
    List<Widget> result = await returnSongInformation(
      songid: widget.songbasedata['id'],
    );
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
        Text('谱面属性: $kanjiText', style: const TextStyle(fontSize: 15)),
      );
    }

    final star = songInfoDiffs.lastWhere(
      (d) => d.keys.contains('star'),
      orElse: () => null,
    );
    if (star != null) {
      final starValue = star['star'];
      result.add(Text('星数: $starValue', style: const TextStyle(fontSize: 15)));
    }
    if (result.isEmpty) {
      return;
    } else {
      result.insert(
        0,
        Row(children: [Icon(Icons.public), Text('World\'s End信息')]),
      );
      setState(() {
        worldsendinformation = Row(
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
      setState(() {
        difficultyChartInfo = result;
      });
    } catch (e, strack) {
      log('$e \n $strack', name: 'songinfopage.dart', level: 1000);
      setState(() {
        difficultyChartInfo = Text('错误 $e \n $strack');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _buttonIcon();
    loadinformation();
  }

  @override
  void didChangeDependencies() {
    loadrelatedCollectibles();
    loadworldsendinformation(songbasedata: widget.songbasedata);
    loadChartInfoAndSocre();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onLongPress: () =>
              copytext(text: widget.songbasedata['title'], context: context),
          child: Text('${widget.songbasedata['title']}    - 歌曲详情'),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Songshareviewpage(songid: widget.songbasedata['id']),
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
              if (icon == Icons.favorite_border) {
                _add();
              } else if (icon == Icons.favorite) {
                _remove();
              }
            },
            icon: Icon(icon),
          ),
        ],
      ),
      body: Scrollbar(
        controller: controller,
        interactive: true,
        child: SingleChildScrollView(
          controller: controller,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  child: Image.network(
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

                TextButton(
                  onPressed: () async {
                    try {
                      final Uri url = Uri.parse(
                        'bilibili://search?keyword=${widget.songbasedata['title']}谱面确认',
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else if (!await canLaunchUrl(url)) {
                        throw Exception('Could not launch $url');
                      }
                    } catch (e) {
                      log('错误', name: 'songinfopage', level: 1000);
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
                Row(
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(children: [Icon(Icons.info), Text('基本信息')]),
                                Text(
                                  '落雪id： ${widget.songbasedata['id']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '分类： ${widget.songbasedata['genre']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '版本： ${widget.versionname}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'BPM:  ${widget.songbasedata['bpm']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                InkWell(
                                  onLongPress: () => copytext(
                                    text: widget.songbasedata['artist'],
                                    context: context,
                                  ),
                                  child: Text(
                                    '曲师： ${widget.songbasedata['artist']}',
                                    style: const TextStyle(fontSize: 15),
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
                Row(
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
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Card(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(8),
                            child: Column(children: widget.alias),
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
                        child: Card(
                          color: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer,
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(8),
                            child: Column(children: relatedCollectibles),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                worldsendinformation,
                difficultyChartInfo,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
