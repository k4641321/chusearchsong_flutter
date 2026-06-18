import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../../tools/generateb50.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

//此部分经过ai优化过性能，避免了生成时程序直接卡死，原先的代码由自己编写，会卡死）

/// 顶层函数：在独立 isolate 中运行生成，**不与任何 widget tree 作用域关联**，
/// 避免闭包捕获 Flutter 框架内部不可发送对象。
Future<void> _runGenerateInIsolate({
  required String token,
  required String supportPath,
  required Uint8List fontZipBytes,
  required Uint8List backgroundBytes,
  required Map<String, Uint8List> rankImages,
  required Map<String, Uint8List> completeImages,
  required SendPort sendPort,
}) {
  return Isolate.run(
    () => generateb50InIsolate({
      'token': token,
      'supportPath': supportPath,
      'fontZipBytes': fontZipBytes,
      'backgroundBytes': backgroundBytes,
      'rankImages': rankImages,
      'completeImages': completeImages,
      'sendPort': sendPort,
    }),
  );
}

class GenerateB50Page extends StatefulWidget {
  const GenerateB50Page({super.key});

  @override
  State<GenerateB50Page> createState() => _GenerateB50PageState();
}

class _GenerateB50PageState extends State<GenerateB50Page> {
  final ScrollController _controller = ScrollController();

  Widget image = Text('未生成或错误');
  int _generationKey = 0;
  bool _isGenerating = false;

