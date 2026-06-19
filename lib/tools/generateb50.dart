import 'dart:io';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:http/http.dart';

Future<img.Image> getIcon({required int id}) async {
  print('请求头像$id');
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

img.Image getrank(String rank) {
  return img.decodePng(File('res/rank/$rank.png').readAsBytesSync())!;
}

Future<img.Image> getimage({required int id}) async {
  print('请求曲绘$id');
  final response = await get(
    Uri.parse('https://assets2.lxns.net/chunithm/jacket/$id.png'),
  );
  final bytes = response.bodyBytes;
  return img.decodeImage(bytes)!;
}

img.Image getClear(String clear) {
  return img.decodePng(File('res/complete/$clear.png').readAsBytesSync())!;
}

img.Image? getfc(String? fullCombo) {
  if (fullCombo == null) return null;
  final file = File('res/complete/$fullCombo.png');
  if (!file.existsSync()) return null;
  return img.decodePng(file.readAsBytesSync());
}

Future<void> generateb50() async {
  // ═══════════ 加载必要文件 ═══════════
  final fontZipFile = await File('res/fnt/font3.zip').readAsBytes();
  final font = img.BitmapFont.fromZip(fontZipFile);

  // 加载b50
  final allscorestr = File('res/bests.json').readAsStringSync();
  final Map<String, dynamic> allscorejson = jsonDecode(allscorestr);
  final Map<String, dynamic> allscore = allscorejson['data'];
  final List bests = allscore['bests'];
  final List newbest = allscore['new_bests'];

  // 加载背景
  var background = img.decodePng(File('res/background.png').readAsBytesSync())!;

  // 加载玩家信息
  final playerinfostr = File('res/player.json').readAsStringSync();
  final Map<String, dynamic> playerinfojson = jsonDecode(playerinfostr);
  final Map<String, dynamic> playerinfo = playerinfojson['data'];

  // ═══════════ 并行预下载所有曲绘 ═══════════
  print('并行预下载所有曲绘...');
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
  print('曲绘下载完成 (${allJackets.length} 张)');

  // ═══════════ 预加载资源 ═══════════
  print('预加载评级/通关/FC图片...');

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
    rankCache[rank] = getrank(rank);
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
    clearCache[c] = getClear(c);
  }

  final fcCache = <String, img.Image>{};
  for (final fc in ['alljusticecritical', 'alljustice', 'fullcombo']) {
    fcCache[fc] = getfc(fc)!;
  }

  // ═══════════ 绘制函数 ═══════════
  void drawSongCard(
    Map song, {
    required int x1,
    required int y1,
    required int index,
  }) {
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
    img.drawString(
      background,
      song['score'].toString(),
      font: font,
      x: x1 + 280,
      y: y1 + 100,
      color: img.ColorRgba8(255, 255, 255, 255),
    );

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
  print('绘制玩家信息');

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
  print('绘制 B30 成绩...');
  int x1 = 7;
  int y1 = 460;
  int lineint = 0;
  int row = 0;
  int index = 1;

  final sw = Stopwatch()..start();

  for (var i in bests) {
    drawSongCard(i, x1: x1, y1: y1, index: index);

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
  print('绘制 B20 成绩...');
  x1 = 7;
  y1 += 325;
  lineint = 0;
  row = 0;

  for (var i in newbest) {
    drawSongCard(i, x1: x1, y1: y1, index: index);

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
  print('绘制耗时: ${sw.elapsedMilliseconds}ms');

  // ═══════════ 水印 ═══════════
  img.drawString(
    background,
    '此b50由 chusearchsong(中二查歌) 生成 成绩最后更新时间 ${playerinfo['upload_time']}',
    font: font,
    x: 5896 ~/ 2 - 300,
    y: 2800,
    color: img.ColorRgba8(0, 0, 0, 255),
  );

  // ═══════════ 保存 ═══════════
  final png = img.encodePng(background);
  await File('image.png').writeAsBytes(png);
  print('图片已保存到 image.png');
}
