import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chusearchsong_flutter/function/toolsfun/viewallgradespagefun.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Viewallgradespage extends StatefulWidget {
  const Viewallgradespage({super.key});

  @override
  State<Viewallgradespage> createState() => _ViewallgradespageState();
}

class _ViewallgradespageState extends State<Viewallgradespage> {
  List allscore = [];
  Map<String, dynamic> songsdata = {};
  int totalchart = 0;
  int ssspcount = 0;
  int ssscount = 0;
  int fccount = 0;
  int ajcount = 0;
  int ajccount = 0;

  void init() {
    Map<String, dynamic> result = returnScoreData(allscore);
    setState(() {
      totalchart = result['totalchart'];
      ssspcount = result['sssp'];
      ssscount = result['sss'];
      fccount = result['fc'];
      ajcount = result['aj'];
      ajccount = result['ajc'];
    });
    Widget resultlist = returnScoreList(
      allscoredata: allscore,
      songsdata: songsdata,
      context: context,
    );
    setState(() {
      scorelist = resultlist;
    });
  }

  Future<void> loadallscore() async {
    try {
      final path = await getApplicationSupportDirectory();
      allscore = jsonDecode(
        File('${path.path}/res/allscore.json').readAsStringSync(),
      )['data'];
      songsdata = jsonDecode(
        File('${path.path}/res/songs.json').readAsStringSync(),
      );
      init();
    } catch (e, strack) {
      log('$e\n$strack');
      setState(() {
        scorelist = Text('错误，加载成绩失败，请检查是否获取过成绩\n$e\n$strack');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadallscore();
  }

  Widget scorelist = CircularProgressIndicator();
  // Center(child: CircularProgressIndicator());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('所有成绩查看')),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 15,
                      right: 15,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [Text('总谱面数'), Text(totalchart.toString())],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 15,
                      right: 15,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [Text('SSS+'), Text(ssspcount.toString())],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 15,
                      right: 15,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [Text('SSS'), Text(ssscount.toString())],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 15,
                      right: 15,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [Text('FC'), Text(fccount.toString())],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 15,
                      right: 15,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [Text('AJ'), Text(ajcount.toString())],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(
                      left: 15,
                      right: 15,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      children: [Text('AJC'), Text(ajccount.toString())],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(children: [Text('排序方式')]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(children: [Text('排序方式')]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(children: [Text('排序方式')]),
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
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(children: [Text('排序方式')]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(children: [Text('排序方式')]),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(children: [Text('排序方式')]),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: scorelist),
        ],
      ),
    );
  }
}
