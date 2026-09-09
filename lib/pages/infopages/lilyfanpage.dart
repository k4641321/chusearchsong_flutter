import 'dart:convert';

import 'package:chusearchsong_flutter/function/request.dart';
import 'package:flutter/material.dart';

class Lilyfanpage extends StatefulWidget {
  const Lilyfanpage({super.key});

  @override
  State<Lilyfanpage> createState() => _LilyfanpageState();
}

class _LilyfanpageState extends State<Lilyfanpage> {
  String lilyfan = '';

  Future<void> init() async {
    List result = jsonDecode(await requestLilyFan());
    List lilyfan1 = [];
    for (var i in result) {
      lilyfan1.add(i['character']);
    }
    setState(() {
      lilyfan = lilyfan1.join('\n').toString();
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
      appBar: AppBar(title: Text('制作人员？')),
      body: ListView(
        children: [
          Row(
            children: [
              Text(
                '主要作者：',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            'DevinTom、k4641321',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
          const Divider(),
          Row(
            children: [
              Text(
                '次要??：',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            lilyfan,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }
}
