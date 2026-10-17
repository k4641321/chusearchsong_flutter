import 'package:chusearchsong_flutter/function/commonfun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/aj50fun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/fc50fun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/otherb50.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/randomb50pagefun.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';

Future<Widget?> selectb50({
  required String b50type,
  required BuildContext context,
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> playerdata,
  required List allscoredata,
  required Map<String, dynamic> b50data,
  required bool generateS10,
  required String thunderboltb50,
  required List versionList,
  String? genre,
  int? n50,
}) async {
  if (b50type == 'b50' || b50type == '个人理论50' || b50type == '理论50') {
    return await generateb50Body(
      context: context,
      songsData: songsData,
      playerdata: playerdata,
      b50data: b50data,
      type: b50type,
      generateS10: generateS10,
      thunderboltb50: thunderboltb50,
    );
  } else if (b50type == 'random50') {
    return await randomb50Body(
      context: context,
      songsData: songsData,
      playerdata: playerdata,
      allscoredata: allscoredata,
      thunderboltb50: thunderboltb50,
    );
  } else if (b50type == 'aj30') {
    return await aj50Body(
      context: context,
      songsData: songsData,
      playerdata: playerdata,
      allscoredata: allscoredata,
      thunderboltb50: thunderboltb50,
    );
  } else if (b50type == 'fc30') {
    return await fc50Body(
      context: context,
      songsData: songsData,
      playerdata: playerdata,
      allscoredata: allscoredata,
      thunderboltb50: thunderboltb50,
    );
  } else {
    return await generateother50Body(
      context: context,
      songsData: songsData,
      playerdata: playerdata,
      allscoredata: allscoredata,
      type: b50type,
      genreorversion: genre,
      thunderboltb50: thunderboltb50,
      versionlist: versionList,
      n50: n50,
    );
  }
}

Color diffcolor({required int diffindex}) {
  switch (diffindex) {
    case 0:
      return Colors.green;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.red;
    case 3:
      return Colors.purple;
    case 4:
      return Colors.black;
    case 5:
      return Colors.pink;
    default:
      return Colors.white;
  }
}

Color ratingColor({required double rating}) {
  if (rating >= 0 && rating < 4) {
    return Colors.green; // 绿  0.00~3.99
  } else if (rating < 7) {
    return Colors.orange; // 橙  4.00~6.99
  } else if (rating < 10) {
    return Colors.red; // 红  7.00~9.99
  } else if (rating < 12) {
    return Colors.deepPurple; // 紫  10.00~11.99
  } else if (rating < 13.25) {
    return Colors.deepOrange; // 铜  12.00~13.24
  } else if (rating < 14.5) {
    return Colors.grey; // 银  13.25~14.49
  } else if (rating < 15.25) {
    return Colors.yellow; // 金  14.50~15.24
  } else if (rating < 16) {
    return Colors.amber; // 铂金 15.25~15.99
  } else if (rating < 17) {
    return Colors.purple; // 彩虹 16.00~16.99
  } else {
    return Colors.purpleAccent; // 彩虹(极) 17.00~
  }
}

Color trophyColor({required String trophy}) {
  switch (trophy) {
    case 'platina':
      return Colors.purpleAccent;
    case 'gold':
      return Colors.yellowAccent;
    case 'silver':
      return Colors.grey;
    default:
      return Colors.white;
  }
}

String rankImg({required String rank}) {
  switch (rank) {
    case 'sssp':
      return 'res/rank/sssp.png';
    case 'sss':
      return 'res/rank/sss.png';
    case 'ssp':
      return 'res/rank/ssp.png';
    case 'ss':
      return 'res/rank/ss.png';
    case 'sp':
      return 'res/rank/sp.png';
    case 's':
      return 'res/rank/s.png';
    case 'aaa':
      return 'res/rank/aaa.png';
    case 'aa':
      return 'res/rank/aa.png';
    case 'a':
      return 'res/rank/a.png';
    case 'bbb':
      return 'res/rank/bbb.png';
    case 'bb':
      return 'res/rank/bb.png';
    case 'b':
      return 'res/rank/b.png';
    case 'c':
      return 'res/rank/c.png';
    case 'd':
      return 'res/rank/d.png';
    default:
      return 'res/rank/d.png';
  }
}

