import 'dart:developer';

import 'package:chusearchsong_flutter/function/list.dart';
import 'package:chusearchsong_flutter/pages/toolspages/information/brandprogresspage/brandprogressinfopage.dart';
import 'package:flutter/material.dart';

class Brandprogresspage extends StatefulWidget {
  const Brandprogresspage({super.key});

  @override
  State<Brandprogresspage> createState() => _BrandprogresspageState();
}

class _BrandprogresspageState extends State<Brandprogresspage> {
  Map<String, dynamic> songsData = {};
  List trophies = [];
  List playhistory = [];

  List<Widget> spiritWidgets = [];
  List<Widget> tributeWidgets = [];
  List<Widget> legendWidgets = [];

  Widget buildtrophiesCard(Map<String, dynamic> trophy) {
    return Material(
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: ((context) => Brandprogressinfopage(
              brandinfo: trophy,
              songsData: songsData,
              playhistory: playhistory,
            )),
          ),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Card(
            child: Column(
              children: [
                Image.network(
                  'https://assets2.lxns.net/chunithm/trophy/${trophy['id']}.png',
                  errorBuilder: (context, error, stackTrace) => Text('图片加载失败'),
                ),
                Text(
                  '${trophy['name']}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> init() async {
    try {
      songsData = await loadSongs();
      trophies = await loadTrophies();
      playhistory = await loadPlayHistory();
      final newSpirit = <Widget>[];
      final newTribute = <Widget>[];
      final newLegend = <Widget>[];
      for (var i in trophies) {
        if ((i['name'] as String).contains('Spirit') && i['color'] == 'image') {
          newSpirit.add(buildtrophiesCard(i));
        } else if ((i['name'] as String).contains('Tribute') &&
            i['color'] == 'image') {
          newTribute.add(buildtrophiesCard(i));
        } else if ((i['name'] as String).contains('Legend') &&
            i['color'] == 'image') {
          newLegend.add(buildtrophiesCard(i));
        }
      }
      if (!mounted) return;
      setState(() {
        spiritWidgets = newSpirit;
        tributeWidgets = newTribute;
        legendWidgets = newLegend;
      });
    } catch (e, strack) {
      log('$e\n$strack');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误：$e\n$strack')));
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
      appBar: AppBar(title: Text('牌子进度')),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(tabs: [Text('Spirit'), Text('Tribute'), Text('Legend')]),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(children: spiritWidgets),
                  ListView(children: tributeWidgets),
                  ListView(children: legendWidgets),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
