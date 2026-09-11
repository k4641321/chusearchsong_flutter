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
  int? n50,
}) async {
  //筛选曲目
  List resultScoreList = [];
  if (type == '寸50') {
    for (var i in allscoredata) {
      if (i['score'] < 1007499 && i['score'] >= 1007000) {
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
  } else {
    resultScoreList = allscoredata;
  }
  if (type != '世界末日50') {
    resultScoreList.sort((a, b) => b['rating'].compareTo(a['rating']));
  }
  if (type == 'N50' && n50 != null) {
    n50 = n50.clamp(0, resultScoreList.length);
    resultScoreList = resultScoreList.sublist(0, n50);
  } else {
    if (resultScoreList.length > 50) {
      resultScoreList = resultScoreList.sublist(0, 50);
    }
  }

  //先定义所需的变量
  Widget characterimage = SizedBox.shrink();
  if (playerdata['character'] != null) {
    characterimage = Image.network(
      'https://assets2.lxns.net/chunithm/character/${playerdata['character']['id']}.png',
      errorBuilder: (context, error, stackTrace) => Text('错误 $error'),
    );
  }
  List<Widget> b50body = [];
  Widget b50 = Column(children: b50body);
  double trophywidth = 525;
  if (playerdata['trophy']['name'].length > 17) {
    trophywidth = trophywidth + (playerdata['trophy']['name'].length - 17) * 10;
  }
  Widget title = SizedBox(
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
                        'Rating:   ${playerdata['rating']}',
                        style: TextStyle(
                          fontSize: 25,
                          color: ratingColor(rating: playerdata['rating']),
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
  // final ScrollController _scrollController = ScrollController();
  //b50文字
  Widget b50text = Row(
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
          child: Text(
            'B${type != 'N50' ? 50 : n50}',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    ],
  );

  //底部信息
  Widget fontter = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '此 $type B${type != 'N50' ? 50 : n50}由chusearchsong（中二查歌）生成，生成时间：${DateTime.now()}',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ],
  );
  //b50绘制
  List<Widget> b50rowbody = [];
  Widget b50row = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: b50rowbody,
  );
  int row = 0;
  int songcount = 1;
  for (var i in resultScoreList) {
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
    if (row == 9) {
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
    songcount++;
  }
  if (b50rowbody.isNotEmpty) {
    b50body.add(b50row);
  }

  double extraHeight = 0.0;

  if (b50body.length > 5) {
    extraHeight = 219 * (b50body.length - 5);
  }

  //背景绘制
  Widget result = Container(
    width: 5896 / 2,
    height: 2844 / 2 + extraHeight,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('res/background.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(child: Column(children: [title, b50text, b50, fontter])),
  );

  return result;
}
