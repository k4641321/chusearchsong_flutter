import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ChartViewPage extends StatefulWidget {
  final int songid;
  final int diffindex;
  const ChartViewPage({
    super.key,
    required this.songid,
    required this.diffindex,
  });

  @override
  State<ChartViewPage> createState() => _ChartViewPageState();
}

class _ChartViewPageState extends State<ChartViewPage> {
  List<Widget> result = [CircularProgressIndicator()];

  //***字符串，国内都是int，还得多写一个函数
  int returnDiffIndex(String diff) {
    switch (diff) {
      case 'BAS':
        return 0;
      case 'ADV':
        return 1;
      case 'EXP':
        return 2;
      case 'MAS':
        return 3;
      case 'ULT':
        return 4;
      case 'WE':
        return 5;
      default:
        return 0;
    }
  }

  String charturldiff({required int diffindex}) {
    switch (diffindex) {
      case 0:
        return 'bas';
      case 1:
        return 'adv';
      case 2:
        return 'exp';
      case 3:
        return 'mst';
      case 4:
        return 'ult';
      case 5:
        return 'end';
      default:
        return 'bas';
    }
  }

  Future<void> init() async {
    try {
      final path = await getApplicationSupportDirectory();
      String? charturl;

      String zxzrsongsdatastr = await File(
        '${path.path}/res/zxzrsongs.json',
      ).readAsString();
      List zxzrsongsdata = jsonDecode(zxzrsongsdatastr);
      List songchart = [];
      for (var i in zxzrsongsdata) {
        if (i['id'] == widget.songid) {
          songchart = i['charts'];
          break;
        }
      }
      for (var i in songchart) {
        if (widget.diffindex == returnDiffIndex(i['difficulty'])) {
          charturl = i['sdvxin_url'];
          break;
        }
      }
      //开始拆解链接，幸好有规律
      List bgurl;
      List barurl;
      List chartdataurl;
      String baseurl = 'https://sdvx.in/chunithm';
      if (charturl == null) {
        setState(() {
          result = [Text('没有找到谱面')];
          return;
        });
      } else {
        List charturllist = charturl.split('/');
        // print(charturllist);
        bgurl = [
          baseurl,
          charturllist[4],
          'bg',
          '${(charturllist[5] as String).replaceAll(RegExp(r'[^0-9]'), '')}bg.png',
        ];
        barurl = [
          baseurl,
          charturllist[4],
          'bg',
          '${(charturllist[5] as String).replaceAll(RegExp(r'[^0-9]'), '')}bar.png',
        ];
        chartdataurl = [
          baseurl,
          charturllist[4],
          'obj',
          'data${(charturllist[5] as String).replaceAll(RegExp(r'[^0-9]'), '')}${charturldiff(diffindex: widget.diffindex)}.png',
        ];
        setState(() {
          result = [
            Image.network(
              chartdataurl.join('/'),
              errorBuilder: (context, error, stackTrace) =>
                  throw Exception('图片加载失败'),
            ),
            Image.network(
              barurl.join('/'),
              errorBuilder: (context, error, stackTrace) =>
                  throw Exception('图片加载失败'),
            ),
            Opacity(
              opacity: 0.1,
              child: Image.network(
                bgurl.join('/'),
                errorBuilder: (context, error, stackTrace) =>
                    throw Exception('图片加载失败'),
              ),
            ),
          ];
        });
      }
    } catch (e, strack) {
      log('$e \n $strack');
      setState(() {
        result = [Text('错误：$e \n $strack')];
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
      appBar: AppBar(title: Text('谱面预览')),
      body: InteractiveViewer(
        minScale: 1.0,
        maxScale: 5.0,
        child: Center(
          child: SizedBox(
            height: MediaQuery.heightOf(context),
            child: Stack(children: result),
          ),
        ),
      ),
    );
  }
}
