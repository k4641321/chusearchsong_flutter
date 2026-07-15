import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:developer';
import '../tools/request.dart';
import 'package:path_provider/path_provider.dart';

Future<img.Image> getIcon({required int id}) async {
  log('请求头像$id');
  final response = await get(
    Uri.parse('https://assets2.lxns.net/chunithm/character/$id.png'),
  );
  final bytes = response.bodyBytes;
  return img.decodeImage(bytes)!;
}

img.Color ratingColor({required double rating}) {
  if (rating > 0 && rating < 3.99) {
    return img.ColorRgba8(0, 153, 76, 255);
  } else if (rating > 4.0 && rating < 6.49) {
    return img.ColorRgba8(255, 153, 51, 255);
  } else if (rating > 7.0 && rating < 9.99) {
    return img.ColorRgba8(255, 0, 0, 255);
  } else if (rating > 10.0 && rating < 11.99) {
    return img.ColorRgba8(153, 0, 153, 255);
  } else if (rating > 12.0 && rating < 13.24) {
    return img.ColorRgba8(204, 102, 0, 255);
  } else if (rating > 13.25 && rating < 14.49) {
    return img.ColorRgba8(244, 244, 244, 255);
  } else if (rating > 14.50 && rating < 15.24) {
    return img.ColorRgba8(255, 255, 0, 255);
  } else if (rating > 15.25 && rating < 15.99) {
    return img.ColorRgba8(255, 255, 102, 255);
  } else if (rating > 16.0 && rating < 16.99) {
    return img.ColorRgba8(255, 0, 255, 255);
  } else if (rating > 17.0) {
    return img.ColorRgba8(255, 153, 255, 255);
  } else {
    return img.ColorRgba8(0, 0, 0, 255);
  }
}

img.Color diffcolor({required int levelindex}) {
  switch (levelindex) {
    case 0:
      return img.ColorRgba8(153, 255, 153, 255);
    case 1:
      return img.ColorRgba8(255, 153, 51, 255);
    case 2:
      return img.ColorRgba8(255, 51, 51, 255);
    case 3:
      return img.ColorRgba8(178, 102, 255, 255);
    case 4:
      return img.ColorRgba8(32, 32, 32, 255);
    default:
      return img.ColorRgba8(192, 192, 192, 255);
  }
}

Future<img.Image> getrank(String rank) async {
  final data = await rootBundle.load('res/rank/$rank.png');
  return img.decodePng(data.buffer.asUint8List())!;
}

Future<img.Image> getimage({required int id}) async {
  log('请求曲绘$id');
  final response = await get(
    Uri.parse('https://assets2.lxns.net/chunithm/jacket/$id.png'),
  );
  final bytes = response.bodyBytes;
  return img.decodeImage(bytes)!;
}

Future<img.Image> getClear(String clear) async {
  final clearimg = await rootBundle.load('res/complete/$clear.png');
  final bytes = clearimg.buffer.asUint8List();
  return img.decodePng(bytes)!;
}

Future<img.Image?> getfc(String? fullCombo) async {
  if (fullCombo == null) return null;
  final data = await rootBundle.load('res/complete/$fullCombo.png');
  final bytes = data.buffer.asUint8List();
  return img.decodePng(bytes);
}

