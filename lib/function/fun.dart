import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'request.dart';
import 'dart:developer';
import '../pages/songinfopages/songinfopage.dart';
import 'dart:math' as math;
import 'songinfofun/songinfopagefun.dart';
import 'package:flutter/services.dart';
import 'settingspagefun.dart';

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

//初次启动调用的函数
Future<void> ifres({required BuildContext context}) async {
  //配置文件
  try {
    final directory = await getApplicationSupportDirectory();
    if (!File('${directory.path}/config.json').existsSync()) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始创建配置文件'),
          duration: Duration(microseconds: 500),
        ),
      );
      File('${directory.path}/config.json').createSync();
      Map<String, dynamic> config = {"theme": "light", "init": false};
      File(
        '${directory.path}/config.json',
      ).writeAsStringSync(jsonEncode(config));
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('创建失败'), duration: Duration(microseconds: 500)),
    );
    log('$e', name: 'main', level: 2000);
  }

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
      return;
    }
    if (!File('${path.path}/songs.json').existsSync() |
        !File('${path.path}/alias.json').existsSync() |
        !File('${path.path}/location.json').existsSync() |
        !File('${path.path}/characters.json').existsSync() |
        !File('${path.path}/icons.json').existsSync() |
        !File('${path.path}/plates.json').existsSync() |
        !File('${path.path}/trophies.json').existsSync() |
        !File('${path.path}/zxzrsongs.json').existsSync()) {
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('初次启动，将下载数据，并创建必要文件'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('确定'),
              ),
            ],
          );
        },
      );
      // 下载歌曲数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始下载歌曲基本数据'),
          duration: Duration(microseconds: 500),
        ),
      );
      await File('${path.path}/songs.json').create();
      await File(
        '${path.path}/songs.json',
      ).writeAsString(await requestSongData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
      log('保存到 ${path.path}/songs.json');
      // 下载歌曲别名数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始下载歌曲别名数据'),
          duration: Duration(microseconds: 500),
        ),
      );
      await File('${path.path}/alias.json').create();
      await File(
        '${path.path}/alias.json',
      ).writeAsString(await requestAliasData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
      log('保存到 ${path.path}/alias.json');
      // 下载机厅数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始下载机厅数据'),
          duration: Duration(microseconds: 500),
        ),
      );
      await File('${path.path}/location.json').create();
      await File(
        '${path.path}/location.json',
      ).writeAsString(await requestLobbyData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
      log('保存到 ${path.path}/location.json');
      // 下载角色数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始下载角色数据'),
          duration: Duration(microseconds: 500),
        ),
      );
      await File('${path.path}/characters.json').create();
      await File(
        '${path.path}/characters.json',
      ).writeAsString(await requestCharactersData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
      log('保存到 ${path.path}/characters.json');
      // 下载头像数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始下载头像数据'),
          duration: Duration(microseconds: 500),
        ),
      );
      await File('${path.path}/icons.json').create();
      await File(
        '${path.path}/icons.json',
      ).writeAsString(await requestIconsData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
      log('保存到 ${path.path}/icons.json');
      // 下载名牌版数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始下载名牌版数据'),
          duration: Duration(microseconds: 500),
        ),
      );
      await File('${path.path}/plates.json').create();
      await File(
        '${path.path}/plates.json',
      ).writeAsString(await requestPlatesData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
      log('保存到 ${path.path}/plates.json');
      //下载称号数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始下载称号数据'),
          duration: Duration(microseconds: 500),
        ),
      );
      await File('${path.path}/trophies.json').create();
      await File(
        '${path.path}/trophies.json',
      ).writeAsString(await requestTrophiesData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
      log('保存到 ${path.path}/trophies.json');
      //下载最新最热资源
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始下载谱面数据'),
          duration: Duration(microseconds: 500),
        ),
      );
      await savezxzrsongs();
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
      log('保存到 ${path.path}/zxzrsongs.json');
    }
    //更新配置文件
    config['init'] = true;
    File('${directory.path}/config.json').writeAsStringSync(jsonEncode(config));
    print(directory);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('下载失败，请检查网络'),
        duration: Duration(microseconds: 500),
      ),
    );
    log('$e', name: 'main', level: 2000);
  }

  //收藏文件
  try {
    final directory = await getApplicationSupportDirectory();
    final path = Directory('${directory.path}/files');
    if (!path.existsSync()) {
      path.createSync(recursive: true);
    }
    if (!context.mounted) return;

    if (!File('${path.path}/favorite.json').existsSync()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('开始创建收藏文件'),
          duration: Duration(microseconds: 500),
        ),
      );
      File('${path.path}/favorite.json').createSync();
      File('${path.path}/favorite.json').writeAsStringSync('[]');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('创建失败'), duration: Duration(microseconds: 500)),
    );
    log('$e', name: 'main', level: 2000);
  }

  //配置更新
  try {
    await updateconfig();
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('配置更新失败'), duration: Duration(microseconds: 500)),
    );
    log('$e', name: 'fun.dart', level: 2000);
  }
}

//更新数据
Future<void> updateData({required BuildContext context}) async {
  try {
    final directory = await getApplicationSupportDirectory();

    final path = Directory('${directory.path}/res');
    if (!context.mounted) return;
    // 下载歌曲数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载歌曲基本数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await File('${path.path}/songs.json').create();
    await File(
      '${path.path}/songs.json',
    ).writeAsString(await requestSongData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/songs.json');
    // 下载歌曲别名数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载歌曲别名数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await File('${path.path}/alias.json').create();
    await File(
      '${path.path}/alias.json',
    ).writeAsString(await requestAliasData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/alias.json');
    // 下载机厅数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载机厅数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await File('${path.path}/location.json').create();
    await File(
      '${path.path}/location.json',
    ).writeAsString(await requestLobbyData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/location.json');
    // 下载角色数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载角色数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await File('${path.path}/characters.json').create();
    await File(
      '${path.path}/characters.json',
    ).writeAsString(await requestCharactersData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/characters.json');
    // 下载头像数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载头像数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await File('${path.path}/icons.json').create();
    await File(
      '${path.path}/icons.json',
    ).writeAsString(await requestIconsData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/icons.json');
    // 下载名牌版数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载名牌版数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await File('${path.path}/plates.json').create();
    await File(
      '${path.path}/plates.json',
    ).writeAsString(await requestPlatesData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/plates.json');
    //下载称号数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载称号数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await File('${path.path}/trophies.json').create();
    await File(
      '${path.path}/trophies.json',
    ).writeAsString(await requestTrophiesData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/trophies.json');
    //获取成绩
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载成绩数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await saveAllScore();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/allscore.json');
    //Rating趋势
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载Rating趋势数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await saveTrend();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/trend.json');
    //玩家信息
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载玩家信息'),
        duration: Duration(microseconds: 500),
      ),
    );
    await savePlayerInfo();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/playerinfo.json');
    //B50
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载B50'), duration: Duration(microseconds: 500)),
    );
    await saveB50();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/b50.json');
    print(directory);
    //获取最新版本
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载最新版本号'),
        duration: Duration(microseconds: 500),
      ),
    );
    await saveLatestVersion();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${directory.path}/config.json');
    print(directory);
    //下载最新最热资源
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('开始下载谱面数据'),
        duration: Duration(microseconds: 500),
      ),
    );
    await savezxzrsongs();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(microseconds: 500)),
    );
    log('保存到 ${path.path}/zxzrsongs.json');
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('下载失败，请检查网络'),
        duration: Duration(microseconds: 500),
      ),
    );
    log('$e', name: 'main', level: 2000);
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
