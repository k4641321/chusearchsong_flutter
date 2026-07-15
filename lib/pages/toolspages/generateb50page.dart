import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../tools/generateb50.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';

class GenerateB50Page extends StatefulWidget {
  const GenerateB50Page({super.key});

  @override
  State<GenerateB50Page> createState() => _GenerateB50PageState();
}

class _GenerateB50PageState extends State<GenerateB50Page> {
  final ScrollController _controller = ScrollController();
  final ScrollController _controller2 = ScrollController();

  Widget image = Text('未生成或错误');

  Future<void> init() async {
    try {
      final path = await getApplicationSupportDirectory();
      if (!mounted) return;
      setState(() {
        image = Image.memory(
          File('${path.path}/tmp/b50.png').readAsBytesSync(),
          key: const ValueKey(0),
          errorBuilder: (context, error, stackTrace) => Text('未生成或错误'),
        );
      });
    } catch (e) {
      log('$e', name: 'generateb50page.dart', level: 1000);
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  final GlobalKey _globalKey = GlobalKey();

  Future<ui.Image?> captureWidget(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return await boundary.toImage(pixelRatio: 2.0); // pixelRatio 控制清晰度
  }

  Widget b50Body = Text('未生成');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('B50生成')),
      body: Scrollbar(
        controller: _controller,
        child: SingleChildScrollView(
          controller: _controller,
          child: Center(
            child: Column(
              children: [
                Text(
                  '生成时请保证网络畅通，基本所有数据都是在线获取，使用前请配置好落雪token，没生成好点击保存按钮只会保存一张未生成的文字',
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          setState(() {
                            b50Body = Text('生成中...');
                          });
                          try {
                            Widget result = await generateb50Body(
                              context: context,
                            );
                            setState(() {
                              b50Body = result;
                            });
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('完成')));
                          } catch (e, strack) {
                            log(
                              '$e',
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
                            final byteData = await image?.toByteData(
                              format: .png,
                            );
                            final pngBytes = byteData?.buffer.asUint8List();
                            final path = await getApplicationSupportDirectory();
                            File(
                              '${path.path}/tmp/b50.png',
                            ).writeAsBytesSync(pngBytes!);
                            if (!context.mounted) return;
                            await FilePicker.saveFile(
                              dialogTitle: '保存B50',
                              fileName: 'b50.png',
                              bytes: pngBytes,
                              type: FileType.custom,
                              allowedExtensions: ['png'],
                            );
                          } catch (e) {
                            log(
                              '$e',
                              name: 'generateb50page.dart',
                              level: 1000,
                            );
                          }
                        },
                        child: Text('保存B50'),
                      ),
                    ),
                  ],
                ),
                Scrollbar(
                  controller: _controller2,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: _controller2,
                    child: RepaintBoundary(key: _globalKey, child: b50Body),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