Future<void> generateb50() async {
  // ═══════════ 加载必要文件 ═══════════
  final configpath = await getApplicationSupportDirectory();
  final configstr = await File('${configpath.path}/config.json').readAsString();
  final Map<String, dynamic> configjson = jsonDecode(configstr);
  final lxnstoken = configjson['lxns']['token'];
  final fontZipData = await rootBundle.load('res/fnt/font.zip');
  final font = img.BitmapFont.fromZip(fontZipData.buffer.asUint8List());

  // 加载b50
  final allscorestr = await requestB50(token: lxnstoken);
  final Map<String, dynamic> allscorejson = jsonDecode(allscorestr);
  final Map<String, dynamic> allscore = allscorejson['data'];
  final List bests = allscore['bests'];
  final List newbest = allscore['new_bests'];

  // 加载背景
  final bgData = await rootBundle.load('res/background.png');
  var background = img.decodePng(bgData.buffer.asUint8List())!;

  // 加载玩家信息
  final playerinfostr = await requestPlayerInfo(token: lxnstoken);
  final Map<String, dynamic> playerinfojson = jsonDecode(playerinfostr);
  final Map<String, dynamic> playerinfo = playerinfojson['data'];

  // ═══════════ 并行预下载所有曲绘 ═══════════
  log('并行预下载所有曲绘...');
  final allSongs = [...bests, ...newbest];
  final allJackets = <int, img.Image>{};
  final futures = <Future>[];
  for (final song in allSongs) {
    futures.add(
      getimage(id: song['id']).then((jacket) {
        allJackets[song['id']] = img.copyResize(jacket, height: 270);
      }),
    );
  }
  await Future.wait(futures);
  log('曲绘下载完成 (${allJackets.length} 张)');

  // ═══════════ 预加载资源 ═══════════
  log('预加载评级/通关/FC图片...');

  final rankCache = <String, img.Image>{};
  for (final rank in [
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
  ]) {
    rankCache[rank] = await getrank(rank);
  }

  final clearCache = <String, img.Image>{};
  for (final c in [
    'catastrophy',
    'absolute',
    'brave',
    'hard',
    'clear',
    'failed',
  ]) {
    clearCache[c] = await getClear(c);
  }

  final fcCache = <String, img.Image>{};
  for (final fc in ['alljusticecritical', 'alljustice', 'fullcombo']) {
    fcCache[fc] = (await getfc(fc))!;
  }

  // ═══════════ 绘制函数 ═══════════
  Future<void> drawSongCard(
    Map song, {
    required int x1,
    required int y1,
    required int index,
  }) async {
    final color = diffcolor(levelindex: song['level_index']);

    // 背景色块
    img.fillRect(
      background,
      x1: x1,
      y1: y1,
      x2: x1 + 570,
      y2: y1 + 350,
      color: color,
    );

    // 曲绘
    final jacket = allJackets[song['id']]!;
    img.compositeImage(background, jacket, dstX: x1 + 10, dstY: y1 + 10);

    // 曲名
    img.drawString(
      background,
      song['song_name'],
      font: font,
      x: x1 + 10,
      y: y1 + 295,
      color: img.ColorRgba8(255, 255, 255, 255),
    );

    // 分数
    final scorecmd = img.Command()
      ..createImage(width: 150, height: 35)
      ..fill(color: diffcolor(levelindex: song['level_index']))
      ..drawString(song['score'].toString(), font: font);
    final scoreImage = await scorecmd.getImage();
    img.Image scoreimg = img.copyResize(scoreImage!, width: 280);
    img.compositeImage(background, scoreimg, dstX: x1 + 280, dstY: y1 + 100);

    // img.drawString(
    //   background,
    //   song['score'].toString(),
    //   font: font,
    //   x: x1 + 280,
    //   y: y1 + 100,
    //   color: img.ColorRgba8(255, 255, 255, 255),
    // );

    // 排序
    img.drawString(
      background,
      '#$index',
      font: font,
      x: x1 + 495,
      y: y1,
      color: img.ColorRgba8(255, 255, 255, 255),
    );

    // 难度
    img.drawString(
      background,
      song['level'],
      font: font,
      x: x1 + 280,
      y: y1,
      color: img.ColorRgba8(255, 255, 255, 255),
    );

    // 评级
    final rank = rankCache[song['rank']] ?? rankCache['d']!;
    img.compositeImage(
      background,
      img.copyResize(rank, width: 170),
      dstX: x1 + 280,
      dstY: y1 + 35,
    );

    // Rating
    img.drawString(
      background,
      'Rating: ${song['rating']}',
      font: font,
      x: x1 + 285,
      y: y1 + 160,
      color: img.ColorRgba8(255, 255, 255, 255),
    );

    // 通关情况
    final clear = clearCache[song['clear']] ?? clearCache['failed']!;
    img.compositeImage(
      background,
      img.copyResize(clear, width: 230),
      dstX: x1 + 310,
      dstY: y1 + 205,
    );

    // FC
    final fc = fcCache[song['full_combo']];
    if (fc != null) {
      img.compositeImage(
        background,
        img.copyResize(fc, width: 230),
        dstX: x1 + 310,
        dstY: y1 + 250,
      );
    }
  }

  // ═══════════ 绘制玩家信息 ═══════════
  log('绘制玩家信息');

  // 玩家信息背景
  final namebackgroundCmd = img.Command()
    ..createImage(width: 850, height: 250)
    ..fill(color: img.ColorRgba8(255, 255, 255, 255))
    ..fillRect(
      x1: 0,
      y1: 125,
      x2: 850,
      y2: 250,
      color: img.ColorRgba8(244, 244, 244, 255),
    );
  await namebackgroundCmd.executeThread();
  final namebackground = await namebackgroundCmd.getImage();
  img.compositeImage(background, namebackground!, dstX: 100, dstY: 100);

  // 等级与名称
  final nameandlevelCmd = img.Command()
    ..createImage(width: 400, height: 50)
    ..fill(color: img.ColorRgba8(255, 255, 255, 255))
    ..drawString(
      'Lv.${playerinfo['level']} ${playerinfo['name']}',
      font: font,
      color: img.ColorRgba8(0, 0, 0, 255),
    );
  await nameandlevelCmd.executeThread();
  final nameandlevel = await nameandlevelCmd.getImage();
  img.compositeImage(
    background,
    img.copyResize(nameandlevel!, height: 80),
    dstX: 100,
    dstY: 180,
  );

  // 玩家头像
  final plaerIcon = await getIcon(id: playerinfo['character']['id']);
  img.compositeImage(
    background,
    img.copyResize(plaerIcon, height: 225),
    dstX: 720,
    dstY: 110,
  );

  // Rating
  final ratingCmd = img.Command()
    ..createImage(width: 225, height: 50)
    ..fill(color: img.ColorRgba8(244, 244, 244, 255))
    ..drawString(
      'Rating: ${playerinfo['rating']}',
      font: font,
      color: ratingColor(rating: playerinfo['rating']),
    );
  await ratingCmd.executeThread();
  final rating = await ratingCmd.getImage();
  img.compositeImage(
    background,
    img.copyResize(rating!, height: 80),
    dstX: 130,
    dstY: 260,
  );

  // B30 文字
  final b30strCmd = img.Command()
    ..createImage(width: 300, height: 80)
    ..fill(color: img.ColorRgba8(0, 51, 102, 255))
    ..drawString('B30', font: font, color: img.ColorRgba8(255, 255, 255, 255));
  await b30strCmd.executeThread();
  final b30str = await b30strCmd.getImage();
  img.compositeImage(
    background,
    img.copyResize(b30str!, height: 200),
    dstX: 2650,
    dstY: 200,
  );

  // B20 文字
  final b20strCmd = img.Command()
    ..createImage(width: 300, height: 80)
    ..fill(color: img.ColorRgba8(0, 51, 102, 255))
    ..drawString('B20', font: font, color: img.ColorRgba8(255, 255, 255, 255));
  await b20strCmd.executeThread();
  final b20str = await b20strCmd.getImage();
  img.compositeImage(
    background,
    img.copyResize(b20str!, height: 200),
    dstX: 2650,
    dstY: 1700,
  );

  // ═══════════ 绘制 B30 ═══════════
  log('绘制 B30 成绩...');
  int x1 = 7;
  int y1 = 460;
  int lineint = 0;
  int row = 0;
  int index = 1;

  final sw = Stopwatch()..start();

  for (var i in bests) {
    await drawSongCard(i, x1: x1, y1: y1, index: index);

    x1 += 570 + 20;
    lineint++;
    index++;
    if (lineint == 10) {
      lineint = 0;
      row++;
      x1 = 7;
      y1 += 350 + 50;
    }
  }

  // ═══════════ 绘制 B20 ═══════════
  log('绘制 B20 成绩...');
  x1 = 7;
  y1 += 325;
  lineint = 0;
  row = 0;

  for (var i in newbest) {
    await drawSongCard(i, x1: x1, y1: y1, index: index);

    x1 += 570 + 20;
    lineint++;
    index++;
    if (lineint == 10) {
      lineint = 0;
      row++;
      x1 = 7;
      y1 += 350 + 50;
    }
  }

  sw.stop();
  log('绘制耗时: ${sw.elapsedMilliseconds}ms');

  // ═══════════ 水印 ═══════════
  img.drawString(
    background,
    '此b50由 chusearchsong(中二查歌) 生成 成绩最后更新时间 ${DateTime.parse(playerinfo['upload_time']).toLocal()}',
    font: font,
    x: 5896 ~/ 2 - 300,
    y: 2800,
    color: img.ColorRgba8(0, 0, 0, 255),
  );

  // ═══════════ 保存 ═══════════
  final png = img.encodePng(background);
  if (!Directory('${configpath.path}/tmp').existsSync()) {
    await Directory('${configpath.path}/tmp').create();
  }
  await File('${configpath.path}/tmp/b50.png').writeAsBytes(png);
  log('图片已保存到 b50.png');
}
