import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import './request.dart';
import 'dart:developer';
import '../pages/songinfopage.dart';
import 'dart:math' as math;
import '../pages/toolspages/collectibleinfopage.dart';
import './songinfopagefun.dart';
import 'package:flutter/services.dart';

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
                        i: i!,
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
  required Map<String, dynamic> i,
  required BuildContext context,
  required String versionname,
}) async {
  // List<DataRow> songData = [];
  List<Widget> songData = [];
  Map<String, dynamic> songInfo = {};
  List<dynamic> songInfoDiffs = [];
  //获取谱面信息与成绩
  try {
    // songData = await returnSongInfo(i['id']);
    songData = await returnDiffTabBarView(
      song: i,
      color: Theme.of(context).colorScheme.onSecondary,
      context: context,
    );
  } catch (e) {
    log('error $e', name: 'fun.dart', level: 1000);
  }

  try {
    songInfo = await getSongInfo(i['id']);
    songInfoDiffs = songInfo['difficulties'];
  } catch (e) {
    log('error $e', name: 'fun.dart', level: 1000);
  }

  List<Widget> information = [];
  int songid = i['id'];
  if (songInfo.isNotEmpty) {
    if (songInfo.keys.contains('map')) {
      information.add(
        Text('地图: ${songInfo['map']}', style: const TextStyle(fontSize: 15)),
      );
    }
    if (songInfo.keys.contains('locked')) {
      if (songInfo['locked'] == true) {
        information.add(Text('需解锁', style: const TextStyle(fontSize: 15)));
      } else {
        information.add(Text('无需解锁', style: const TextStyle(fontSize: 15)));
      }
    }
    if (songInfo.keys.contains('rights')) {
      information.add(
        Text('版权: ${songInfo['rights']}', style: const TextStyle(fontSize: 15)),
      );
    }
  } else {
    information.add(Text('请求失败', style: const TextStyle(fontSize: 15)));
  }

  if (songInfoDiffs.isNotEmpty) {
    final kanji = songInfoDiffs.lastWhere(
      (d) => d.keys.contains('kanji'),
      orElse: () => null,
    );
    if (kanji != null) {
      final kanjiText = kanji['kanji'];
      information.add(
        Text('谱面属性: $kanjiText', style: const TextStyle(fontSize: 15)),
      );
    }

    final star = songInfoDiffs.lastWhere(
      (d) => d.keys.contains('star'),
      orElse: () => null,
    );
    if (star != null) {
      final starValue = star['star'];
      information.add(
        Text('星数: $starValue', style: const TextStyle(fontSize: 15)),
      );
    }
    final originid = songInfoDiffs.lastWhere(
      (d) => d.keys.contains('origin_id'),
      orElse: () => null,
    );
    if (originid != null) {
      songid = originid['origin_id'];
    }
  }

  if (information.isEmpty) {
    information.add(Text('无信息', style: const TextStyle(fontSize: 15)));
  }
  information.insert(
    0,
    (Row(children: [Icon(Icons.info_outline), Text('其余信息')])),
  );

  //别名加载
  if (!context.mounted) return;
  List<Widget> alias = await returnAlias(id: i['id'], context: context);
  if (!context.mounted) return;
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SongInfoPage(
        song: i,
        versionname: versionname,
        rowsData: songData,
        information: information,
        alias: alias,
        songid: songid,
      ),
    ),
  );
  // log('未完成 ${i['id']}');
}

