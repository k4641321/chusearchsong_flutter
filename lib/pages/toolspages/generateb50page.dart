import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';

class GenerateB50Page extends StatefulWidget {
  const GenerateB50Page({super.key});

  @override
  State<GenerateB50Page> createState() => _GenerateB50PageState();
}

class _GenerateB50PageState extends State<GenerateB50Page> {
  Widget image = Text('未生成或错误');

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey _globalKey = GlobalKey();

  Future<ui.Image?> captureWidget(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return await boundary.toImage(pixelRatio: 2.0); // pixelRatio 控制清晰度
  }

  Widget b50Body = Text('未生成');
  String selectedType = 'b50';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('B50生成')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('生成时请保证网络畅通，基本所有数据都是在线获取，使用前请配置好落雪token，没生成好点击保存按钮只会保存一张未生成的文字'),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: buildTypeDropdownMenu(
                  onSelected: (value) {
                    selectedType = value;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      b50Body = Text('生成中...');
                    });
                    try {
                      Widget? result = await selectb50(
                        b50type: selectedType,
                        context: context,
                      );
                      setState(() {
                        if (result != null) {
                          b50Body = result;
                        } else {
                          b50Body = Text('生成失败');
                        }
                      });
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('完成')));
                    } catch (e, strack) {
                      log(
                        '$e\n$strack',
                        name: 'generateb50page.dart',
                        level: 1000,
                      );
                      setState(() {
                        b50Body = Text('生成失败 $e\n$strack');
                      });
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('生成失败')));
                    }
                  },
                  child: Text('点击生成B50'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    try {
                      final image = await captureWidget(_globalKey);
                      final byteData = await image?.toByteData(format: .png);
                      final pngBytes = byteData?.buffer.asUint8List();
                      final path = await getApplicationSupportDirectory();
                      if (!Directory('${path.path}/tmp').existsSync()) {
                        Directory('${path.path}/tmp').create(recursive: true);
                      }
                      File(
                        '${path.path}/tmp/b50.png',
                      ).writeAsBytesSync(pngBytes!);
                      if (!context.mounted) return;
                      final platform = Theme.of(context).platform;
                      if (platform == TargetPlatform.windows) {
                        await FilePicker.saveFile(
                          dialogTitle: '保存B50',
                          fileName: 'b50.png',
                          bytes: pngBytes,
                          type: FileType.custom,
                          allowedExtensions: ['png'],
                        );
                      } else {
                        await SharePlus.instance.share(
                          ShareParams(
                            files: [XFile('${path.path}/tmp/b50.png')],
                          ),
                        );
                      }
                    } catch (e) {
                      log('$e', name: 'generateb50page.dart', level: 1000);
                    }
                  },
                  child: Text('保存B50'),
                ),
              ),
            ],
          ),
          Expanded(
            child: InteractiveViewer(
              minScale: 0.1,
              maxScale: 5,
              constrained: false,
              boundaryMargin: EdgeInsets.all(double.infinity),
              child: RepaintBoundary(key: _globalKey, child: b50Body),
            ),
          ),
        ],
      ),
    );
  }
}
