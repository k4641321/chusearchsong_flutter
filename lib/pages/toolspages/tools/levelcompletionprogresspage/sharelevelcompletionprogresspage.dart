import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:chusearchsong_flutter/function/toolsfun/levelcompletionprogresspagefun/sharelevelcompletionprogresspagefun.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class Sharelevelcompletionprogresspage extends StatefulWidget {
  final List level;
  final Map<String, dynamic> songsdata;
  final Map<String, dynamic> allScoreData;

  const Sharelevelcompletionprogresspage({
    super.key,
    required this.level,
    required this.allScoreData,
    required this.songsdata,
  });

  @override
  State<Sharelevelcompletionprogresspage> createState() =>
      _SharelevelcompletionprogresspageState();
}

class _SharelevelcompletionprogresspageState
    extends State<Sharelevelcompletionprogresspage> {
  final GlobalKey _globalKey = GlobalKey();
  Widget result = Text('未生成');

  Future<ui.Image?> captureWidget(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return await boundary.toImage(pixelRatio: 1.0); // pixelRatio 控制清晰度
  }

  @override
  void dispose() {
    if (!mounted) return;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('分享等级完成进度')),
      body: Column(
        children: [
          Text('生成时请保证网络通常，资源都来源于网络'),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    try {
                      Widget result2 =
                          await returnShareLevelCompletionProgressPageFun(
                            level: widget.level,
                            songsdata: widget.songsdata,
                            allScoreData: widget.allScoreData,
                            context: context,
                          );
                      if (!mounted) return;
                      setState(() {
                        result = result2;
                      });
                    } catch (e, strack) {
                      log('$e\n$strack');
                      if (!mounted) return;
                      setState(() {
                        result = Text('错误：$e\n$strack');
                      });
                    }
                  },
                  child: Text('生成'),
                ),
              ),
              Expanded(
                child: TextButton(
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
                      File(
                        '${path.path}/tmp/level.png',
                      ).writeAsBytesSync(pngBytes!);
                      if (!context.mounted) return;
                      final platform = Theme.of(context).platform;
                      if (platform == TargetPlatform.windows ||
                          platform == TargetPlatform.linux) {
                        await FilePicker.saveFile(
                          dialogTitle: '保存等级表',
                          fileName: 'level.png',
                          bytes: pngBytes,
                          type: FileType.custom,
                          allowedExtensions: ['png'],
                        );
                      } else {
                        await SharePlus.instance.share(
                          ShareParams(
                            files: [XFile('${path.path}/tmp/level.png')],
                          ),
                        );
                      }
                    } catch (e) {
                      log('$e', name: 'generateb50page.dart', level: 1000);
                    }
                  },
                  child: Text('分享'),
                ),
              ),
            ],
          ),
          Expanded(
            child: InteractiveViewer(
              maxScale: 5.0,
              minScale: 0.1,
              constrained: false,
              boundaryMargin: EdgeInsets.all(double.infinity),
              child: RepaintBoundary(key: _globalKey, child: result),
            ),
          ),
        ],
      ),
    );
  }
}
