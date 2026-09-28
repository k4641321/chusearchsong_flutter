import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:developer';
import '../pages/songinfopages/songinfopage.dart';
import 'songinfofun/songinfopagefun.dart';
import 'package:flutter/services.dart';
import 'toolsfun/generateb50fun/generateb50.dart';
import 'package:async/async.dart';

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
    if (!(await SharedPreferences.getInstance()).containsKey('Config')) {
      try {
        Map<String, dynamic> config = {
          "theme": "light",
          "init": false,
          "favoriteFileUpdated": true,
          "autocheckupdate": true,
          "announcement": {"date": '0000-01-01', "read": false, "value": 0},
          "chartproxy": false,
          "changeslogread": false,
        };
        await (await WriteData.create()).writeConfig(config);
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
        log('$e', name: 'main', level: 2000);
      }
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
    if (!(await SharedPreferences.getInstance()).containsKey('FavoriteSongs')) {
      try {
        await (await WriteData.create()).writeFavoriteSongs({"favorite": []});
        onProgress('完成');
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
    }

    // finally {
    //   if (context.mounted) {
    //     Navigator.of(context).pop();
    //   }
    // }

    try {
      Map<String, dynamic> config = await (await ReadData.create())
          .readConfig();
      if (config['init'] == true) {
        // if (!context.mounted) return;
        // Navigator.of(context).pop();
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('SongsData') |
          !prefs.containsKey('PlatesData') |
          !prefs.containsKey('IconsData') |
          !prefs.containsKey('TrophiesData') |
          !prefs.containsKey('CharactersData') |
          !prefs.containsKey('AliasData') |
          !prefs.containsKey('WahlapLobbyData') |
          !prefs.containsKey('LatestVersion')) {
        onProgress('下载必要资源');
        // showtext.value = '下载必要资源';

        // 下载歌曲数据
        // showtext.value = '下载必要数据';
        await Future.wait([
          (await WriteData.create()).writeSongsData(),
          (await WriteData.create()).writePlateData(),
          (await WriteData.create()).writeIconsData(),
          (await WriteData.create()).writeTrophiesData(),
          (await WriteData.create()).writeCharactersData(),
          (await WriteData.create()).writeAliasData(),
          (await WriteData.create()).writeWahlapLobbyData(),
          (await WriteData.create()).writeLatestVersion(),
        ]);
        // showtext.value = '完成';
        onProgress('完成');
      }

      config['init'] = true;
      await (await WriteData.create()).writeConfig(config);
      // if (context.mounted) {
      //   Navigator.of(context).pop();
      // }
      if (!context.mounted) return;
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text.rich(
              TextSpan(
                text: '给 我 去 读 帮 助 文 档！\n',
                children: [
                  TextSpan(
                    text: '初次启动，将下载数据，并创建必要文件\n推荐前往关于界面阅读使用文档了解隐藏操作',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  lanucharbitrary(
                    context: context,
                    url:
                        'https://blog.devintom.top/chusearchsong_flutter/helper/',
                  );
                  Navigator.of(context).pop();
                },
                child: Text('确定'),
              ),
            ],
          );
        },
      );
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
          (await WriteData.create()).writeAliasData(),
          (await WriteData.create()).writeCharactersData(),
          (await WriteData.create()).writeIconsData(),
          (await WriteData.create()).writeLatestVersion(),
          (await WriteData.create()).writeLinkedVerseData(),
          (await WriteData.create()).writeNearcadeAllShopAndNearcadeGames(),
          (await WriteData.create()).writePlateData(),
          (await WriteData.create()).writePlayerAllScoreData(),
          (await WriteData.create()).writePlayerB50Data(),
          (await WriteData.create()).writePlayerInfoData(),
          (await WriteData.create()).writePlayerRatingTrendData(),
          (await WriteData.create()).writeSegaCharaData(),
          (await WriteData.create()).writeSongsData(),
          (await WriteData.create()).writeTrophiesData(),
          (await WriteData.create()).writeWahlapLobbyData(),
          (await WriteData.create()).writezxzrSongsData(),
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
        //获取成绩
        showtext.value = '更新成绩';
        await (await WriteData.create()).writePlayerAllScoreData();
        showtext.value = '完成';
        //Rating趋势
        showtext.value = '更新Rating趋势';
        await (await WriteData.create()).writePlayerRatingTrendData();
        showtext.value = '完成';
        //玩家信息
        showtext.value = '更新玩家信息';
        await (await WriteData.create()).writePlayerInfoData();
        showtext.value = '完成';
        //B50
        showtext.value = '更新B50';
        await (await WriteData.create()).writePlayerB50Data();
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
      showtext.value = '更新机厅数据';
      operation = CancelableOperation.fromFuture(
        Future.wait([
          (await WriteData.create()).writeNearcadeAllShopAndNearcadeGames(),
        ]),
      );
      await operation.value;
      showtext.value = '完成';
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
          (await WriteData.create()).writeTrophiesData(),
          (await WriteData.create()).writePlateData(),
          (await WriteData.create()).writeIconsData(),
          (await WriteData.create()).writeCharactersData(),
          (await WriteData.create()).writeAliasData(),
          (await WriteData.create()).writeSongsData(),
          (await WriteData.create()).writeLatestVersion(),
          (await WriteData.create()).writeLinkedVerseData(),
          (await WriteData.create()).writeWahlapLobbyData(),
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
      log('$e\$$strack', name: 'infopage.dart', level: 2000);
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
      //下载最新最热资源
      showtext.value = '更新最新最热资源';
      operation = CancelableOperation.fromFuture(
        Future.wait([(await WriteData.create()).writezxzrSongsData()]),
      );
      await operation.value;
      showtext.value = '完成';
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

//歌曲卡片
Widget returnSongCard({
  required Map<String, dynamic> songbasedata,
  required Map<String, dynamic> songsData,
  required BuildContext context,
  VoidCallback? onReturn,
  Map<int, dynamic>? searchinfo,
}) {
  int originid = songbasedata['id'];
  String versionname = '';
  for (var i in songsData['versions']) {
    if (i['version'] == songbasedata['version']) {
      versionname = i['title'];
    }
  }
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
        songsData: songsData,
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

//进入歌曲详情页
Future<void> interSongInfo({
  required Map<String, dynamic> songbasedata,
  required Map<String, dynamic> songsData,
  required BuildContext context,
}) async {
  // List<DataRow> songData = [];
  // List<Widget> songData = [];
  String versionname = '';
  for (var i in songsData['versions']) {
    if (i['version'] == songbasedata['version']) {
      versionname = i['title'];
    }
  }

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

void copytext({required String text, required BuildContext context}) {
  try {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('复制成功')));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('复制失败')));
  }
}

