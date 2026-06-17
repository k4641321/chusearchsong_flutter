import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import './request.dart';

Future<Uint8List> loadAsset(String path) async {
  final data = await rootBundle.load(path);
  return data.buffer.asUint8List();
}

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

Future<img.Image> getrank({required String rank}) async {
  final bytes = await loadAsset('res/rank/$rank.png');
  return img.decodePng(bytes)!;
}

Future<img.Image> getimage({required int id}) async {
  log('请求曲绘$id');
  final response = await get(
    Uri.parse('https://assets2.lxns.net/chunithm/jacket/$id.png'),
  );
  final bytes = response.bodyBytes;
  return img.decodeImage(bytes)!;
}

Future<img.Image> getClear({required Map<String, dynamic> song}) async {
  String path;
  if (song['clear'] == 'catastrophy') {
    path = 'res/complete/catastrophy.png';
  } else if (song['clear'] == 'absolute') {
    path = 'res/complete/absolute.png';
  } else if (song['clear'] == 'brave') {
    path = 'res/complete/brave.png';
  } else if (song['clear'] == 'hard') {
    path = 'res/complete/hard.png';
  } else if (song['clear'] == 'clear') {
    path = 'res/complete/clear.png';
  } else {
    path = 'res/complete/failed.png';
  }
  final bytes = await loadAsset(path);
  return img.decodePng(bytes)!;
}

Future<img.Image?> getfc({required Map song}) async {
  String? path;
  if (song['full_combo'] == 'alljusticecritical') {
    path = 'res/complete/alljusticecritical.png';
  } else if (song['full_combo'] == 'alljustice') {
    path = 'res/complete/alljustice.png';
  } else if (song['full_combo'] == 'fullcombo') {
    path = 'res/complete/fullcombo.png';
  }
  if (path != null) {
    final bytes = await loadAsset(path);
    return img.decodePng(bytes);
  }
  return null;
}