  /// 预加载所有需要在 isolate 中使用的资源。
  /// 这些资源必须在主 isolate 加载（rootBundle 在 isolate 中不可用）。
  Future<Map<String, Uint8List>> _loadAssetsForIsolate() async {
    // 并行加载所有资源
    final results = await Future.wait([
      // 字体
      rootBundle.load('res/fnt/font.zip'),
      // 背景
      rootBundle.load('res/background.png'),
      // rank 图片
      rootBundle.load('res/rank/sssp.png'),
      rootBundle.load('res/rank/sss.png'),
      rootBundle.load('res/rank/ssp.png'),
      rootBundle.load('res/rank/ss.png'),
      rootBundle.load('res/rank/sp.png'),
      rootBundle.load('res/rank/s.png'),
      rootBundle.load('res/rank/aaa.png'),
      rootBundle.load('res/rank/aa.png'),
      rootBundle.load('res/rank/a.png'),
      rootBundle.load('res/rank/bbb.png'),
      rootBundle.load('res/rank/bb.png'),
      rootBundle.load('res/rank/b.png'),
      rootBundle.load('res/rank/c.png'),
      rootBundle.load('res/rank/d.png'),
      // complete 图片
      rootBundle.load('res/complete/catastrophy.png'),
      rootBundle.load('res/complete/absolute.png'),
      rootBundle.load('res/complete/brave.png'),
      rootBundle.load('res/complete/hard.png'),
      rootBundle.load('res/complete/clear.png'),
      rootBundle.load('res/complete/failed.png'),
      rootBundle.load('res/complete/alljusticecritical.png'),
      rootBundle.load('res/complete/alljustice.png'),
      rootBundle.load('res/complete/fullcombo.png'),
    ]);

    final rankKeys = [
      'sssp',
      'sss',
      'ssp',
      'ss',
      'sp',
      's',
      'aaa',
      'aa',
      'a',
      'bbb',
      'bb',
      'b',
      'c',
      'd',
    ];
    final completeKeys = [
      'catastrophy',
      'absolute',
      'brave',
      'hard',
      'clear',
      'failed',
      'alljusticecritical',
      'alljustice',
      'fullcombo',
    ];

    final Map<String, Uint8List> rankImages = {};
    for (int i = 0; i < rankKeys.length; i++) {
      rankImages[rankKeys[i]] = results[2 + i].buffer.asUint8List();
    }

    final Map<String, Uint8List> completeImages = {};
    for (int i = 0; i < completeKeys.length; i++) {
      completeImages[completeKeys[i]] = results[2 + rankKeys.length + i].buffer
          .asUint8List();
    }

    return {
      'fontZipBytes': results[0].buffer.asUint8List(),
      'backgroundBytes': results[1].buffer.asUint8List(),
      ...rankImages.map((k, v) => MapEntry('rank/$k', v)),
      ...completeImages.map((k, v) => MapEntry('complete/$k', v)),
    };
  }

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
      if (!Directory('${path.path}/tmp').existsSync()) {
        Directory('${path.path}/tmp').createSync(recursive: true);
      }
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
                  '生成时请保证网络畅通，基本所有数据都是在线获取，目前有部分字体缺失，部分歌曲名字显示不全，使用前请配置好落雪token。生成之后长按图片可保存，由于几乎所有都是绘画的，生成比较慢，需要3-5分钟（因个人设备而异）。生成在后台进行，UI 不会卡顿。',
                ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isGenerating
                            ? null
                            : () async {
                                try {
                                  setState(() => _isGenerating = true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('正在生成，请稍候…')),
                                  );

                                  // 1) 在主 isolate 预加载所有 rootBundle 资源
                                  final assets = await _loadAssetsForIsolate();

                                  // 2) 获取路径和 token
                                  final path =
                                      await getApplicationSupportDirectory();
                                  final configStr = File(
                                    '${path.path}/config.json',
                                  ).readAsStringSync();
                                  final Map<String, dynamic> config =
                                      jsonDecode(configStr);
                                  final String token = config['lxns']['token'];

                                  // 构建 rank/complate 专用映射
                                  final rankKeys = [
                                    'sssp',
                                    'sss',
                                    'ssp',
                                    'ss',
                                    'sp',
                                    's',
                                    'aaa',
                                    'aa',
                                    'a',
                                    'bbb',
                                    'bb',
                                    'b',
                                    'c',
                                    'd',
                                  ];
                                  final completeKeys = [
                                    'catastrophy',
                                    'absolute',
                                    'brave',
                                    'hard',
                                    'clear',
                                    'failed',
                                    'alljusticecritical',
                                    'alljustice',
                                    'fullcombo',
                                  ];
                                  final Map<String, Uint8List> rankImages = {};
                                  for (final k in rankKeys) {
                                    rankImages[k] = assets['rank/$k']!;
                                  }
                                  final Map<String, Uint8List> completeImages =
                                      {};
                                  for (final k in completeKeys) {
                                    completeImages[k] = assets['complete/$k']!;
                                  }

                                  // 3) 在后台 isolate 中执行耗时生成，并通过 SendPort 接收进度
                                  final receivePort = ReceivePort();
                                  final lastProgress = <String>[''];
                                  receivePort.listen((msg) {
                                    final text = msg.toString();
                                    // 避免重复弹出相同进度的 SnackBar
                                    if (text != lastProgress[0] && mounted) {
                                      lastProgress[0] = text;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).clearSnackBars();
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(text),
                                          duration: const Duration(
                                            milliseconds: 600,
                                          ),
                                        ),
                                      );
                                    }
                                  });

                                  // SendPort 可跨 isolate 传递，ReceivePort 不行，需提前提取
                                  final sendPort = receivePort.sendPort;

                                  await _runGenerateInIsolate(
                                    token: token,
                                    supportPath: path.path,
                                    fontZipBytes: assets['fontZipBytes']!,
                                    backgroundBytes: assets['backgroundBytes']!,
                                    rankImages: rankImages,
                                    completeImages: completeImages,
                                    sendPort: sendPort,
                                  );

                                  receivePort.close();

                                  // 4) 更新 UI
                                  setState(() {
                                    _generationKey++;
                                    image = Image.memory(
                                      File(
                                        '${path.path}/tmp/b50.png',
                                      ).readAsBytesSync(),
                                      key: ValueKey(_generationKey),
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Text('未生成或错误'),
                                    );
                                    _isGenerating = false;
                                  });
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('生成成功')),
                                  );
                                } catch (e) {
                                  log(
                                    '$e',
                                    name: 'generateb50page.dart',
                                    level: 1000,
                                  );
                                  setState(() {
                                    image = const Text('生成失败');
                                    _isGenerating = false;
                                  });
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('生成失败 $e')),
                                  );
                                }
                              },
                        child: _isGenerating
                            ? const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('生成中…'),
                                ],
                              )
                            : const Text('点我生成B50'),
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
