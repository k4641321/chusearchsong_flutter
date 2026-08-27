import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:chusearchsong_flutter/function/songinfofun/songshareviewpagefun.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class Songshareviewpage extends StatefulWidget {
  final int songid;

  const Songshareviewpage({super.key, required this.songid});

  @override
  State<Songshareviewpage> createState() => _SongshareviewpageState();
}

class _SongshareviewpageState extends State<Songshareviewpage> {
  Widget children = CircularProgressIndicator();

  Future<void> loadWidget() async {
    try {
      Widget result = await returnSongShareView(songid: widget.songid);
      setState(() {
        children = result;
      });
    } catch (e, strack) {
      log('$e \n $strack');
      setState(() {
        children = Text(
          '错误 $e \n $strack',
          style: TextStyle(color: Colors.black, fontSize: 30),
        );
      });
    }
  }

  final GlobalKey _globalKey = GlobalKey();

  Future<ui.Image?> captureWidget(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return await boundary.toImage(pixelRatio: 2.0); // pixelRatio 控制清晰度
  }

  @override
  void initState() {
    super.initState();
    loadWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('预览')),
      body: Center(
        child: Column(
          children: [
            Text('所有资源通过网络获取，请所有资源加载完再点击分享'),
            Row(
              children: [
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
                          '${path.path}/tmp/songinfoandscore.png',
                        ).writeAsBytesSync(pngBytes!);
                        if (!context.mounted) return;
                        // final platform = Theme.of(context).platform;
                        // if (platform == TargetPlatform.windows ||
                        //     platform == TargetPlatform.linux) {
                        await FilePicker.saveFile(
                          dialogTitle: '保存单曲信息与成绩',
                          fileName: 'songinfoandscore.png',
                          bytes: pngBytes,
                          type: FileType.custom,
                          allowedExtensions: ['png'],
                        );
                        // } else {
                        //   await SharePlus.instance.share(
                        //     ShareParams(
                        //       files: [
                        //         XFile('${path.path}/tmp/songinfoandscore.png'),
                        //       ],
                        //     ),
                        //   );
                        // }
                      } catch (e) {
                        log('$e', name: 'songshareviewpage.dart', level: 1000);
                      }
                    },
                    child: Text('分享'),
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: InteractiveViewer(
                constrained: false,
                minScale: 0.1,
                maxScale: 3.0,
                boundaryMargin: EdgeInsets.all(double.infinity),
                child: RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    height: 1080,
                    width: 1920,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('res/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
