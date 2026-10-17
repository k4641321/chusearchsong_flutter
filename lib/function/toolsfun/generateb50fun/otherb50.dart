import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';

//寸B50
Future<Widget> generateother50Body({
  required BuildContext context,
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> playerdata,
  required List allscoredata,
  required String type,
  required String? genreorversion,
  required String thunderboltb50,
  required List versionlist,
  int? n50,
}) async {
  //筛选曲目
  List resultScoreList = [];
  if (type == '寸50') {
    for (var i in allscoredata) {
      if (i['score'] < 1007500 && i['score'] >= 1007000) {
        resultScoreList.add(i);
      }
    }
  } else if (type == '寸鸟50') {
    for (var i in allscoredata) {
      if (i['score'] < 1009000 && i['score'] >= 1008900) {
        resultScoreList.add(i);
      }
    }
  } else if (type == '流派50') {
    for (var i in allscoredata) {
      for (var j in songsData['songs']) {
        if (i['id'] == j['id'] && j['genre'] == genreorversion) {
          resultScoreList.add(i);
          break;
        }
      }
    }
  } else if (type == '版本50') {
    for (var i in allscoredata) {
      for (var j in songsData['songs']) {
        if (i['id'] == j['id'] && j['version'] == int.parse(genreorversion!)) {
          resultScoreList.add(i);
          break;
        }
      }
    }
  } else if (type == '谱师50') {
    for (var i in allscoredata) {
      for (var j in songsData['songs']) {
        for (var k in j['difficulties']) {
          if (i['id'] == j['id'] && k['note_designer'] == genreorversion) {
            resultScoreList.add(i);
            break;
          }
        }
      }
    }
  } else if (type == '曲师50') {
    for (var i in allscoredata) {
      for (var j in songsData['songs']) {
        if (i['id'] == j['id'] && j['artist'] == genreorversion) {
          resultScoreList.add(i);
          break;
        }
      }
    }
  } else if (type == '世界末日50') {
    for (var i in allscoredata) {
      if (i['level_index'] == 5) {
        resultScoreList.add(i);
      }
    }
    resultScoreList.sort((a, b) => b['score'].compareTo(a['score']));
  } else if (type == '版本区间50') {
    for (var i in allscoredata) {
      for (var j in songsData['songs']) {
        if (i['id'] == j['id'] &&
            versionlist.contains(j['version'].toString())) {
          resultScoreList.add(i);
          break;
        }
      }
    }
  } else {
    resultScoreList = allscoredata;
  }
  if (type != '世界末日50') {
    resultScoreList.sort((a, b) => b['rating'].compareTo(a['rating']));
  }
  if (type == 'BN' && n50 != null) {
    n50 = n50.clamp(0, resultScoreList.length);
    resultScoreList = resultScoreList.sublist(0, n50);
  } else {
    if (resultScoreList.length > 50) {
      resultScoreList = resultScoreList.sublist(0, 50);
    }
  }

  //先定义所需的变量
  List<Widget> b50body = [];
  Widget b50 = Column(children: b50body);
  Widget title = buildB50PlayerInfoWidget(playerdata);
  // final ScrollController _scrollController = ScrollController();
  double b30Rating = 0;

  //b50绘制
  List<Widget> b50rowbody = [];
  Widget b50row = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: b50rowbody,
  );
  int row = 0;
  int songcount = 1;
  for (var i in resultScoreList) {
    b30Rating = b30Rating + i['rating'];
    if (type == '世界末日50') {
      if (i['level_index'] != 5) continue;
    } else {
      if (i['level_index'] == 5) continue;
    }
    String songname;
    if ((i['song_name'] as String).length > 14) {
      songname = i['song_name'].substring(0, 14) + '...';
    } else {
      songname = i['song_name'];
    }
    double diffvalue = 0;
    int originid = i['id'];
    for (var j in songsData['songs']) {
      if (i['id'] == j['id']) {
        for (var k in j['difficulties']) {
          if (i['level_index'] == k['difficulty']) {
            diffvalue = k['level_value'].toDouble();
            if (type == '世界末日50') {
              originid = k['origin_id'];
            }
          }
        }
        break;
      }
    }

    double fontSize = 14;
    if (i['clear'] == 'catastrophy' && i['full_combo'] == null) {
      fontSize = 6;
    } else if (i['clear'] == 'absolute' && i['full_combo'] == null) {
      fontSize = 8;
    }

    b50rowbody.add(
      buildB50SongCard(
        songsData: songsData,
        i: i,
        fontSize: fontSize,
        diffvalue: diffvalue,
        songname: songname,
        songcount: songcount,
        context: context,
        orignid: originid,
      ),
    );
    if (row == 9 && thunderboltb50 != "横着的") {
      b50body.add(b50row);
      row = 0;
      b50rowbody = [];
      b50row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: b50rowbody,
      );
    } else {
      row++;
    }
    if (thunderboltb50 == '竖着的') {
      b50body.add(b50row);
      row = 0;
      b50rowbody = [];
      b50row = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: b50rowbody,
      );
    }
    songcount++;
  }
  if (b50rowbody.isNotEmpty) {
    b50body.add(b50row);
  }

  //b50文字
  //b50文字
  Widget b50text = buildB50Text(
    'B50',
    (b30Rating / resultScoreList.length).toStringAsFixed(2),
  );

  //底部信息
  Widget fontter = buildB50Fontter(
    '$type B${type != 'BN' ? 50 : songcount - 1}',
  );

  //背景绘制
  double extraHeight = 0;
  double width = 5910 / 2;
  double height = 2900 / 2;

  if (b50body.length > 5 && thunderboltb50 != "竖着的") {
    extraHeight = 219 * (b50body.length - 5);
  }
  if (thunderboltb50 == '横着的') {
    width = 5910 / 2 + 285 * resultScoreList.length;
    height = 325;
  }
  if (thunderboltb50 == "竖着的") {
    height = 2900 / 2;
    extraHeight = extraHeight + 219 * resultScoreList.length;
    width = 5910 / 8 + 75;
  }

  Widget result = Container(
    width: width,
    height: height + extraHeight,
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
                Row(children: [title, b50text, b50]),
                fontter,
              ],
            )
          : Column(children: [title, b50text, b50, fontter]),
    ),
  );

  return result;
}
