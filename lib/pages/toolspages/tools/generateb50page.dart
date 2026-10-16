import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../../../function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';

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
  bool _generates10 = false;
  String _thunderboltb50 = '关';
  double _pixelRatio = 1.0;
  List versionlist = [];

  Future<void> init() async {
    try {
      //加载曲目信息
      songsData = SongDataStore.instance.songsData;
      //加载玩家信息
      playerdata = SongDataStore.instance.playerInfoData;
      if (playerdata.isEmpty) {
        setState(() {
          b50Body = Text('玩家信息为空，请检查是否配置好落雪Token');
        });
        return;
      }
      //加载所有成绩
      allscoredata = SongDataStore.instance.playerAllScore;
      //加载b50数据
      b50data = SongDataStore.instance.playerB50Data;
      // print(b50data);
      workingplayerdata = Map.from(b50data);
    } catch (e, strack) {
      log('$e\n$strack');
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
    return await boundary.toImage(pixelRatio: _pixelRatio);
  }

  Widget b50Body = Text('未生成');
  String selectedType = 'b50';
  int? n50 = 0;
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
                    } else if (selectedType == 'BN') {
                      final controller = TextEditingController();
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('输入数量'),
                          content: TextField(controller: controller),
                          actions: [
                            TextButton(
                              onPressed: () {
                                n50 = int.tryParse(controller.text);
                                Navigator.of(context).pop();
                              },
                              child: Text('确定'),
                            ),
                          ],
                        ),
                      );
                    } else if (selectedType == '版本区间50') {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => StatefulBuilder(
                          builder: (dialogContext, setDialogState) {
                            return AlertDialog(
                              title: Text('选择版本区间'),
                              content: SizedBox(
                                width: double.maxFinite,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: [
                                    for (var i in songsData['versions'])
                                      CheckboxListTile(
                                        title: Text(
                                          i['title'] == 'CHUNITHM'
                                              ? i['title']
                                              : (i['title'] as String)
                                                    .replaceAll('CHUNITHM', ''),
                                        ),
                                        value: versionlist.contains(
                                          i['version'].toString(),
                                        ),
                                        onChanged: (checked) {
                                          setDialogState(() {
                                            final v = i['version'].toString();
                                            if (checked == true) {
                                              versionlist.add(v);
                                            } else {
                                              versionlist.remove(v);
                                            }
                                          });
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(),
                                  child: Text('确定'),
                                ),
                              ],
                            );
                          },
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
                  onPressed: () {
                    setState(() {
                      _generates10 = !_generates10;
                    });
                  },
                  child: Text('带S10生成：$_generates10'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        children: [
                          ListTile(
                            title: Text('关'),
                            onTap: () {
                              _thunderboltb50 = '关';
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('横着的'),
                            onTap: () {
                              _thunderboltb50 = '横着的';
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            title: Text('竖着的'),
                            onTap: () {
                              _thunderboltb50 = '竖着的';
                              Navigator.of(context).pop();
                            },
                          ),
                          // ListTile(
                          //   title: Text('空着的'),
                          //   onTap: () {
                          //     _thunderboltb50 = '空着的';
                          //     Navigator.of(context).pop();
                          //   },
                          // ),
                        ],
                      ),
                    );
                    setState(() {});
                  },
                  child: Text('雷霆50：$_thunderboltb50'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    Map<String, dynamic> b50history =
                        await (await ReadData.create()).readB50History();
                    List<Widget> list = [];
                    for (var i in b50history.keys.toList()) {
                      list.add(
                        ListTile(
                          title: Text(i),
                          onTap: () {
                            b50data = b50history[i];
                            Navigator.of(context).pop();
                          },
                          onLongPress: () async {
                            bool isConfirmed = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('是否删除'),
                                actions: [
                                  TextButton(
                                    child: Text('取消'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  TextButton(
                                    child: Text('确定'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                            );

                            if (isConfirmed) {
                              b50history.remove(i);
                              await (await WriteData.create()).writeB50History(
                                b50history,
                              );
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      );
                    }
                    if (list.isEmpty) {
                      list.add(ListTile(title: Text('无历史数据')));
                    }
                    if (!context.mounted) return;
                    showDialog(
                      context: context,
                      builder: (context) =>
                          SimpleDialog(title: Text('选择历史50'), children: list),
                    );
                  },
                  child: Text('加载历史50'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    String name = DateTime.now().toString();
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('输入名字'),
                        content: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: name,
                                onChanged: (value) => name = value,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            child: Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('确定'),
                            onPressed: () async {
                              Map<String, dynamic> b50history =
                                  await (await ReadData.create())
                                      .readB50History();
                              // if (b50history.isEmpty) {
                              //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('获取数据失败')));
                              // }
                              b50history[name] = b50data;
                              await (await WriteData.create()).writeB50History(
                                b50history,
                              );
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text('保存50'),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text('清晰度：'),
              Expanded(
                child: TextFormField(
                  initialValue: _pixelRatio.toString(),
                  onChanged: (value) =>
                      _pixelRatio = double.tryParse(value) ?? 1.0,
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
                        generateS10: _generates10,
                        b50data: workingb50data,
                        n50: n50,
                        thunderboltb50: _thunderboltb50,
                        versionList: versionlist,
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
                        b50Body = Text('生成失败，请检查是否配置好落雪Token\n $e\n$strack');
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
                        dialogTitle: '保存50',
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
                    } catch (e, s) {
                      log('$e', name: 'generateb50page.dart', level: 1000);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('错误：$e\n$s')));
                      Navigator.pop(context);
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
              child: RepaintBoundary(
                key: _globalKey,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textTheme: Theme.of(context).textTheme.apply(
                      fontFamily: 'AlibabaPuHuiTi',
                    ), // 或自定义 fontFamily
                  ),
                  child: b50Body,
                ),
              ),
              // b50Body,
            ),
          ),
        ],
      ),
    );
  }
}
