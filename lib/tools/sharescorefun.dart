import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;
import 'dart:convert';
import 'package:http/http.dart';
import 'dart:developer';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import '../tools/request.dart';
import 'package:share_plus/share_plus.dart';

Future<img.Image> getimage({required int id}) async {
  log('请求曲绘$id');
  final response = await get(
    Uri.parse('https://assets2.lxns.net/chunithm/jacket/$id.png'),
  );
  final bytes = response.bodyBytes;
  return img.decodeImage(bytes)!;
}

Future<img.Image?> getfc({required Map song}) async {
  if (song['full_combo'] == 'alljusticecritical') {
    final bytes = (await rootBundle.load(
      'res/complete/alljusticecritical.png',
    )).buffer.asUint8List();
    return img.decodePng(bytes);
  } else if (song['full_combo'] == 'alljustice') {
    final bytes = (await rootBundle.load(
      'res/complete/alljustice.png',
    )).buffer.asUint8List();
    return img.decodePng(bytes);
  } else if (song['full_combo'] == 'fullcombo') {
    final bytes = (await rootBundle.load(
      'res/complete/fullcombo.png',
    )).buffer.asUint8List();
    return img.decodePng(bytes);
  } else {
    return null;
  }
}

Future<img.Image> getrank({required String rank}) async {
  final bytes = (await rootBundle.load(
    'res/rank/$rank.png',
  )).buffer.asUint8List();
  return img.decodePng(bytes)!;
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

Future<void> sharescore({required Map<String, dynamic> songdata}) async {
  final path = await getApplicationSupportDirectory();
  final configstr = await File('${path.path}/config.json').readAsString();
  final Map<String, dynamic> config = jsonDecode(configstr);

  // ═══ Phase 1: 并行加载所有资源 ═══
  final results = await Future.wait([
    _loadSongBests(config: config, songId: songdata['id']),
    rootBundle.load('res/fnt/font.zip').then((b) => b.buffer.asUint8List()),
    rootBundle.load('res/sharebg.webp').then((b) => b.buffer.asUint8List()),
    _fetchJacketBytes(id: songdata['id']),
  ]);

  final List songbests = results[0] as List;
  final Uint8List fontBytes = results[1] as Uint8List;
  final Uint8List bgBytes = results[2] as Uint8List;
  final Uint8List jacketBytes = results[3] as Uint8List;

  // 预加载需要的 rank / fc 图标字节
  final rankByteMap = <String, Uint8List>{};
  final fcByteMap = <String, Uint8List>{};
  for (final entry in songbests) {
    final rank = entry['rank'] as String?;
    if (rank != null && !rankByteMap.containsKey(rank)) {
      rankByteMap[rank] = (await rootBundle.load(
        'res/rank/$rank.png',
      )).buffer.asUint8List();
    }
    final fc = entry['full_combo'] as String?;
    if (fc != null && !fcByteMap.containsKey(fc)) {
      fcByteMap[fc] = (await rootBundle.load(
        'res/complete/$fc.png',
      )).buffer.asUint8List();
    }
  }

  // ═══ Phase 2: CPU 密集型图像合成交给 Isolate ═══
  final pngBytes = await Isolate.run(
    () => _generateImage(
      songdata: songdata,
      songbests: songbests,
      fontBytes: fontBytes,
      bgBytes: bgBytes,
      jacketBytes: jacketBytes,
      rankByteMap: rankByteMap,
      fcByteMap: fcByteMap,
    ),
  );

  // ═══ Phase 3: 保存 & 分享 ═══
  if (!Directory('${path.path}/tmp').existsSync()) {
    Directory('${path.path}/tmp').createSync(recursive: true);
  }
  File('${path.path}/tmp/sharebg.png').writeAsBytesSync(pngBytes);
  await SharePlus.instance.share(
    ShareParams(files: [XFile('${path.path}/tmp/sharebg.png')]),
  );
}

// ────────── 辅助函数 ──────────

Future<List> _loadSongBests({
  required Map<String, dynamic> config,
  required int songId,
}) async {
  try {
    final token = config['lxns']['token'] as String?;
    if (token == null) throw Exception('未配置token');
    final str = await requestSongBests(token: token, songid: songId);
    return jsonDecode(str)['data'] as List;
  } catch (e) {
    return [];
  }
}

Future<Uint8List> _fetchJacketBytes({required int id}) async {
  log('请求曲绘$id');
  final response = await get(
    Uri.parse('https://assets2.lxns.net/chunithm/jacket/$id.png'),
  );
  return response.bodyBytes;
}

// ══════════════════════════════════════════════
// 以下函数运行在独立 Isolate 中（不访问 rootBundle / Flutter API）
// ══════════════════════════════════════════════

Uint8List _generateImage({
  required Map<String, dynamic> songdata,
  required List songbests,
  required Uint8List fontBytes,
  required Uint8List bgBytes,
  required Uint8List jacketBytes,
  required Map<String, Uint8List> rankByteMap,
  required Map<String, Uint8List> fcByteMap,
}) {
  final font = img.BitmapFont.fromZip(fontBytes);
  final background = img.decodeWebP(bgBytes)!;
  final jacket = img.decodeImage(jacketBytes)!;

  // ── 绘制难度背景 ──
  int x1 = 1000;
  int y1 = 250;
  for (final i in songdata['difficulties']) {
    final color = _isolateDiffColor(levelindex: i['difficulty']);
    img.fillRect(
      background,
      color: color,
      x1: x1,
      y1: y1,
      x2: x1 + 850,
      y2: y1 + 100,
    );

    String score = '无成绩';
    for (final y in songbests) {
      if (y['level_index'] == i['difficulty']) {
        score = y['score'].toString();

        // rank 图标
        final rank = y['rank'] as String?;
        if (rank != null && rankByteMap.containsKey(rank)) {
          final rankImg = img.decodePng(rankByteMap[rank]!)!;
          img.compositeImage(
            background,
            img.copyResize(rankImg, width: 150),
            dstX: x1 + 500,
            dstY: y1 + 15,
          );
        }

        // fc 图标
        final fc = y['full_combo'] as String?;
        if (fc != null && fcByteMap.containsKey(fc)) {
          final fcImg = img.decodePng(fcByteMap[fc]!)!;
          img.compositeImage(
            background,
            img.copyResize(fcImg, width: 150),
            dstX: x1 + 660,
            dstY: y1 + 35,
          );
        }
      }
    }

    img.drawString(
      background,
      '${i['level_value']}   ${i['note_designer']}   $score',
      font: font,
      x: x1 + 20,
      y: y1 + 30,
    );
    y1 += 150;
  }

  // ── 绘制曲绘 ──
  img.compositeImage(
    background,
    img.copyResize(jacket, width: 800),
    dstX: 100,
    dstY: 200,
  );

  // ── 绘制曲名（动态缩放） ──
  const maxTitleWidth = 700;
  const singleCharWidth = 20;
  const maxTitleHeight = 200;
  const minTitleHeight = 80;

  final titleText = songdata['title'] as String;
  final rawTitleImage = img.Image(
    width: titleText.length * singleCharWidth,
    height: 40,
    numChannels: 4,
  );
  img.fill(rawTitleImage, color: img.ColorRgba8(0, 0, 0, 0));
  img.drawString(
    rawTitleImage,
    titleText,
    font: font,
    color: img.ColorRgba8(0, 0, 0, 255),
  );

  final scaleHeight = (maxTitleWidth / titleText.length * 2)
      .clamp(minTitleHeight.toDouble(), maxTitleHeight.toDouble())
      .toInt();
  final titleImage = img.copyResize(rawTitleImage, height: scaleHeight);
  final titleDstX = (200 - titleImage.width / 2).toInt().clamp(0, 200);
  img.compositeImage(background, titleImage, dstX: titleDstX, dstY: 70);

  // ── 绘制其余信息 ──
  img.drawString(
    background,
    '曲师: ${songdata['artist']}      BPM: ${songdata['bpm']}\n\n分类: ${songdata['genre']}      版本: ${songdata['version']}',
    font: font,
    x: 1000,
    y: 50,
    color: img.ColorRgb8(0, 0, 0),
  );
  img.drawString(
    background,
    '此成绩图由 chusearchsong(中二查歌) 生成',
    font: font,
    x: 650,
    y: 1025,
    color: img.ColorRgba8(0, 0, 0, 255),
  );

  return Uint8List.fromList(img.encodePng(background));
}

img.Color _isolateDiffColor({required int levelindex}) {
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
