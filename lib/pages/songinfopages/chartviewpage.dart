import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
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
  final ScrollController _scrollController = ScrollController();

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
      if (!mounted) return;
      String? charturl;

      String zxzrsongsdatastr = await File(
        '${path.path}/res/zxzrsongs.json',
      ).readAsString();
      if (!mounted) return;
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
        if (!mounted) return;
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
        if (!mounted) return;
        setState(() {
          result = [
            CachedNetworkImage(
              imageUrl: chartdataurl.join('/'),
              // height: MediaQuery.heightOf(context),
              fit: BoxFit.none,
              errorWidget: (context, error, stackTrace) =>
                  Text('错误：$error \n $stackTrace'),
            ),
            CachedNetworkImage(
              imageUrl: barurl.join('/'),
              // height: MediaQuery.heightOf(context),
              fit: BoxFit.none,
              errorWidget: (context, error, stackTrace) =>
                  Text('错误：$error \n $stackTrace'),
            ),
            Opacity(
              opacity: 0.1,
              child: CachedNetworkImage(
                imageUrl: bgurl.join('/'),
                // height: MediaQuery.heightOf(context),
                fit: BoxFit.none,
                errorWidget: (context, error, stackTrace) =>
                    Text('错误：$error \n $stackTrace'),
              ),
            ),
          ];
          // result = [
          //   Image.network(
          //     chartdataurl.join('/'),
          //     height: MediaQuery.heightOf(context),
          //     fit: BoxFit.fill,
          //     errorBuilder: (context, error, stackTrace) =>
          //         Text('错误：$error \n $stackTrace'),
          //   ),
          // ];
        });
      }
    } catch (e, strack) {
      log('$e \n $strack');
      if (!mounted) return;
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('谱面预览')),
      body: InteractiveViewer(
        constrained: false,
        minScale: 0.5,
        maxScale: 5.0,
        boundaryMargin: EdgeInsets.all(double.infinity),
        child: Center(child: Stack(children: result)),
      ),
    );
  }
}
