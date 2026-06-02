import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
// import 'dart:developer';
import './musicpage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../tools/songinfopagefun.dart';

class SongInfoPage extends StatefulWidget {
  final Map<String, dynamic> song;
  final String versionname;
  // final List<DataRow> rowsData;
  final List<Widget> rowsData;
  final List<Widget> information;
  final int songid;
  const SongInfoPage({
    super.key,
    required this.song,
    required this.versionname,
    required this.rowsData,
    required this.information,
    required this.songid,
  });

  @override
  State<SongInfoPage> createState() => _SongInfoPageState();
}

class _SongInfoPageState extends State<SongInfoPage> {
  IconData icon = Icons.favorite_border;

  Future<void> _add() async {
    try {
      final favoriteJsonPath =
          '${(await getApplicationSupportDirectory()).path}/files/favorite.json';
      String favoriteJsonStr = await File(favoriteJsonPath).readAsString();
      List<dynamic> favoriteJson = json.decode(favoriteJsonStr);
      List<dynamic> willadd = [];
      final exists = favoriteJson.any(
        (item) => item['id'] == widget.song['id'],
      );
      if (exists) {
        log('已添加');
      } else {
        favoriteJson.add(widget.song); // 只添加一次
        log('添加成功');
      }

      favoriteJson.addAll(willadd);
      favoriteJsonStr = json.encode(favoriteJson);
      File(favoriteJsonPath).writeAsStringSync(favoriteJsonStr);
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

  Future<void> _remove() async {
    try {
      final favoriteJsonPath =
          '${(await getApplicationSupportDirectory()).path}/files/favorite.json';
      String favoriteJsonStr = await File(favoriteJsonPath).readAsString();
      List<dynamic> favoriteJson = json.decode(favoriteJsonStr);
      favoriteJson.removeWhere((item) => item['id'] == widget.song['id']);
      favoriteJsonStr = json.encode(favoriteJson);
      File(favoriteJsonPath).writeAsStringSync(favoriteJsonStr);
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

  Future<void> _buttonIcon() async {
    try {
      final favoriteJsonPath =
          '${(await getApplicationSupportDirectory()).path}/files/favorite.json';
      String favoriteJsonStr = await File(favoriteJsonPath).readAsString();
      List<dynamic> favoriteJson = json.decode(favoriteJsonStr) as List;
      bool isFavorite = false;
      for (var i in favoriteJson) {
        if (i['id'] == widget.song['id']) {
          isFavorite = true;
          log('已收藏');
          break;
        }
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

  @override
  void initState() {
    super.initState();
    _buttonIcon();
  }

  @override
  Widget build(BuildContext context) {
    // const columnsdata = [
    //   DataColumn(label: Text('level')),
    //   DataColumn(label: Text('tap')),
    //   DataColumn(label: Text('hold')),
    //   DataColumn(label: Text('slide')),
    //   DataColumn(label: Text('air')),
    //   DataColumn(label: Text('flick')),
    //   DataColumn(label: Text('total')),
    //   DataColumn(label: Text('谱师')),
    // ];
    final ScrollController controller = ScrollController();
    final ScrollController tabbarcontroller = ScrollController();
    // final ScrollController infocontroller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.song['title']}    - 歌曲详情'),
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
        actions: [
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
                    'https://assets2.lxns.net/chunithm/jacket/${widget.songid}.png',
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('图片加载失败');
                    },
                    width: 200,
                    height: 200,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayMusic(song: widget.song),
                      ),
                    );
                  },
                ),

                TextButton(
                  onPressed: () async {
                    try {
                      final Uri url = Uri.parse(
                        'bilibili://search?keyword=${widget.song['title']}谱面确认',
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
                          color: Theme.of(context).colorScheme.onSecondary,
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(children: [Icon(Icons.info), Text('基本信息')]),
                                Text(
                                  '分类： ${widget.song['genre']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '版本： ${widget.versionname}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  'BPM:  ${widget.song['bpm']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Text(
                                  '曲师： ${widget.song['artist']}',
                                  style: const TextStyle(fontSize: 15),
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
                          color: Theme.of(context).colorScheme.onSecondary,
                          child: Padding(
                            padding: EdgeInsetsGeometry.all(8),
                            child: Column(children: widget.information),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                DefaultTabController(
                  length: widget.song['difficulties'].length,

                  child: Column(
                    children: [
                      TabBar(tabs: returnDiffTabBar(song: widget.song)),
                      SizedBox(
                        height: 700, //MediaQuery.of(context).size.height * 0.8,
                        child: TabBarView(children: widget.rowsData),
                      ),
                    ],
                  ),
                ),

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: DataTable(
                //     columns: columnsdata,
                //     rows: widget.rowsData,
                //     showBottomBorder: true,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