//初次启动调用的函数
Future<void> ifres({required BuildContext context}) async {
  try {
    final directory = await getApplicationSupportDirectory();

    final path = Directory('${directory.path}/res');
    if (!path.existsSync()) {
      path.createSync(recursive: true);
    }
    if (!File('${path.path}/songs.json').existsSync() |
        !File('${path.path}/alias.json').existsSync() |
        !File('${path.path}/location.json').existsSync() |
        !File('${path.path}/characters.json').existsSync() |
        !File('${path.path}/icons.json').existsSync() |
        !File('${path.path}/plates.json').existsSync() |
        !File('${path.path}/trophies.json').existsSync()) {
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
        SnackBar(content: Text('开始下载歌曲基本数据'), duration: Duration(seconds: 1)),
      );
      await File('${path.path}/songs.json').create();
      await File(
        '${path.path}/songs.json',
      ).writeAsString(await requestSongData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
      );
      log('保存到 ${path.path}/songs.json');
      // 下载歌曲别名数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('开始下载歌曲别名数据'), duration: Duration(seconds: 1)),
      );
      await File('${path.path}/alias.json').create();
      await File(
        '${path.path}/alias.json',
      ).writeAsString(await requestAliasData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
      );
      log('保存到 ${path.path}/alias.json');
      // 下载机厅数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('开始下载机厅数据'), duration: Duration(seconds: 1)),
      );
      await File('${path.path}/location.json').create();
      await File(
        '${path.path}/location.json',
      ).writeAsString(await requestLobbyData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
      );
      log('保存到 ${path.path}/location.json');
      // 下载角色数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('开始下载角色数据'), duration: Duration(seconds: 1)),
      );
      await File('${path.path}/characters.json').create();
      await File(
        '${path.path}/characters.json',
      ).writeAsString(await requestCharactersData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
      );
      log('保存到 ${path.path}/characters.json');
      // 下载头像数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('开始下载头像数据'), duration: Duration(seconds: 1)),
      );
      await File('${path.path}/icons.json').create();
      await File(
        '${path.path}/icons.json',
      ).writeAsString(await requestIconsData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
      );
      log('保存到 ${path.path}/icons.json');
      // 下载名牌版数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('开始下载名牌版数据'), duration: Duration(seconds: 1)),
      );
      await File('${path.path}/plates.json').create();
      await File(
        '${path.path}/plates.json',
      ).writeAsString(await requestPlatesData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
      );
      log('保存到 ${path.path}/plates.json');
      //下载称号数据
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('开始下载称号数据'), duration: Duration(seconds: 1)),
      );
      await File('${path.path}/trophies.json').create();
      await File(
        '${path.path}/trophies.json',
      ).writeAsString(await requestTrophiesData());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
      );
      log('保存到 ${path.path}/trophies.json');
    }
    print(directory);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('下载失败，请检查网络'), duration: Duration(seconds: 1)),
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
        SnackBar(content: Text('开始创建收藏文件'), duration: Duration(seconds: 1)),
      );
      File('${path.path}/favorite.json').createSync();
      File('${path.path}/favorite.json').writeAsStringSync('[]');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
      );
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('创建失败'), duration: Duration(seconds: 1)),
    );
    log('$e', name: 'main', level: 2000);
  }

  //配置文件
  try {
    final directory = await getApplicationSupportDirectory();
    if (!File('${directory.path}/config.json').existsSync()) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('开始创建配置文件'), duration: Duration(seconds: 1)),
      );
      File('${directory.path}/config.json').createSync();
      File(
        '${directory.path}/config.json',
      ).writeAsStringSync('{"theme":"light"}');
    }
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('创建失败'), duration: Duration(seconds: 1)),
    );
    log('$e', name: 'main', level: 2000);
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
      SnackBar(content: Text('开始下载歌曲基本数据'), duration: Duration(seconds: 1)),
    );
    await File('${path.path}/songs.json').create();
    await File(
      '${path.path}/songs.json',
    ).writeAsString(await requestSongData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/songs.json');
    // 下载歌曲别名数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载歌曲别名数据'), duration: Duration(seconds: 1)),
    );
    await File('${path.path}/alias.json').create();
    await File(
      '${path.path}/alias.json',
    ).writeAsString(await requestAliasData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/alias.json');
    // 下载机厅数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载机厅数据'), duration: Duration(seconds: 1)),
    );
    await File('${path.path}/location.json').create();
    await File(
      '${path.path}/location.json',
    ).writeAsString(await requestLobbyData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/location.json');
    // 下载角色数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载角色数据'), duration: Duration(seconds: 1)),
    );
    await File('${path.path}/characters.json').create();
    await File(
      '${path.path}/characters.json',
    ).writeAsString(await requestCharactersData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/characters.json');
    // 下载头像数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载头像数据'), duration: Duration(seconds: 1)),
    );
    await File('${path.path}/icons.json').create();
    await File(
      '${path.path}/icons.json',
    ).writeAsString(await requestIconsData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/icons.json');
    // 下载名牌版数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载名牌版数据'), duration: Duration(seconds: 1)),
    );
    await File('${path.path}/plates.json').create();
    await File(
      '${path.path}/plates.json',
    ).writeAsString(await requestPlatesData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/plates.json');
    //下载称号数据
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载称号数据'), duration: Duration(seconds: 1)),
    );
    await File('${path.path}/trophies.json').create();
    await File(
      '${path.path}/trophies.json',
    ).writeAsString(await requestTrophiesData());
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/trophies.json');
    //获取成绩
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载成绩数据'), duration: Duration(seconds: 1)),
    );
    await saveAllScore();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/allscore.json');
    //Rating趋势
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('开始下载Rating趋势数据'), duration: Duration(seconds: 1)),
    );
    await saveTrend();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
    );
    log('保存到 ${path.path}/trend.json');
    print(directory);
  } catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('下载失败，请检查网络'), duration: Duration(seconds: 1)),
    );
    log('$e', name: 'main', level: 2000);
  }
}

