import 'dart:developer';

import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/list.dart';
import 'package:chusearchsong_flutter/pages/toolspages/information/linkedversepage/gateinfopage.dart';
import 'package:flutter/material.dart';

class Linkedversepage extends StatefulWidget {
  const Linkedversepage({super.key});

  @override
  State<Linkedversepage> createState() => _LinkedversepageState();
}

class _LinkedversepageState extends State<Linkedversepage> {
  Widget child = Text('加载中...');
  Map<String, dynamic> linkedverseData = {};
  Map<String, dynamic> songsData = {};

  Future<void> init() async {
    try {
      linkedverseData = await loadLinkedVerseData();
      songsData = await loadSongs();
      List<Widget> children = [];
      for (var i in linkedverseData['gate']) {
        children.add(
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Gateinfopage(
                  gatedata: i,
                  songsData: songsData,
                  linklevel: linkedverseData['condition']['link_level'],
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Card(
                child: Padding(
                  padding: EdgeInsetsGeometry.all(8),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsetsGeometry.only(right: 20),
                        child: Image.asset('res/linkedverse/${i['id']}.webp'),
                      ),
                      Expanded(
                        child: Text(
                          '${i['name']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
      setState(() {
        child = ListView.builder(
          itemBuilder: (context, index) => children[index],
          itemCount: children.length,
        );
      });
    } catch (e, strack) {
      log('$e\n$strack');
      setState(() {
        child = Text('可能资源文件确缺失，请前往关于界面更新数据（所属基础数据\n错误: $e\n$strack');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Linked Verse')),
      body: Column(children: [Expanded(child: child)]),
    );
  }
}
