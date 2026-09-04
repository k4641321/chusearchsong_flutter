import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'request.dart';
import 'dart:developer';
import '../pages/songinfopages/songinfopage.dart';
import 'dart:math' as math;
import 'songinfofun/songinfopagefun.dart';
import 'package:flutter/services.dart';
import 'infopagefun/settingspagefun.dart';
import 'toolsfun/generateb50fun/generateb50.dart';
import 'package:async/async.dart';

//Rating趋势
Future<List> returnscoretrendlist() async {
  final path = await getApplicationSupportDirectory();
  String scoretrendJsonStr = await File(
    '${path.path}/res/trend.json',
  ).readAsString();
  Map<String, dynamic> scoretrendJson = json.decode(scoretrendJsonStr);
  return scoretrendJson['data'];
}

//返回歌曲id列表
Future<List<int>> returnidList() async {
  List<int> idList = [];
  Directory songDataPath = await getApplicationSupportDirectory();
  String jsonString = await File(
    '${songDataPath.path}/res/songs.json',
  ).readAsString();
  Map<String, dynamic> songData = json.decode(jsonString);
  for (var i in songData['songs']) {
    idList.add(i['id']);
  }
  return idList;
}

//随机歌曲
Future<List<Widget>> randomSong({
  required BuildContext context,
  required int count,
}) async {
  try {
    Directory songDataPath = await getApplicationSupportDirectory();
    String jsonString = await File(
      '${songDataPath.path}/res/songs.json',
    ).readAsString();
    Map<String, dynamic> songData = json.decode(jsonString);

    List<int> idList = await returnidList();
    List<Widget> songWidgets = [];
    final random = math.Random();
    List<int> resultIds = [];
    for (var i = 0; i < count; i++) {
      final randomId = random.nextInt(idList.length);
      resultIds.add(idList[randomId]);
    }
    // final randomId = random.nextInt(idList.length);
    // final selectId = idList[randomId];

    // 查找选中的歌曲
    List selectedSong = [];
    for (var i in songData['songs']) {
      for (var j in resultIds) {
        if (i['id'] == j) {
          selectedSong.add(i);
        }
      }
    }

    // 查找版本名称
    String versionname = '';
    for (var i in selectedSong) {
      for (var j in songData['versions']) {
        if (j['version'] == i['version']) {
          versionname = j['title'];
          songWidgets.add(
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    key: ValueKey(i['id']),
                    onTap: () async {
                      interSongInfo(
                        songbasedata: i!,
                        context: context,
                        versionname: versionname,
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${i['id']} - ${i['title']}      ${i['genre']} - $versionname',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      }
    }
    return songWidgets;
  } catch (e) {
    if (!context.mounted) return [Text('无结果')];
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('错误: $e')));
    log('error $e', name: 'fun.dart', level: 1000);
    return [Text('无结果')];
  }
}

//进入歌曲详情页
Future<void> interSongInfo({
  required Map<String, dynamic> songbasedata,
  required BuildContext context,
  required String versionname,
}) async {
  // List<DataRow> songData = [];
  // List<Widget> songData = [];
  List<Widget> information = [];
  final difficulties = (songbasedata['difficulties'] as List?) ?? [];
  final lastWithOrigin = difficulties.lastWhere(
    (d) => d is Map && d.containsKey('origin_id'),
    orElse: () => null,
  );
  int songid = lastWithOrigin?['origin_id'] ?? songbasedata['id'];

  if (information.isEmpty) {
    information.add(Text('无信息', style: const TextStyle(fontSize: 15)));
  }
  information.insert(
    0,
    (Row(children: [Icon(Icons.info_outline), Text('其余信息')])),
  );

  //别名加载
  if (!context.mounted) return;
  List<Widget> alias = await returnAlias(
    id: songbasedata['id'],
    context: context,
    color: Theme.of(context).colorScheme.primary,
  );
  if (!context.mounted) return;
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SongInfoPage(
        songbasedata: songbasedata,
        versionname: versionname,
        originid: songid,
        // information: information,
        alias: alias,
      ),
    ),
  );
  // log('未完成 ${i['id']}');
}

class Dataupdate {
  //初次启动调用的函数
  static Future<void> ifres({
    required BuildContext context,
    required void Function(String text) onProgress,
  }) async {
    // final showtext = ValueNotifier<String>('初始化');
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Text('初始化'),
    //     content: Row(
    //       children: [
    //         CircularProgressIndicator(),
    //         ValueListenableBuilder<String>(
    //           valueListenable: showtext,
    //           builder: (context, value, child) => Text(value),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    onProgress('初始化...');

    //配置文件
    try {
      final directory = await getApplicationSupportDirectory();
      if (!File('${directory.path}/config.json').existsSync()) {
        if (!context.mounted) return;
        onProgress('开始创建配置文件');
        // showtext.value = '开始创建配置文件';
        File('${directory.path}/config.json').createSync();
        Map<String, dynamic> config = {
          "theme": "light",
          "init": false,
          "favoriteFileUpdated": true,
          "autocheckupdate": true,
        };
        File(
          '${directory.path}/config.json',
        ).writeAsStringSync(jsonEncode(config));
        // showtext.value = '完成';
        onProgress('完成');
      }
    } catch (e, strack) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('错误： $e\n$strack'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e', name: 'main', level: 2000);
    }
    // finally {
    //   if (context.mounted) {
    //     Navigator.of(context).pop();
    //   }
    // }

    //配置更新
    try {
      onProgress('更新配置');
      // showtext.value = '更新配置';
      await updateconfig();
      // showtext.value = '完成';
      onProgress('完成');
    } catch (e, strack) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('错误： $e\n$strack'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e\n$strack', name: 'fun.dart', level: 2000);
    }
    // finally {
    //   if (context.mounted) {
    //     Navigator.of(context).pop();
    //   }
    // }

    //收藏文件
    try {
      final directory = await getApplicationSupportDirectory();
      final path = Directory('${directory.path}/files');
      if (!path.existsSync()) {
        path.createSync(recursive: true);
      }
      if (!context.mounted) return;

      if (!File('${path.path}/favorite.json').existsSync()) {
        onProgress('创建收藏文件');
        // showtext.value = '创建收藏文件';
        File('${path.path}/favorite.json').createSync();
        File(
          '${path.path}/favorite.json',
        ).writeAsStringSync(jsonEncode({'favorite': []}));
        // showtext.value = '完成';
        onProgress('完成');
      }
    } catch (e, strack) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('创建失败 $e\n$strack'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e', name: 'main', level: 2000);
    }
    // finally {
    //   if (context.mounted) {
    //     Navigator.of(context).pop();
    //   }
    // }

    try {
      final directory = await getApplicationSupportDirectory();
      Map<String, dynamic> config = await jsonDecode(
        File('${directory.path}/config.json').readAsStringSync(),
      );
      final path = Directory('${directory.path}/res');
      if (!path.existsSync()) {
        path.createSync(recursive: true);
      }
      if (config['init'] == true) {
        // if (!context.mounted) return;
        // Navigator.of(context).pop();
        return;
      }
      if (!File('${path.path}/songs.json').existsSync() |
          !File('${path.path}/alias.json').existsSync() |
          !File('${path.path}/location.json').existsSync() |
          !File('${path.path}/characters.json').existsSync() |
          !File('${path.path}/icons.json').existsSync() |
          !File('${path.path}/plates.json').existsSync() |
          !File('${path.path}/trophies.json').existsSync() |
          !File('${path.path}/zxzrsongs.json').existsSync() |
          !File('${path.path}/segachara.json').existsSync()) {
        onProgress('下载必要资源');
        // showtext.value = '下载必要资源';
        if (!context.mounted) return;
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: Text('提示'),
        //       content: Text('初次启动，将下载数据，并创建必要文件\n推荐前往关于界面阅读使用文档了解隐藏操作'),
        //       actions: [
        //         TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: Text('确定'),
        //         ),
        //       ],
        //     );
        //   },
        // );
        // 下载歌曲数据
        // showtext.value = '下载必要数据';
        await Future.wait([
          saveTrophiesData(),
          savePlatesData(),
          saveIconsData(),
          saveCharactersData(),
          saveLobbyData(),
          saveAliasData(),
          saveSongdata(),
          // savezxzrsongs(),
          saveSegaCharaData(),
          saveLatestVersion(),
          saveLinkedVerseData(),
        ]);
        // showtext.value = '完成';
        onProgress('完成');
      }

      config['init'] = true;
      File(
        '${directory.path}/config.json',
      ).writeAsStringSync(jsonEncode(config));
      print(directory);
      // if (context.mounted) {
      //   Navigator.of(context).pop();
      // }
    } catch (e, strack) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('下载失败，请检查网络$e,\n$strack'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e', name: 'main', level: 2000);
    }
    // finally {
    //   if (context.mounted) {
    //     Navigator.of(context).pop();
    //   }
    // }
  }

  //更新数据
  static Future<void> updateAllData({required BuildContext context}) async {
    try {
      final showtext = ValueNotifier<String>('更新数据');
      CancelableOperation<void>? operation;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('更新数据'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              ValueListenableBuilder<String>(
                valueListenable: showtext,
                builder: (context, value, child) => Text(value),
              ),
            ],
          ),
        ),
      ).then((_) {
        operation?.cancel();
      });
      operation = CancelableOperation.fromFuture(
        Future.wait([
          saveTrophiesData(),
          savePlatesData(),
          saveIconsData(),
          saveCharactersData(),
          saveLobbyData(),
          saveAliasData(),
          saveSongdata(),
          savezxzrsongs(),
          saveSegaCharaData(),
          saveLatestVersion(),
          saveNearcadeAllShop(),
          saveB50(),
          savePlayerInfo(),
          saveTrend(),
          saveAllScore(),
          saveLinkedVerseData(),
        ]),
        onCancel: () {
          log('更新全部数据被取消');
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('取消')));
        },
      );
      await operation.value;
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('下载失败，请检查网络'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e', name: 'infopage.dart', level: 2000);
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop(); // 无论成功/失败都只关一次
      }
    }
  }

  static Future<void> updateScore({required BuildContext context}) async {
    try {
      final showtext = ValueNotifier<String>('更新数据');
      Future<void> update() async {
        final directory = await getApplicationSupportDirectory();

        final path = Directory('${directory.path}/res');
        //获取成绩
        showtext.value = '更新成绩';
        await saveAllScore();
        showtext.value = '完成';
        log('保存到 ${path.path}/allscore.json');
        //Rating趋势
        showtext.value = '更新Rating趋势';
        await saveTrend();
        showtext.value = '完成';
        log('保存到 ${path.path}/trend.json');
        //玩家信息
        showtext.value = '更新玩家信息';
        await savePlayerInfo();
        showtext.value = '完成';
        log('保存到 ${path.path}/playerinfo.json');
        //B50
        showtext.value = '更新B50';
        await saveB50();
        showtext.value = '完成';
      }

      CancelableOperation<void>? operation;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('更新数据'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              ValueListenableBuilder<String>(
                valueListenable: showtext,
                builder: (context, value, child) => Text(value),
              ),
            ],
          ),
        ),
      ).then((_) {
        operation?.cancel();
      });
      operation = CancelableOperation.fromFuture(Future.wait([update()]));
      await operation.value;
    } catch (e, strack) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('下载失败，请检查网络 $e\n$strack'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e', name: 'infopage.dart', level: 2000);
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop(); // 无论成功/失败都只关一次
      }
    }
  }

  static Future<void> updateNearcadeShopData({
    required BuildContext context,
  }) async {
    try {
      final showtext = ValueNotifier<String>('更新数据');
      CancelableOperation<void>? operation;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('更新数据'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              ValueListenableBuilder<String>(
                valueListenable: showtext,
                builder: (context, value, child) => Text(value),
              ),
            ],
          ),
        ),
      ).then((_) {
        operation?.cancel();
      });
      final directory = await getApplicationSupportDirectory();
      final path = Directory('${directory.path}/res');
      showtext.value = '更新机厅数据';
      operation = CancelableOperation.fromFuture(
        Future.wait([saveNearcadeAllShop()]),
      );
      await operation.value;
      showtext.value = '完成';
      log('保存到 ${path.path}/nearcadeshops.json');
    } catch (e, strack) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('下载失败，请检查网络 $e\n$strack'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e', name: 'infopage.dart', level: 2000);
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  static Future<void> updateBaseData({required BuildContext context}) async {
    try {
      final showtext = ValueNotifier<String>('更新数据');
      CancelableOperation<void>? operation;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('更新数据'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              ValueListenableBuilder<String>(
                valueListenable: showtext,
                builder: (context, value, child) => Text(value),
              ),
            ],
          ),
        ),
      ).then((_) {
        operation?.cancel();
      });
      operation = CancelableOperation.fromFuture(
        Future.wait([
          saveTrophiesData(),
          savePlatesData(),
          saveIconsData(),
          saveCharactersData(),
          saveLobbyData(),
          saveAliasData(),
          saveSongdata(),
          saveLatestVersion(),
          saveLinkedVerseData(),
        ]),
      );
      await operation.value;
    } catch (e, strack) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('下载失败，请检查网络 $e\n$strack'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e', name: 'infopage.dart', level: 2000);
    } finally {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  static Future<void> updatezxzrsongsData({
    required BuildContext context,
  }) async {
    try {
      final showtext = ValueNotifier<String>('更新数据');
      CancelableOperation<void>? operation;
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text('更新数据'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              ValueListenableBuilder<String>(
                valueListenable: showtext,
                builder: (context, value, child) => Text(value),
              ),
            ],
          ),
        ),
      );

      final directory = await getApplicationSupportDirectory();

      final path = Directory('${directory.path}/res');
      //下载最新最热资源
      showtext.value = '更新最新最热资源';
      operation = CancelableOperation.fromFuture(
        Future.wait([savezxzrsongs()]),
      );
      await operation.value;
      showtext.value = '完成';
      log('保存到 ${path.path}/zxzrsongs.json');
    } catch (e, strack) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('下载失败，请检查网络 $e\n$strack'),
          // duration: Duration(microseconds: 500),
        ),
      );
      log('$e\n$strack', name: 'infopage.dart', level: 2000);
    }
    if (!context.mounted) return;
    Navigator.of(context).pop();
  }
}