//收藏品搜索
Future<List<Widget>> searchCollectibles({
  required String searchtext,
  required BuildContext context,
  required String searchtype,
}) async {
  List<Widget> collectibles = [];
  final directory = await getApplicationSupportDirectory();
  final path = Directory('${directory.path}/res/');

  Widget returnWidget({
    required Map<String, dynamic> data,
    required String type,
  }) {
    String entype = '';
    switch (type) {
      case '头像':
        entype = 'icon';
        break;
      case '名牌版':
        entype = 'plate';
        break;
      case '称号':
        entype = 'trophy';
        break;
      case '角色':
        entype = 'character';
        break;
    }
    return Row(
      children: [
        Expanded(
          child: InkWell(
            key: ValueKey(data['id']),
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CollectibleInfoPage(data: data, type: entype),
                ),
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${data['id']} - ${data['name']} - $type',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //头像搜索
  if (searchtype == 'icon' || searchtype == 'all') {
    String iconJsonStr = await File('${path.path}/icons.json').readAsString();
    Map<String, dynamic> iconJson = json.decode(iconJsonStr);
    for (var i in iconJson['icons']) {
      if (i['name'].toLowerCase().contains(searchtext.toLowerCase())) {
        collectibles.add(returnWidget(data: i, type: '头像'));
      }
    }
    for (var i in iconJson['icons']) {
      if (i['id'].toString().contains(searchtext)) {
        collectibles.add(returnWidget(data: i, type: '头像'));
      }
    }
  }

  //名牌版搜索
  if (searchtype == 'plate' || searchtype == 'all') {
    String plateJsonStr = await File('${path.path}/plates.json').readAsString();
    Map<String, dynamic> plateJson = json.decode(plateJsonStr);
    for (var i in plateJson['plates']) {
      if (i['name'].toLowerCase().contains(searchtext.toLowerCase())) {
        collectibles.add(returnWidget(data: i, type: '名牌版'));
      }
    }
    for (var i in plateJson['plates']) {
      if (i['id'].toString().contains(searchtext)) {
        collectibles.add(returnWidget(data: i, type: '名牌版'));
      }
    }
  }

  //称号搜索
  if (searchtype == 'trophy' || searchtype == 'all') {
    String trophyJsonStr = await File(
      '${path.path}/trophies.json',
    ).readAsString();
    Map<String, dynamic> trophyJson = json.decode(trophyJsonStr);
    for (var i in trophyJson['trophies']) {
      if (i['name'].toLowerCase().contains(searchtext.toLowerCase())) {
        collectibles.add(returnWidget(data: i, type: '称号'));
      }
    }
    for (var i in trophyJson['trophies']) {
      if (i['id'].toString().contains(searchtext)) {
        collectibles.add(returnWidget(data: i, type: '称号'));
      }
    }
  }

  //角色搜索
  if (searchtype == 'character' || searchtype == 'all') {
    String characterJsonStr = await File(
      '${path.path}/characters.json',
    ).readAsString();
    Map<String, dynamic> characterJson = json.decode(characterJsonStr);
    for (var i in characterJson['characters']) {
      if (i['name'].toLowerCase().contains(searchtext.toLowerCase())) {
        collectibles.add(returnWidget(data: i, type: '角色'));
      }
    }
    for (var i in characterJson['characters']) {
      if (i['id'].toString().contains(searchtext)) {
        collectibles.add(returnWidget(data: i, type: '角色'));
      }
    }
  }

  return collectibles;
}

Future<List> returnscoretrendlist() async {
  final path = await getApplicationSupportDirectory();
  String scoretrendJsonStr = await File(
    '${path.path}/res/trend.json',
  ).readAsString();
  Map<String, dynamic> scoretrendJson = json.decode(scoretrendJsonStr);
  return scoretrendJson['data'];
}

void copytext({required String text, required BuildContext context}) {
  try {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('复制成功')));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('复制失败')));
  }
}