String clearImg({required String clear}) {
  switch (clear) {
    case 'failed':
      return 'res/complete/failed.png';
    case 'clear':
      return 'res/complete/clear.png';
    case 'hard':
      return 'res/complete/hard.png';
    case 'brave':
      return 'res/complete/brave.png';
    case 'catastrophy':
      return 'res/complete/catastrophy.png';
    case 'absolute':
      return 'res/complete/absolute.png';
    default:
      return 'res/complete/failed.png';
  }
}

Color clearColor({required String clear}) {
  switch (clear) {
    case 'failed':
      return Colors.grey;
    case 'clear':
      return const Color.fromARGB(255, 255, 183, 59);
    case 'hard':
      return Colors.yellow;
    case 'brave':
      return Colors.yellow;
    case 'catastrophy':
      return Colors.yellow;
    case 'absolute':
      return Colors.yellow;
    default:
      return Colors.grey;
  }
}

Color clearBroder({required String clear}) {
  switch (clear) {
    case 'failed':
      return const Color.fromARGB(255, 130, 130, 130);
    case 'clear':
      return const Color.fromARGB(255, 255, 141, 59);
    case 'hard':
      return const Color.fromARGB(255, 255, 186, 59);
    case 'brave':
      return const Color.fromARGB(255, 255, 186, 59);
    case 'catastrophy':
      return const Color.fromARGB(255, 255, 186, 59);
    case 'absolute':
      return const Color.fromARGB(255, 255, 186, 59);
    default:
      return Colors.grey;
  }
}

String? fullcomboImg({required String fullcombo}) {
  switch (fullcombo) {
    case 'fullcombo':
      return 'res/complete/fullcombo.png';
    case 'alljustice':
      return 'res/complete/alljustice.png';
    case 'alljusticecritical':
      return 'res/complete/alljusticecritical.png';
    default:
      return null;
  }
}

Color? fullcombocolor({required String fullcombo}) {
  switch (fullcombo) {
    case 'fullcombo':
      return Colors.yellow;
    case 'alljustice':
      return Colors.purpleAccent;
    case 'alljusticecritical':
      return Colors.deepPurpleAccent;
    default:
      return null;
  }
}

Color fullcomboBrodercolor({required String fullcombo}) {
  switch (fullcombo) {
    case 'fullcombo':
      return const Color.fromARGB(255, 255, 186, 59);
    case 'alljustice':
      return Colors.purple;
    case 'alljusticecritical':
      return Colors.deepPurple;
    default:
      return Colors.grey;
  }
}

String? fullcomStringCut({required String fullcombo}) {
  switch (fullcombo) {
    case 'fullcombo':
      return 'FC';
    case 'alljustice':
      return 'AJ';
    case 'alljusticecritical':
      return 'AJC';
    default:
      return null;
  }
}

LinearGradient rankColor({required String rank}) {
  if (rank == 'sssp' ||
      rank == 'sss' ||
      rank == 'ssp' ||
      rank == 'ss' ||
      rank == 'sp' ||
      rank == 's') {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.red,
        Colors.orange,
        Colors.yellow,
        Colors.green,
        Colors.cyan,
        Colors.blue,
        Colors.purple,
      ],
    );
  } else if (rank == 'aaa' || rank == 'aa' || rank == 'a') {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Colors.yellow, Colors.orange, Colors.yellow],
    );
  } else if (rank == 'bbb' || rank == 'bb' || rank == 'b') {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromARGB(255, 59, 255, 239),
        Color.fromARGB(255, 0, 140, 255),
        Color.fromARGB(255, 59, 255, 239),
      ],
    );
  } else if (rank == 'c') {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromARGB(255, 27, 146, 0),
        Color.fromARGB(255, 5, 105, 0),
        Color.fromARGB(255, 27, 146, 0),
      ],
    );
  } else {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromARGB(255, 205, 203, 203),
        Colors.grey,
        Color.fromARGB(255, 205, 203, 203),
      ],
    );
  }
}