void copytext({required String text, required BuildContext context}) {
  try {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('复制成功')));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('复制失败')));
  }
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

Future<Map<String, dynamic>> returnplayerinfodata() async {
  final path = await getApplicationSupportDirectory();
  String scoretrendJsonStr = await File(
    '${path.path}/res/playerinfo.json',
  ).readAsString();
  Map<String, dynamic> scoretrendJson = json.decode(scoretrendJsonStr);
  return scoretrendJson['data'];
}

Future<Map<String, dynamic>> loadConfig() async {
  final path = await getApplicationSupportDirectory();

  String configJsonStr = await File('${path.path}/config.json').readAsString();
  Map<String, dynamic> configJson = json.decode(configJsonStr);
  return configJson;
}

Future<void> saveConfig(Map<String, dynamic> config) async {
  final path = await getApplicationSupportDirectory();
  String configJsonStr = json.encode(config);
  await File('${path.path}/config.json').writeAsString(configJsonStr);
}

Widget returnSongCard({
  required Map<String, dynamic> songbasedata,
  required String versionname,
  required BuildContext context,
  VoidCallback? onReturn,
  Map<int, dynamic>? searchinfo,
}) {
  int originid = songbasedata['id'];
  //难度组件
  List<Widget> songInfoDiffs = [];
  if (((songbasedata['difficulties'] as List).last as Map).containsKey(
    'origin_id',
  )) {
    originid = songbasedata['difficulties'].last['origin_id'];
  }

  for (var k in songbasedata['difficulties']) {
    songInfoDiffs.add(
      Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(5)),
        ),
        color: diffcolor(diffindex: k['difficulty']),
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            left: 8,
            right: 8,
            top: 3,
            bottom: 3,
          ),

          child: Text(
            k['level_value'].toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  //搜索结果组件
  Widget searchinfoWidget = SizedBox.shrink();
  if (searchinfo != null &&
      searchinfo.keys.toList().contains(songbasedata['id'])) {
    String searchinfostr = '';
    if ((searchinfo[songbasedata['id']] as Map).containsKey('BPM')) {
      searchinfostr =
          '$searchinfostr BPM:${(searchinfo[songbasedata['id']] as Map)['BPM']}';
    }
    if ((searchinfo[songbasedata['id']] as Map).containsKey('alias')) {
      searchinfostr =
          '$searchinfostr 别名:${(searchinfo[songbasedata['id']] as Map)['alias']}';
    }
    if ((searchinfo[songbasedata['id']] as Map).containsKey('note_designer')) {
      searchinfostr =
          '$searchinfostr 谱师:${(searchinfo[songbasedata['id']] as Map)['note_designer']}';
    }
    if ((searchinfo[songbasedata['id']] as Map).containsKey('notecounts')) {
      for (var l
          in ((searchinfo[songbasedata['id']] as Map)['notecounts'] as Map).keys
              .toList()) {
        searchinfostr =
            '$searchinfostr $l:${searchinfo[songbasedata['id']]['notecounts'][l]}';
      }
    }
    searchinfoWidget = Text(
      searchinfostr,
      style: TextStyle(color: Colors.grey),
    );
  }
  return InkWell(
    // key: ValueKey(songItem['id']),
    onTap: () async {
      await interSongInfo(
        songbasedata: songbasedata,
        context: context,
        versionname: versionname,
      );
      onReturn?.call();
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: EdgeInsetsGeometry.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(right: 10),
              child: CachedNetworkImage(
                imageUrl:
                    'https://assets2.lxns.net/chunithm/jacket/$originid.png',
                width: 105,
                height: 105,
                errorWidget: (context, url, error) => Text('加载失败'),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Text(
                        '#${songbasedata['id']}',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${songbasedata['title']}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${songbasedata['artist']}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${songbasedata['genre']} - $versionname',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Wrap(children: songInfoDiffs),
                  searchinfoWidget,
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Future<Map<String, dynamic>> loadFavoriteSong() async {
  final path = await getApplicationSupportDirectory();

  String configJsonStr = await File(
    '${path.path}/files/favorite.json',
  ).readAsString();
  Map<String, dynamic> configJson = json.decode(configJsonStr);
  return configJson;
}

Future<void> saveFavoriteSong(Map<String, dynamic> favoriteSongs) async {
  final path = await getApplicationSupportDirectory();

  await File(
    '${path.path}/files/favorite.json',
  ).writeAsString(jsonEncode(favoriteSongs));
}

Future<Map<String, dynamic>> loadLinkedVerseData() async {
  final path = await getApplicationSupportDirectory();

  String configJsonStr = await File(
    '${path.path}/res/linkedversedata.json',
  ).readAsString();
  Map<String, dynamic> configJson = json.decode(configJsonStr);
  return configJson;
}
