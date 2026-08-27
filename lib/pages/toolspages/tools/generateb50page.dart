import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chusearchsong_flutter/function/list.dart';
import 'package:path_provider/path_provider.dart';
import '../../../function/toolsfun/generateb50fun/generateb50.dart';
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
  Map<String, dynamic> songsData = {};
  Map<String, dynamic> playerdata = {};
  Map<String, dynamic> workingplayerdata = {};
  List allscoredata = [];
  String? genreorversion;
  Map<String, dynamic> b50data = {};
  Map<String, dynamic> workingb50data = {};

  Future<void> init() async {
    //加载曲目信息
    songsData = await loadSongs();
    //加载玩家信息
    playerdata = await loadPlayerData();
    playerdata = playerdata['data'];
    //加载所有成绩
    allscoredata = (await loadAllScoreData())['data'];
    //加载b50数据
    b50data = (await loadb50ScoreData())['data'];
    workingplayerdata = Map.from(b50data);
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
    return await boundary.toImage(pixelRatio: 1.0); // pixelRatio 控制清晰度
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
                    if (selectedType == '流派50') {
                      List<Widget> children = [];

                      for (var i in songsData['genres']) {
                        children.add(
                          ListTile(
                            title: Text(i['genre']),
                            onTap: () {
                              genreorversion = i['genre'];
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }
                      showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: Text('选择流派'),
                          children: children,
                        ),
                      );
                    } else if (selectedType == '版本50') {
                      List<Widget> children = [];

                      for (var i in songsData['versions']) {
                        String title = i['title'];
                        if (i['title'] != 'CHUNITHM') {
                          title = (i['title'] as String).replaceAll(
                            'CHUNITHM',
                            '',
                          );
                        }
                        children.add(
                          ListTile(
                            title: Text(title),
                            onTap: () {
                              genreorversion = i['version'].toString();
                              Navigator.of(context).pop();
                            },
                          ),
                        );
                      }
                      showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          title: Text('选择版本'),
                          children: children,
                        ),
                      );
                    } else if (selectedType == '谱师50') {
                      Set<String> designers = {};

                      for (var i in songsData['songs']) {
                        for (var j in i['difficulties']) {
                          designers.add(j['note_designer']);
                        }
                      }
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => NoteDesignerOrArtist(
                          fun: (value) {
                            genreorversion = value;
                            Navigator.of(context).pop();
                          },
                          notedesignerorartist: designers,
                        ),
                      );
                    } else if (selectedType == '曲师50') {
                      Set<String> artist = {};

                      for (var i in songsData['songs']) {
                        artist.add(i['artist']);
                      }
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => NoteDesignerOrArtist(
                          fun: (value) {
                            genreorversion = value;
                            Navigator.of(context).pop();
                          },
                          notedesignerorartist: artist,
                        ),
                      );
                    }
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
                    if ((selectedType == '流派50' || selectedType == '版本50') &&
                        genreorversion == null) {
                      return;
                    }
                    setState(() {
                      b50Body = Text('生成中...');
                    });
                    try {
                      workingb50data = json.decode(json.encode(b50data));
                      workingplayerdata = json.decode(json.encode(playerdata));
                      Widget? result = await selectb50(
                        b50type: selectedType,
                        context: context,
                        songsData: songsData,
                        playerdata: workingplayerdata,
                        allscoredata: allscoredata,
                        genre: genreorversion,
                        b50data: workingb50data,
                      );
                      setState(() {
                        if (result != null) {
                          b50Body = result;
                        } else {
                          b50Body = Text('生成失败，可能没结果');
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
                        '${path.path}/tmp/b50.png',
                      ).writeAsBytesSync(pngBytes!);
                      if (!context.mounted) return;
                      // final platform = Theme.of(context).platform;
                      // if (platform == TargetPlatform.windows ||
                      //     platform == TargetPlatform.linux) {
                      await FilePicker.saveFile(
                        dialogTitle: '保存B50',
                        fileName: 'b50.png',
                        bytes: pngBytes,
                        type: FileType.custom,
                        allowedExtensions: ['png'],
                      );
                      // } else {
                      //   await SharePlus.instance.share(
                      //     ShareParams(
                      //       files: [XFile('${path.path}/tmp/b50.png')],
                      //     ),
                      //   );
                      // }
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