//普通B50与理论B50与带S10的50
Future<Widget> generateb50Body({
  required BuildContext context,
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> playerdata,
  required Map<String, dynamic> b50data,
  required String type,
  required bool generateS10,
  required String thunderboltb50,
}) async {
  if (type == '个人理论50') {
    for (var i in b50data['bests']) {
      for (var j in songsData['songs']) {
        if (i['id'] == j['id']) {
          for (var k in j['difficulties']) {
            if (k['difficulty'] == i['level_index']) {
              i['level_value'] = k['level_value'];
            }
          }
        }
      }
    }
    for (var i in b50data['new_bests']) {
      for (var j in songsData['songs']) {
        if (i['id'] == j['id']) {
          for (var k in j['difficulties']) {
            if (k['difficulty'] == i['level_index']) {
              i['level_value'] = k['level_value'];
            }
          }
        }
      }
    }
    (b50data['new_bests'] as List).sort(
      (a, b) => b['level_value']!.compareTo(a['level_value']!),
    );
  } else if (type == '理论50') {
    List lasteversionname = SongDataStore.instance.latestVersion['version'];
    List lasteversion = [];
    for (var i in songsData['versions']) {
      if (lasteversionname.contains(i['title'])) {
        lasteversion.add(i['version']);
      }
    }
    //B30
    b50data['bests'] = [];
    for (var i in songsData['songs']) {
      if (!lasteversion.contains(i['version'])) {
        for (var j in i['difficulties']) {
          b50data['bests'].add({
            "id": i['id'],
            "song_name": "${i['title']}",
            "level": "${j['level']}",
            "level_index": j['difficulty'],
            "score": 1010000,
            "rating": j['level_value'] + 2.15,
            "over_power": 0,
            "clear": "clear",
            "full_combo": 'alljusticecritical',
            "full_chain": null,
            "rank": "s",
            "play_time": "2026-08-02T08:48:00Z",
            "upload_time": "2026-08-02T12:20:57Z",
            "last_played_time": "2026-08-02T08:48:00Z",
          });
        }
      }
    }
    (b50data['bests'] as List).sort(
      (a, b) => b['rating'].compareTo(a['rating']),
    );
    b50data['bests'] = (b50data['bests'] as List).sublist(0, 30);
    //B20
    b50data['new_bests'] = [];
    for (var i in songsData['songs']) {
      if (lasteversion.contains(i['version'])) {
        for (var j in i['difficulties']) {
          b50data['new_bests'].add({
            "id": i['id'],
            "song_name": "${i['title']}",
            "level": "${j['level']}",
            "level_index": j['difficulty'],
            "score": 1010000,
            "rating": j['level_value'] + 2.15,
            "over_power": 0,
            "clear": "clear",
            "full_combo": 'alljusticecritical',
            "full_chain": null,
            "rank": "s",
            "play_time": "2026-08-02T08:48:00Z",
            "upload_time": "2026-08-02T12:20:57Z",
            "last_played_time": "2026-08-02T08:48:00Z",
          });
        }
      }
    }
    (b50data['new_bests'] as List).sort(
      (a, b) => b['rating'].compareTo(a['rating']),
    );
    if (b50data['new_bests'].length > 20) {
      b50data['new_bests'] = (b50data['new_bests'] as List).sublist(0, 20);
    }
    //S10
    b50data['selections'] = [];
    for (var i in songsData['songs']) {
      for (var j in i['difficulties']) {
        b50data['selections'].add({
          "id": i['id'],
          "song_name": "${i['title']}",
          "level": "${j['level']}",
          "level_index": j['difficulty'],
          "score": 1010000,
          "rating": j['level_value'] + 2.15,
          "over_power": 0,
          "clear": "clear",
          "full_combo": 'alljusticecritical',
          "full_chain": null,
          "rank": "s",
          "play_time": "2026-08-02T08:48:00Z",
          "upload_time": "2026-08-02T12:20:57Z",
          "last_played_time": "2026-08-02T08:48:00Z",
        });
      }
    }
    (b50data['selections'] as List).sort(
      (a, b) => b['rating'].compareTo(a['rating']),
    );
    b50data['selections'] = (b50data['selections'] as List).sublist(
      (30 + (b50data['new_bests'] as List).length),
      (30 + (b50data['new_bests'] as List).length + 10),
    );
  }

  //先定义所需的变量
  double totalRating = 0;

  List<Widget> b30body = [];
  Widget b30 = Column(children: b30body);
  List<Widget> b20body = [];
  Widget b20 = Column(children: b20body);
  Widget s10 = SizedBox.shrink();
  double b30Rating = 0;
  // final ScrollController _scrollController = ScrollController();

  //b30绘制
  List<Widget> b30rowbody = [];
  Widget b30row = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: b30rowbody,
  );
  int row = 0;
  int songcount = 1;
  for (var i in b50data['bests']) {
    b30Rating = b30Rating + i['rating'];
    String songname;
    if ((i['song_name'] as String).length > 14) {
      songname = i['song_name'].substring(0, 14) + '...';
    } else {
      songname = i['song_name'];
    }
    double diffvalue = 0;
    for (var j in songsData['songs']) {
      if (i['id'] == j['id']) {
        for (var k in j['difficulties']) {
          if (i['level_index'] == k['difficulty']) {
            diffvalue = k['level_value'].toDouble();
          }
        }
        break;
      }
    }
    if (type != 'b50') {
      i['score'] = 1010000;
      i['rank'] = 'sssp';
      i['clear'] = 'clear';
      i['full_combo'] = 'alljusticecritical';
      i['rating'] = diffvalue + 2.15;
      totalRating = totalRating + i['rating'];
    }

    double fontSize = 14;
    if (i['clear'] == 'catastrophy' && i['full_combo'] == null) {
      fontSize = 6;
    } else if (i['clear'] == 'absolute' && i['full_combo'] == null) {
      fontSize = 8;
    }

    if (!context.mounted) return SizedBox.shrink();
    b30rowbody.add(
      buildB50SongCard(
        songsData: songsData,
        i: i,
        fontSize: fontSize,
        diffvalue: diffvalue,
        songname: songname,
        songcount: songcount,
        context: context,
      ),
    );
    if (row >= 9 && thunderboltb50 != '横着的') {
      b30body.add(b30row);
      row = 0;
      b30rowbody = [];
      b30row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: b30rowbody,
      );
    } else {
      row++;
    }
    if (thunderboltb50 == '竖着的') {
      b30body.add(b30row);
      row = 0;
      b30rowbody = [];
      b30row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: b30rowbody,
      );
    }

    songcount++;
  }
  if (b30rowbody.isNotEmpty) {
    b30body.add(b30row);
  }
  //b30文字
  Widget b30text = buildB50Text(
    "B30",
    (b30Rating / b50data['bests'].length).toStringAsFixed(2),
  );

  //b20绘制
  List<Widget> b20rowbody = [];
  Widget b20row = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: b20rowbody,
  );
  row = 0;
  b30Rating = 0;
  for (var i in b50data['new_bests']) {
    b30Rating = b30Rating + i['rating'];
    double diffvalue = 0;
    String songname;
    if ((i['song_name'] as String).length > 14) {
      songname = i['song_name'].substring(0, 14) + '...';
    } else {
      songname = i['song_name'];
    }

    for (var j in songsData['songs']) {
      if (i['id'] == j['id']) {
        for (var k in j['difficulties']) {
          if (i['level_index'] == k['difficulty']) {
            diffvalue = k['level_value'].toDouble();
          }
        }
        break;
      }
    }
    if (type != 'b50') {
      i['score'] = 1010000;
      i['rank'] = 'sssp';
      i['clear'] = 'clear';
      i['full_combo'] = 'alljusticecritical';
      i['rating'] = diffvalue + 2.15;
      totalRating = totalRating + i['rating'];
    }

    double fontSize = 14;
    if (i['clear'] == 'catastrophy' && i['full_combo'] == null) {
      fontSize = 6;
    } else if (i['clear'] == 'absolute' && i['full_combo'] == null) {
      fontSize = 8;
    }

    if (!context.mounted) return SizedBox.shrink();
    b20rowbody.add(
      buildB50SongCard(
        songsData: songsData,
        i: i,
        fontSize: fontSize,
        diffvalue: diffvalue,
        songname: songname,
        songcount: songcount,
        context: context,
      ),
    );
    if (row == 9 && thunderboltb50 != '横着的') {
      b20body.add(b20row);
      row = 0;
      b20rowbody = [];
      b20row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: b20rowbody,
      );
    } else {
      row++;
    }
    if (thunderboltb50 == '竖着的') {
      b20body.add(b20row);
      row = 0;
      b20rowbody = [];
      b20row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: b20rowbody,
      );
    }
    songcount++;
  }
  if (b20rowbody.isNotEmpty) {
    b20body.add(b20row);
  }

  //b20文字
  Widget b20text = buildB50Text(
    "B20",
    (b30Rating / b50data['new_bests'].length).toStringAsFixed(2),
  );

  Widget s10text = SizedBox.shrink();
  if (generateS10) {
    //s10绘制
    List<Widget> s10body = [];
    List<Widget> s10rowbody = [];
    Widget s10row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: s10rowbody,
    );
    row = 0;
    b30Rating = 0;
    for (var i in b50data['selections']) {
      b30Rating = b30Rating + i['rating'];
      double diffvalue = 0;
      String songname;
      if ((i['song_name'] as String).length > 14) {
        songname = i['song_name'].substring(0, 14) + '...';
      } else {
        songname = i['song_name'];
      }

      for (var j in songsData['songs']) {
        if (i['id'] == j['id']) {
          for (var k in j['difficulties']) {
            if (i['level_index'] == k['difficulty']) {
              diffvalue = k['level_value'].toDouble();
            }
          }
          break;
        }
      }
      if (type != 'b50') {
        i['score'] = 1010000;
        i['rank'] = 'sssp';
        i['clear'] = 'clear';
        i['full_combo'] = 'alljusticecritical';
        i['rating'] = diffvalue + 2.15;
      }

      double fontSize = 14;
      if (i['clear'] == 'catastrophy' && i['full_combo'] == null) {
        fontSize = 6;
      } else if (i['clear'] == 'absolute' && i['full_combo'] == null) {
        fontSize = 8;
      }

      if (!context.mounted) return SizedBox.shrink();
      s10rowbody.add(
        buildB50SongCard(
          songsData: songsData,
          i: i,
          fontSize: fontSize,
          diffvalue: diffvalue,
          songname: songname,
          songcount: songcount,
          context: context,
        ),
      );
      if (row == 9 && thunderboltb50 != '横着的') {
        s10body.add(s10row);
        row = 0;
        s10rowbody = [];
        s10row = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: s10rowbody,
        );
      } else {
        row++;
      }
      if (thunderboltb50 == '竖着的') {
        s10body.add(s10row);
        row = 0;
        s10rowbody = [];
        s10row = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: s10rowbody,
        );
      }
      songcount++;
    }

    if (s10rowbody.isNotEmpty) {
      s10body.add(s10row);
    }
    s10 = Column(children: s10body);

    //s10文字
    s10text = buildB50Text(
      "S10",
      (b30Rating / b50data['selections'].length).toStringAsFixed(2),
    );
  }

  //底部信息
  String theory50 = '';
  if (type != 'b50') {
    theory50 = type;
  }
  Widget fontter = buildB50Fontter(theory50);

  if (type != 'b50') {
    totalRating =
        totalRating / (b50data['new_bests'].length + b50data['bests'].length);

    playerdata['rating'] = double.parse(
      totalRating.toString().length > 5
          ? totalRating.toString().substring(0, 5)
          : totalRating.toString(),
    );
  }

  //玩家信息
  Widget title = buildB50PlayerInfoWidget(playerdata);
  //背景绘制

  double extraHeight = 0;
  double width = 5910 / 2;
  double height = 2900 / 2;
  if (generateS10 && thunderboltb50 != '横着的') {
    extraHeight = 325;
  }

  if (thunderboltb50 == '横着的') {
    width =
        5910 / 2 +
        260 * (b50data['new_bests'] as List).length +
        260 * (b50data['bests'] as List).length +
        (generateS10 ? 260 * (b50data['selections'] as List).length : 0);
    height = 325;
  }
  if (thunderboltb50 == "竖着的") {
    height = 2900 / 2;
    extraHeight =
        extraHeight +
        200 * (b50data['new_bests'] as List).length +
        200 * (b50data['bests'] as List).length;
    if (generateS10) {
      extraHeight = extraHeight + 200 * (b50data['selections'] as List).length;
    }
    width = 5910 / 8 + 75;
  }

  Widget result = Container(
    width: width, //5896 / 2,
    height: height + extraHeight, //2844 / 2 + extraHeight,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('res/background.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(
      child: thunderboltb50 == '横着的'
          ? Column(
              children: [
                Row(
                  children: [title, b30text, b30, b20text, b20, s10text, s10],
                ),
                fontter,
              ],
            )
          : Column(
              children: [
                title,
                b30text,
                b30,
                b20text,
                b20,
                s10text,
                s10,
                fontter,
              ],
            ),
    ),
  );

  return result;
}

