import 'dart:developer';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../tools/generateb50.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

class GenerateB50Page extends StatefulWidget {
  const GenerateB50Page({super.key});

  @override
  State<GenerateB50Page> createState() => _GenerateB50PageState();
}

class _GenerateB50PageState extends State<GenerateB50Page> {
  final ScrollController _controller = ScrollController();

  Widget image = Text('未生成或错误');
  int _generationKey = 0;

  void showZoomableImageDialog(BuildContext context, File imageFile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 5.0,
              child: Center(child: Image.file(imageFile)),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> init() async {
    try {
      final path = await getApplicationSupportDirectory();
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
                  '生成时请保证网络畅通，基本所有数据都是在线获取，目前有部分字体缺失，部分歌曲名字显示不全，使用前请配置好落雪token，生成期间程序可能弹出未响应，请点击等待，不要关闭程序，生成之后长按图片可保存，又由于几乎所有都是绘画的，生成比较慢，需要3-5分钟（因个人设备而异',
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          try {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('正在生成')));
                            await generateb50();
                            final path = await getApplicationSupportDirectory();
                            setState(() {
                              _generationKey++;
                              image = Image.memory(
                                File(
                                  '${path.path}/tmp/b50.png',
                                ).readAsBytesSync(),
                                key: ValueKey(_generationKey),
                                errorBuilder: (context, error, stackTrace) =>
                                    Text('未生成或错误'),
                              );
                            });
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('成功')));
                          } catch (e) {
                            log(
                              '$e',
                              name: 'generateb50page.dart',
                              level: 1000,
                            );
                            setState(() {
                              image = Text('生成失败');
                            });
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('生成失败 $e')));
                          }
                        },
                        child: Text('点我生成B50'),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () async {
                    final path = await getApplicationSupportDirectory();
                    if (!context.mounted) return;
                    showZoomableImageDialog(
                      context,
                      File('${path.path}/tmp/b50.png'),
                    );
                  },
                  onLongPress: () async {
                    try {
                      final Directory path =
                          await getApplicationSupportDirectory();
                      final Uint8List dataBytes = await File(
                        '${path.path}/tmp/b50.png',
                      ).readAsBytes();
                      await FilePicker.saveFile(
                        dialogTitle: '保存B50',
                        fileName: 'b50.png',
                        bytes: dataBytes,
                        type: FileType.custom,
                        allowedExtensions: ['png'],
                      );
                    } catch (e) {
                      log('$e', name: 'generateb50page.dart', level: 1000);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('保存失败 $e')));
                    }
                  },
                  child: image,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
