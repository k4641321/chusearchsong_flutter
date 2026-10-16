import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:chusearchsong_flutter/function/songinfofun/songshareviewpagefun.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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
                        if (kIsWeb) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('网页不支持分享')));
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (context) => SizedBox(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          ),
                        );
                        final image = await captureWidget(_globalKey);
                        if (image == null) return;
                        final byteData = await image.toByteData(
                          format: ui.ImageByteFormat.rawStraightRgba,
                        );
                        if (byteData == null) return;

                        final decoded = img.Image.fromBytes(
                          width: image.width,
                          height: image.height,
                          bytes: byteData.buffer,
                          numChannels: 4,
                        );

                        Map<String, dynamic> config =
                            await (await ReadData.create()).readConfig();
                        late Uint8List? imageBytes;
                        switch (config['generatesettings']?['preferredformat']) {
                          case '.jpg':
                            imageBytes = img.encodeJpg(decoded, quality: 100);
                          case ".png":
                            imageBytes = img.encodePng(decoded);
                          case ".webp":
                            imageBytes = img.encodeWebP(decoded, quality: 100);
                          default:
                            imageBytes = img.encodePng(decoded);
                        }

                        // final path = await getApplicationSupportDirectory();
                        // if (!Directory('${path.path}/tmp').existsSync()) {
                        //   Directory('${path.path}/tmp').create(recursive: true);
                        // }
                        // File(
                        //   '${path.path}/tmp/songinfoandscore.png',
                        // ).writeAsBytesSync(pngBytes!);
                        if (!context.mounted) return;

                        await FilePicker.saveFile(
                          dialogTitle: '保存单曲信息与成绩',
                          fileName:
                              'songinfoandscore${config['generatesettings']?['preferredformat'] ?? '.png'}',
                          bytes: imageBytes,
                          type: FileType.custom,
                          allowedExtensions: [
                            '${config['generatesettings']?['preferredformat'] ?? '.png'}',
                          ],
                        );
                        if (!context.mounted) return;
                        Navigator.pop(context);
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
                    width: 2000,
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