Future<void> generateb50() async {
  //加载必要文件

  //获取落雪token

  final path = await getApplicationSupportDirectory();
  final configstr = File('${path.path}/config.json').readAsStringSync();
  final Map<String, dynamic> config = jsonDecode(configstr);
  final String token = config['lxns']['token'];
  //加载字体包

  final fontZipBytes = await loadAsset('res/fnt/font.zip');
  //加载b50

  final allscorestr = await requestB50(token: token);
  final Map<String, dynamic> allscorejson = jsonDecode(allscorestr);
  final Map<String, dynamic> allscore = allscorejson['data'];
  final List bests = allscore['bests'];
  final List newbest = allscore['new_bests'];
  //加载背景

  final backgroundBytes = await loadAsset('res/background.png');
  final background = img.decodePng(backgroundBytes)!;
  //加载玩家信息

  final playerinfostr = await requestPlayerInfo(token: token);
  final Map<String, dynamic> playerinfojson = jsonDecode(playerinfostr);
  final Map<String, dynamic> playerinfo = playerinfojson['data'];
  //定义起始位置

  int x1 = 7;
  int y1 = 460;
  // int x2 = 860;
  // int y2 = 910;
  int lineint = 0;
  int row = 0;
  int jacketx1 = 10;
  int jackety1 = 470;
  int index = 1;
  //绘制玩家信息

  final img.Command namebackgroundcmd = img.Command()
    ..createImage(width: 850, height: 250)
    ..fill(color: img.ColorRgba8(255, 255, 255, 255))
    ..fillRect(
      x1: 0,
      y1: 125,
      x2: 850,
      y2: 250,
      color: img.ColorRgba8(244, 244, 244, 255),
    );
  //绘制玩家背景信息

  final namebackground = await namebackgroundcmd.getImage();
  img.compositeImage(background, namebackground!, dstX: 100, dstY: 100);
  //绘制等级与名称

  final img.Command nameandlevelcmd = img.Command()
    ..createImage(width: 400, height: 50)
    ..fill(color: img.ColorRgba8(255, 255, 255, 255))
    ..drawString(
      'Lv.${playerinfo['level']} ${playerinfo['name']}',
      font: img.BitmapFont.fromZip(fontZipBytes),
      color: img.ColorRgba8(0, 0, 0, 255),
    );
  final nameandlevel = await nameandlevelcmd.getImage();
  img.compositeImage(
    background,
    img.copyResize(nameandlevel!, height: 80),
    dstX: 100,
    dstY: 180,
  );
  //绘制玩家头像

  final plaerIcon = await getIcon(id: playerinfo['character']['id']);
  img.compositeImage(
    background,
    img.copyResize(plaerIcon, height: 225),
    dstX: 720,
    dstY: 110,
  );
  //绘制Rating

  final img.Command ratingcmd = img.Command()
    ..createImage(width: 225, height: 50)
    ..fill(color: img.ColorRgba8(244, 244, 244, 255))
    ..drawString(
      'Rating: ${playerinfo['rating']}',
      font: img.BitmapFont.fromZip(fontZipBytes),
      color: ratingColor(rating: playerinfo['rating']),
    );
  final rating = await ratingcmd.getImage();
  img.compositeImage(
    background,
    img.copyResize(rating!, height: 80),
    dstX: 130,
    dstY: 260,
  );
  //绘制b30文字

  final img.Command b30strcmd = img.Command()
    ..createImage(width: 300, height: 80)
    ..fill(color: img.ColorRgba8(0, 51, 102, 255))
    ..drawString(
      "B30",
      font: img.BitmapFont.fromZip(fontZipBytes),
      color: img.ColorRgba8(255, 255, 255, 255),
    );
  final b30str = await b30strcmd.getImage();
  img.compositeImage(
    background,
    img.copyResize(b30str!, height: 200),
    dstX: 2650,
    dstY: 200,
  );
  //绘制b20文字

  final img.Command b20strcmd = img.Command()
    ..createImage(width: 300, height: 80)
    ..fill(color: img.ColorRgba8(0, 51, 102, 255))
    ..drawString(
      "B20",
      font: img.BitmapFont.fromZip(fontZipBytes),
      color: img.ColorRgba8(255, 255, 255, 255),
    );
  final b20str = await b20strcmd.getImage();
  img.compositeImage(
    background,
    img.copyResize(b20str!, height: 200),
    dstX: 2650,
    dstY: 1700,
  );
  for (var i in bests) {
    log('绘制 # $index');

    //绘制成绩背景

    img.fillRect(
      background,
      x1: x1,
      y1: y1,
      x2: x1 + 570,
      y2: y1 + 350,
      color: diffcolor(levelindex: i['level_index']),
    );
    //绘制曲绘

    img.Image jacket = await getimage(id: i['id']);
    img.compositeImage(
      background,
      img.copyResize(jacket, height: 270),
      dstX: x1 + 10,
      dstY: y1 + 10,
      srcW: 270,
      srcH: 270,
    );
    //绘制曲名

    img.drawString(
      background,
      i['song_name'],
      font: img.BitmapFont.fromZip(fontZipBytes),
      x: x1 + 10,
      y: y1 + 295,
      color: img.ColorRgba8(255, 255, 255, 255),
    );
    //绘制分数

    final scorecmd = img.Command()
      ..createImage(width: 150, height: 35)
      ..fill(color: diffcolor(levelindex: i['level_index']))
      ..drawString(
        i['score'].toString(),
        font: img.BitmapFont.fromZip(fontZipBytes),
      );
    final scoreImage = await scorecmd.getImage();
    img.Image scoreimg = img.copyResize(scoreImage!, width: 280);
    img.compositeImage(background, scoreimg, dstX: x1 + 280, dstY: y1 + 100);
    //绘制排序

    img.drawString(
      background,
      '#$index',
      font: img.BitmapFont.fromZip(fontZipBytes),
      x: x1 + 495,
      y: y1,
    );
    //绘制难度

    img.drawString(
      background,
      i['level'],
      font: img.BitmapFont.fromZip(fontZipBytes),
      x: x1 + 280,
      y: y1,
    );
    //绘制评级

    img.Image rankimg = await getrank(rank: i['rank']);
    img.compositeImage(
      background,
      img.copyResize(rankimg, width: 170),
      dstX: x1 + 280,
      dstY: y1 + 35,
      // srcW: 270,
      // srcH: 270,
    );
    //绘制Rating

    img.drawString(
      background,
      'Rating: ${i['rating']}',
      font: img.BitmapFont.fromZip(fontZipBytes),
      x: x1 + 285,
      y: y1 + 160,
    );
    //绘制通关情况

    img.Image complete = await getClear(song: i);
    img.compositeImage(
      background,
      img.copyResize(complete, width: 230),
      dstX: x1 + 310,
      dstY: y1 + 205,
      // srcW: 270,
      // srcH: 270,
    );
    //绘制fc

    img.Image? fullcombo = await getfc(song: i);
    if (fullcombo == null) {
      log('跳过fc');
    } else {
      img.compositeImage(
        background,
        img.copyResize(fullcombo, width: 230),
        dstX: x1 + 310,
        dstY: y1 + 250,
        // srcW: 270,
        // srcH: 270,
      );
    }

    x1 += 570 + 20;
    lineint++;
    index++;
    if (lineint == 10) {
      lineint = 0;
      row++;
      x1 = 7;
      y1 += 350 + 50;
    }
    // break;
  }

  //b30
  // while (row < 3) {

  // }

  //b20
  //初始化位置

  x1 = 7;
  y1 += 325;
  lineint = 0;
  row = 0;

  for (var i in newbest) {
    log('绘制 # $index');

    //绘制背景

    img.fillRect(
      background,
      x1: x1,
      y1: y1,
      x2: x1 + 570,
      y2: y1 + 350,
      color: diffcolor(levelindex: i['level_index']),
    );
    //绘制曲绘

    img.Image jacket = await getimage(id: i['id']);
    img.compositeImage(
      background,
      img.copyResize(jacket, height: 270),
      dstX: x1 + 10,
      dstY: y1 + 10,
      srcW: 270,
      srcH: 270,
    );
    //绘制曲名

    img.drawString(
      background,
      i['song_name'],
      font: img.BitmapFont.fromZip(fontZipBytes),
      x: x1 + 10,
      y: y1 + 295,
      color: img.ColorRgba8(255, 255, 255, 255),
    );
    //绘制分数

    final scorecmd = img.Command()
      ..createImage(width: 150, height: 35)
      ..fill(color: diffcolor(levelindex: i['level_index']))
      ..drawString(
        i['score'].toString(),
        font: img.BitmapFont.fromZip(fontZipBytes),
      );
    final scoreImage = await scorecmd.getImage();
    img.Image scoreimg = img.copyResize(scoreImage!, width: 280);
    img.compositeImage(background, scoreimg, dstX: x1 + 280, dstY: y1 + 100);
    //绘制排序

    img.drawString(
      background,
      '#$index',
      font: img.BitmapFont.fromZip(fontZipBytes),
      x: x1 + 495,
      y: y1,
    );
    //绘制难度

    img.drawString(
      background,
      i['level'],
      font: img.BitmapFont.fromZip(fontZipBytes),
      x: x1 + 280,
      y: y1,
    );
    //绘制评级

    img.Image rankimg = await getrank(rank: i['rank']);
    img.compositeImage(
      background,
      img.copyResize(rankimg, width: 170),
      dstX: x1 + 280,
      dstY: y1 + 35,
      // srcW: 270,
      // srcH: 270,
    );
    //绘制Rating

    img.drawString(
      background,
      'Rating: ${i['rating']}',
      font: img.BitmapFont.fromZip(fontZipBytes),
      x: x1 + 285,
      y: y1 + 160,
    );
    //绘制通关情况

    img.Image complete = await getClear(song: i);
    img.compositeImage(
      background,
      img.copyResize(complete, width: 230),
      dstX: x1 + 310,
      dstY: y1 + 205,
      // srcW: 270,
      // srcH: 270,
    );
    //绘制fc

    img.Image? fullcombo = await getfc(song: i);
    if (fullcombo == null) {
      log('跳过fc');
    } else {
      img.compositeImage(
        background,
        img.copyResize(fullcombo, width: 230),
        dstX: x1 + 310,
        dstY: y1 + 250,
        // srcW: 270,
        // srcH: 270,
      );
    }

    x1 += 570 + 20;
    lineint++;
    index++;
    if (lineint == 10) {
      lineint = 0;
      row++;
      x1 = 7;
      y1 += 350 + 50;
    }
    // break;
  }

  img.drawString(
    background,
    '此b50由 chusearchsong(中二查歌) 生成 成绩最后更新时间 ${playerinfo['upload_time']}',
    font: img.BitmapFont.fromZip(fontZipBytes),
    x: 5896 ~/ 2 - 300,
    y: 2800,
    color: img.ColorRgba8(0, 0, 0, 255),
  );
  final png = img.encodePng(background);
  if (!Directory('${path.path}/tmp').existsSync()) {
    await Directory('${path.path}/tmp').create();
  }
  await File('${path.path}/tmp/b50.png').writeAsBytes(png);
}
