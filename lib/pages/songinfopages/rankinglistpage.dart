import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../../function/request.dart';

class RankingListPage extends StatefulWidget {
  final int songid;
  final int levelindex;
  const RankingListPage({
    super.key,
    required this.songid,
    required this.levelindex,
  });

  @override
  State<RankingListPage> createState() => _RankingListPageState();
}

class _RankingListPageState extends State<RankingListPage> {
  List<Widget> children = [Text('加载中')];

  Future<void> init() async {
    try {
      List<Widget> cardList = [];
      String resultstr = await requestRankingList(
        id: widget.songid,
        diff: widget.levelindex,
      );
      List result = jsonDecode(resultstr)['data'];
      for (var i in result) {
        String playerName;
        if (!(i as Map).containsKey('player_name')) {
          playerName = '匿名';
        } else {
          playerName = i['player_name'];
        }
        cardList.add(
          Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                '#${i['ranking']}  $playerName  Score: ${i['score']}',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
      setState(() {
        children = cardList;
      });
    } catch (e, stackTrace) {
      log('$e \n $stackTrace', name: 'rankinglistpage.dart', level: 1000);
      if (!mounted) return;
      setState(() {
        children = [Text('加载失败')];
      });
    }
  }

  @override
  void didChangeDependencies() {
    init();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('排行榜')),
      body: Center(child: ListView(children: children)),
    );
  }
}
