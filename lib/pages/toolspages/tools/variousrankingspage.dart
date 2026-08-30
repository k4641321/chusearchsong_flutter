import 'dart:convert';
import 'dart:developer';

import 'package:chusearchsong_flutter/function/list.dart';
import 'package:chusearchsong_flutter/function/toolsfun/variousrankingspagefun.dart';
import 'package:flutter/material.dart';

class Variousrankingspage extends StatefulWidget {
  const Variousrankingspage({super.key});

  @override
  State<Variousrankingspage> createState() => _VariousrankingspageState();
}

class _VariousrankingspageState extends State<Variousrankingspage> {
  List<Widget> items = [];
  Map<String, dynamic> songsData = {};
  String type = 'MAS定数';
  bool reverse = true;
  List zxzrSongsData = [];
  int selecteddiffindex = 0;
  Future<void> init() async {
    try {
      songsData = await loadSongs();
      zxzrSongsData = await loadzxzrSongs();
    } catch (e, strack) {
      log('$e\n$strack');
      setState(() {
        items = [Text('错误，可能文件缺失\n$e,\n$strack')];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> viewResult() async {
    try {
      final workingSongsData = jsonDecode(jsonEncode(songsData));
      final workingzxzrSongsData = jsonDecode(jsonEncode(zxzrSongsData));
      final result = sortSongs(
        context: context,
        songs: workingSongsData,
        zxzrSongs: workingzxzrSongsData,
        type: type,
        reverse: reverse,
        diffindex: selecteddiffindex,
      );
      setState(() {
        items = result;
      });
    } catch (e, strack) {
      setState(() {
        items = [Text('错误，可能文件缺失\n$e,\n$strack')];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('各种排行榜'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                reverse = !reverse;
              });
              viewResult();
            },
            icon: Icon(Icons.swap_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          buildDropDownMenu((value) {
            type = value;
            if ((value as String).contains('总数') || value.contains('数量')) {
              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text('选择难度'),
                  children: [
                    ListTile(
                      title: Text('ULT'),
                      onTap: () {
                        selecteddiffindex = 4;
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text('MAS'),
                      onTap: () {
                        selecteddiffindex = 3;
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text('EXP'),
                      onTap: () {
                        selecteddiffindex = 2;
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text('ADV'),
                      onTap: () {
                        selecteddiffindex = 1;
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text('BAS'),
                      onTap: () {
                        selecteddiffindex = 0;
                        Navigator.of(context).pop();
                      },
                    ),
                    ListTile(
                      title: Text('World\'s End'),
                      onTap: () {
                        selecteddiffindex = 5;
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            }
          }),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => viewResult(),
                  child: Text('查看'),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => items[index],
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}
