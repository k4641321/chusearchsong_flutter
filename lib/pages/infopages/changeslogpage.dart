import 'dart:convert';

import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:flutter/material.dart';

class Changeslogpage extends StatefulWidget {
  const Changeslogpage({super.key});

  @override
  State<Changeslogpage> createState() => _ChangeslogpageState();
}

class _ChangeslogpageState extends State<Changeslogpage> {
  Widget body = CircularProgressIndicator();
  List<Widget> changesloglist = [];
  List<Widget> announcementlist = [];

  int show = 0;

  Future<void> init() async {
    try {
      List changeslog = await jsonDecode(await requestChangeslog());
      List announcement = await jsonDecode(await requestAnnouncement());

      for (var i in changeslog) {
        List changes = [];
        for (var j in i['changes']) {
          changes.add(j);
        }
        changesloglist.add(
          Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  Text(
                    '${i['title']}',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text('${i['description']}', style: TextStyle(fontSize: 20)),
                  const Divider(),
                  Text(changes.join('\n')),
                ],
              ),
            ),
          ),
        );
      }
      for (var i in announcement) {
        announcementlist.add(
          Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  Text(
                    '${i['title']}',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const Divider(),
                  Text('${i['date']}', style: TextStyle(fontSize: 20)),
                  const Divider(),
                  InkWell(
                    onLongPress: () =>
                        copytext(text: '${i['content']}', context: context),
                    child: Text(
                      '${i['content']}',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      if (!mounted) return;
      setState(() {
        body = ListView(children: changesloglist);
      });
    } catch (e, strack) {
      if (!mounted) return;
      setState(() {
        body = Text('错误$e\n$strack');
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
      appBar: AppBar(
        title: Text('更新日志与公告'),
        actions: [
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                if (show == 0) {
                  show = 1;
                  body = ListView(children: announcementlist);
                } else {
                  show = 0;
                  body = ListView(children: changesloglist);
                }
              });
            },
          ),
        ],
      ),
      body: Center(child: body),
    );
  }
}