Widget buildTypeDropdownMenu({required ValueChanged onSelected}) {
  List<DropdownMenuEntry> dropdownMenuEntries = [
    DropdownMenuEntry(value: 'b50', label: 'B50'),
    DropdownMenuEntry(value: 'random50', label: '随机B50'),
    DropdownMenuEntry(value: 'fc30', label: 'FC50'),
    DropdownMenuEntry(value: 'aj30', label: 'AJ50'),
    DropdownMenuEntry(value: '寸50', label: '寸50'),
    DropdownMenuEntry(value: '寸鸟50', label: '寸鸟50'),
    DropdownMenuEntry(value: '流派50', label: '流派50'),
    DropdownMenuEntry(value: '版本50', label: '版本50'),
    DropdownMenuEntry(value: '谱师50', label: '谱师50'),
    DropdownMenuEntry(value: '曲师50', label: '曲师50'),
    DropdownMenuEntry(value: '个人理论50', label: '个人理论50'),
    DropdownMenuEntry(value: '理论50', label: '理论50'),
    DropdownMenuEntry(value: 'BN', label: 'BN'),
    DropdownMenuEntry(value: '世界末日50', label: '世界末日50'),
    DropdownMenuEntry(value: '版本区间50', label: '版本区间50'),
  ];
  return DropdownMenu(
    selectOnly: true,
    menuHeight: 300,
    width: double.infinity,
    initialSelection: 'b50',
    onSelected: onSelected,
    dropdownMenuEntries: dropdownMenuEntries,
  );
}

