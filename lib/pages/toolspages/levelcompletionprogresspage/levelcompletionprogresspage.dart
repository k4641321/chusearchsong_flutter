import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chusearchsong_flutter/function/toolsfun/levelcompletionprogresspagefun/levelcompletionprogresspagefun.dart';
import 'package:chusearchsong_flutter/pages/toolspages/levelcompletionprogresspage/sharelevelcompletionprogresspage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class LevelCompletionProgressPage extends StatefulWidget {
  const LevelCompletionProgressPage({super.key});
  @override
  State<StatefulWidget> createState() => _LevelCompletionProgressPageState();
}

class _LevelCompletionProgressPageState
    extends State<LevelCompletionProgressPage> {
  List level = [1, 1.9];
  Widget result = CircularProgressIndicator();
  final ScrollController _scrollController = ScrollController();
  late Map<String, dynamic> songsData;
  late Map<String, dynamic> allScoreData;

  //初始化数据，避免每次筛选都要重新读取，会慢似的
  Future<void> init() async {
    try {
      final path = await getApplicationSupportDirectory();
      songsData = await jsonDecode(
        await File('${path.path}/res/songs.json').readAsString(),
      );
      allScoreData = await jsonDecode(
        await File('${path.path}/res/allscore.json').readAsString(),
      );
      update();
      // print(songsData);
      // print(allScoreData);
    } catch (e, strack) {
      log('$e\n$strack');
      songsData = {};
      allScoreData = {};
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误：$e\n$strack')));
    }
  }

  void update() {
    if (!mounted) return;
    Widget result2 = buildsongList(
      songsData: songsData,
      allScoreData: allScoreData,
      level: level,
      context: context,
      scrollController: _scrollController,
    );
    setState(() {
      result = result2;
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
          try {
            _scrollController.jumpTo(0);
          } catch (e) {
            return;
          }
        },
      ),
      appBar: AppBar(
        title: Text('等级完成进度'),
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Sharelevelcompletionprogresspage(
                  level: level,
                  songsdata: songsData,
                  allScoreData: allScoreData,
                ),
              ),
            ),
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: Column(
        children: [
          buildLevelDropdownMenu(
            onSelected: (value) async {
              level = value;
              if (songsData.isEmpty | allScoreData.isEmpty) {
                if (!mounted) return;
                setState(() {
                  result = Text('错误：数据为空');
                });
              } else {
                update();
              }
            },
          ),
          Expanded(child: result),
        ],
      ),
    );
  }
}
