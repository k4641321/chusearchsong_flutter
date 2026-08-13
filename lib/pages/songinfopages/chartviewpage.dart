import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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
      if (!mounted) return;
      String? charturl;
      Map<String, dynamic> config = jsonDecode(
        File('${path.path}/config.json').readAsStringSync(),
      );
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
        if (config['chartproxy'] == true) {
          final stopwatch = Stopwatch()..start();
          log('使用vercel');
          Map<String, dynamic> chartproxyresult = jsonDecode(
            await requestproxychartdata(
              charturl: charturl,
              levelindex: widget.diffindex,
            ),
          );
          // print(chartproxyresult);
          setState(() {
            result = [
              Image.memory(
                base64Decode(chartproxyresult['bg']),
                fit: BoxFit.none,
                errorBuilder: (context, error, stackTrace) => Text(
                  '错误：$error \n $stackTrace',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Image.memory(
                base64Decode(chartproxyresult['bar']),
                fit: BoxFit.none,
                errorBuilder: (context, error, stackTrace) => Text(
                  '错误：$error \n $stackTrace',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Image.memory(
                base64Decode(chartproxyresult['chart_data']),
                fit: BoxFit.none,
                errorBuilder: (context, error, stackTrace) => Text(
                  '错误：$error \n $stackTrace',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ];
          });
          stopwatch.stop();
          log('耗时: ${stopwatch.elapsedMilliseconds}ms');
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('耗时: ${stopwatch.elapsedMilliseconds}ms')),
          );
        } else {
          log('使用默认');

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
            // final stopwatch = Stopwatch()..start();
            result = [
              CachedNetworkImage(
                imageUrl: bgurl.join('/'),
                // height: MediaQuery.heightOf(context),
                fit: BoxFit.none,
                errorWidget: (context, error, stackTrace) => Text(
                  '错误：$error \n $stackTrace',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              CachedNetworkImage(
                imageUrl: barurl.join('/'),
                // height: MediaQuery.heightOf(context),
                fit: BoxFit.none,
                errorWidget: (context, error, stackTrace) => Text(
                  '错误：$error \n $stackTrace',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              CachedNetworkImage(
                imageUrl: chartdataurl.join('/'),
                // height: MediaQuery.heightOf(context),
                fit: BoxFit.none,
                errorWidget: (context, error, stackTrace) => Text(
                  '错误：$error \n $stackTrace',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ];
            // stopwatch.stop();
            // log('耗时: ${stopwatch.elapsedMilliseconds}ms');
            // if (!mounted) return;
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('耗时: ${stopwatch.elapsedMilliseconds}ms')),
            // );
          });
        }
      }
    } catch (e, strack) {
      log('$e \n $strack');
      if (!mounted) return;
      setState(() {
        result = [
          Text('错误：$e \n $strack', style: TextStyle(color: Colors.white)),
        ];
      });
    }
  }

  Future<ui.Image?> captureWidget(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return await boundary.toImage(pixelRatio: 1.0); // pixelRatio 控制清晰度
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

  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('谱面预览'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              try {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('正在生成，请不要重复点击')));
                final image = await captureWidget(_globalKey);
                final byteData = await image?.toByteData(format: .png);
                final pngBytes = byteData?.buffer.asUint8List();
                final path = await getApplicationSupportDirectory();
                if (!Directory('${path.path}/tmp').existsSync()) {
                  Directory('${path.path}/tmp').create(recursive: true);
                }
                File('${path.path}/tmp/chart.png').writeAsBytesSync(pngBytes!);
                if (!context.mounted) return;
                final platform = Theme.of(context).platform;
                if (platform == TargetPlatform.windows ||
                    platform == TargetPlatform.linux) {
                  await FilePicker.saveFile(
                    dialogTitle: '保存谱面',
                    fileName: 'chart.png',
                    bytes: pngBytes,
                    type: FileType.custom,
                    allowedExtensions: ['png'],
                  );
                } else {
                  await SharePlus.instance.share(
                    ShareParams(files: [XFile('${path.path}/tmp/chart.png')]),
                  );
                }
              } catch (e) {
                log('$e', name: 'generateb50page.dart', level: 1000);
              }
            },
          ),
        ],
      ),
      body: InteractiveViewer(
        constrained: false,
        minScale: 0.1,
        maxScale: 5.0,
        boundaryMargin: EdgeInsets.all(double.infinity),
        child: Center(
          child: RepaintBoundary(
            key: _globalKey,
            child: Card(
              margin: EdgeInsets.all(0),
              elevation: 0,
              shape: const RoundedRectangleBorder(),
              color: Colors.black,
              child: Stack(children: result),
            ),
          ),
        ),
      ),
    );
  }
}