Future<void> lanucharbitrary({
  required BuildContext context,
  required String url,
}) async {
  final githuburl = Uri.parse(url);
  try {
    if (!await launchUrl(githuburl)) {
      if (!context.mounted) return;
      throw Exception('Could not launch $githuburl');
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('无法打开链接')));
  }
}

Future<void> updateconfig() async {
  Map<String, dynamic> config = await (await ReadData.create()).readConfig();
  final packageinfo = await PackageInfo.fromPlatform();
  //地图配置
  if (!config.containsKey('map')) config['map'] = 'amap';
  //初始化
  if (!config.containsKey('init')) config['init'] = true;
  //谱面加速
  if (!config.containsKey('chartproxy')) config['chartproxy'] = false;
  //更新日志
  if (!config.containsKey('changeslogread')) config['changeslogread'] = false;
  //版本号
  if (packageinfo.version != config['version']) {
    config['changeslogread'] = false;
  }
  config['version'] = packageinfo.version;
  //公告
  if (!config.containsKey('announcement')) {
    config['announcement'] = {};
    config['announcement']['date'] = '0000-01-01';
    config['announcement']['read'] = false;
    config['announcement']['value'] = 0;
  }
  //收藏列表
  if (!config.containsKey('favoriteFileUpdated')) {
    if (!kIsWeb) {
      final path = await getApplicationSupportDirectory();
      Map<String, dynamic> favorite = await jsonDecode(
        await File('${path.path}/files/favorite.json').readAsString(),
      );
      await (await WriteData.create()).writeFavoriteSongs(favorite);
    }
    config['favoriteFileUpdated'] = true;
  }

  await (await WriteData.create()).writeConfig(config);
}
