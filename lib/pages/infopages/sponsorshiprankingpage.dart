import 'dart:convert';

import 'package:chusearchsong_flutter/function/request.dart';
import 'package:flutter/material.dart';

class Sponsorshiprankingpage extends StatefulWidget {
  const Sponsorshiprankingpage({super.key});

  @override
  State<Sponsorshiprankingpage> createState() => _SponsorshiprankingpageState();
}

class _SponsorshiprankingpageState extends State<Sponsorshiprankingpage> {
  List<Widget> list = [CircularProgressIndicator()];

  Future<void> init() async {
    try {
      List result = jsonDecode(await requestSponsorshipRanking());
      result.sort((a, b) => b['value'].compareTo(a['value']));
      List<Widget> list2 = [];
      for (var i in result) {
        list2.add(
          Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text('名称：${i['name']}\n金额：${i['value']}'),
            ),
          ),
        );
      }
      setState(() {
        list = list2;
      });
    } catch (e, strack) {
      setState(() {
        list = [Text('错误$e\n$strack')];
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
      appBar: AppBar(title: Text('赞助排行榜')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => list[index],
              itemCount: list.length,
            ),
          ),
        ],
      ),
    );
  }
}
