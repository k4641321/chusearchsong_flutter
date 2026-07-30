import 'dart:convert';

import 'package:chusearchsong_flutter/function/request.dart';
import 'package:flutter/material.dart';

class Changeslogpage extends StatefulWidget {
  const Changeslogpage({super.key});

  @override
  State<Changeslogpage> createState() => _ChangeslogpageState();
}

class _ChangeslogpageState extends State<Changeslogpage> {
  Widget body = CircularProgressIndicator();

  Future<void> init() async {
    try {
      List changeslog = await jsonDecode(await requestChangeslog());
      List<Widget> resultlist = [];
      for (var i in changeslog) {
        List changes = [];
        for (var j in i['changes']) {
          changes.add(j);
        }
        resultlist.add(
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
      setState(() {
        body = ListView(children: resultlist);
      });
    } catch (e, strack) {
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
      appBar: AppBar(title: Text('更新日志')),
      body: Center(child: body),
    );
  }
}