class NoteDesignerOrArtist extends StatefulWidget {
  final ValueChanged fun;
  final Set notedesignerorartist;
  const NoteDesignerOrArtist({
    super.key,
    required this.fun,
    required this.notedesignerorartist,
  });

  @override
  State<NoteDesignerOrArtist> createState() => _NoteDesignerOrArtistState();
}

class _NoteDesignerOrArtistState extends State<NoteDesignerOrArtist> {
  List<Widget> children = [];
  final TextEditingController _controller = TextEditingController();

  void search() {
    children = [];
    for (var i in widget.notedesignerorartist) {
      if (i.toString().toLowerCase().contains(_controller.text.toLowerCase())) {
        children.add(ListTile(title: Text('$i'), onTap: () => widget.fun(i)));
      }
    }
    setState(() {
      children = children;
    });
  }

  @override
  void initState() {
    super.initState();
    for (var i in widget.notedesignerorartist) {
      children.add(ListTile(title: Text('$i'), onTap: () => widget.fun(i)));
    }
    setState(() {
      children = children;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (value) => search(),
                  decoration: InputDecoration(hintText: '搜索...'),
                ),
              ),
            ],
          ),
          Expanded(child: ListView(children: children)),
        ],
      ),
    );
  }
}

Widget buildB50SongCard({
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> i,
  required int songcount,
  required String songname,
  required double diffvalue,
  required double fontSize,
  required BuildContext context,
  int? orignid,
}) {
  return InkWell(
    onTap: () async {
      Map<String, dynamic>? songdata;
      for (var j in songsData['songs']) {
        if (i['id'] == j['id']) {
          songdata = j;
          break;
        }
      }
      if (songdata == null) return;
      await interSongInfo(
        songbasedata: songdata,
        context: context,
        songsData: songsData,
      );
    },
    child: SizedBox(
      width: 293,
      height: 219,
      child: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Card(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                color: diffcolor(diffindex: i['level_index']),
                child: Padding(
                  padding: EdgeInsetsGeometry.only(
                    bottom: 5,
                    top: 5,
                    left: 7,
                    right: 5,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(
                            top: 3,
                            left: 3,
                            bottom: 3,
                            right: 3,
                          ),
                          child: Image.network(
                            'https://assets2.lxns.net/chunithm/jacket/${orignid ?? i['id']}.png',
                            width: 115,
                            height: 115,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('图片加载失败');
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 10, bottom: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '#$songcount',
                              // style: TextStyle(fontSize: ),
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 216, 216, 216),
                                fontSize: 13,
                              ),
                            ),

                            Text(
                              i['score'].toString(),
                              style: TextStyle(
                                fontSize: 27,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsetsGeometry.only(bottom: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(25),
                                      ),
                                      gradient: rankColor(rank: i['rank']),
                                    ),
                                    child: SizedBox(
                                      width: 70,
                                      child: Padding(
                                        padding: EdgeInsetsGeometry.only(
                                          left: 5,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsGeometry.only(
                                            left: 0,
                                            right: 3,
                                            top: 0,
                                            bottom: 3,
                                          ),
                                          child: Text(
                                            '${i['rank'].toUpperCase().replaceAll('P', '+')}',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                i['full_combo'] != null
                                    ? Padding(
                                        padding: EdgeInsetsGeometry.only(
                                          left: 5,
                                          bottom: 5,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: fullcombocolor(
                                              fullcombo: i['full_combo'],
                                            ),
                                            border: Border.all(
                                              color: fullcomboBrodercolor(
                                                fullcombo: i['full_combo'],
                                              ),
                                              width: 3,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(8),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsetsGeometry.only(
                                              bottom: 2,
                                              top: 2,
                                              left: 7,
                                              right: 7,
                                            ),
                                            child: Text(
                                              '${fullcomStringCut(fullcombo: i['full_combo'])}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ],
                            ),
                            // Image.asset(
                            //   clearImg(clear: i['clear']),
                            //   height: 18,
                            // ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: clearColor(clear: i['clear']),
                                    border: Border.all(
                                      color: clearBroder(clear: i['clear']),
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsetsGeometry.only(
                                      bottom: 2,
                                      top: 2,
                                      left: 7,
                                      right: 7,
                                    ),
                                    child: Text(
                                      '${i['clear'].toUpperCase()}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: fontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    songname,
                    maxLines: 1,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '$diffvalue -> ${i['rating'].toString().length > 5 ? i['rating'].toString().substring(0, 5) : i['rating'].toString()}',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildB50Text(String text, String avgRating) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Card(
        color: Color.fromARGB(255, 0, 64, 99),
        child: Padding(
          padding: EdgeInsetsGeometry.only(
            top: 5,
            bottom: 5,
            left: 20,
            right: 20,
          ),
          child: Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text: "$text\n",
              style: TextStyle(fontSize: 30, color: Colors.white),

              children: [
                TextSpan(
                  text: "AVG. $avgRating",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget buildB50Fontter(String type) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '此 $type B50由chusearchsong（中二查歌）生成，生成时间：${DateTime.now()}  交流群：309546141',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ],
  );
}

Widget buildB50PlayerInfoWidget(Map<String, dynamic> playerdata) {
  Widget characterimage = SizedBox.shrink();
  if (playerdata['character'] != null) {
    characterimage = Image.network(
      'https://assets2.lxns.net/chunithm/character/${playerdata['character']['id']}.png',
      errorBuilder: (context, error, stackTrace) => Text('错误 $error'),
    );
  }

  double trophywidth = 525;
  if (playerdata['trophy']['name'].length > 17) {
    trophywidth = trophywidth + (playerdata['trophy']['name'].length - 17) * 10;
  }

  return SizedBox(
    height: 170,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 55),
          child: SizedBox(
            width: trophywidth,
            // 525,
            height: 225,
            child: Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        color: trophyColor(
                          trophy: playerdata['trophy']['color'],
                        ),
                        child: Padding(
                          padding: EdgeInsetsGeometry.only(
                            left: 60,
                            right: 60,
                            top: 5,
                            bottom: 5,
                          ),
                          child: Text(
                            playerdata['trophy']['name'],
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.only(left: 15),
                        child: Text(
                          'Lv.${playerdata['level']}  ${playerdata['name']}',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Text(
                        'Rating:   ${playerdata['rating'].toDouble().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 25,
                          color: ratingColor(
                            rating: playerdata['rating'].toDouble(),
                          ),
                          shadows: [Shadow(color: Colors.black, blurRadius: 3)],
                        ),
                      ),
                    ],
                  ),
                  characterimage,
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
