import 'dart:convert';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:flutter/material.dart';

String returnlevelString({required List level}) {
  if (level[0] is int) {
    return '${level[0]}';
  } else {
    return '${(level[0] as double).toInt()}+';
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
    default:
      return Colors.black;
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

String cuttitle({required String title}) {
  if (title.length > 8) {
    return '${title.substring(0, 8)}...';
  } else {
    return title;
  }
}

Future<Widget> returnShareLevelCompletionProgressPageFun({
  required List level,
  required Map<String, dynamic> songsdata,
  required Map<String, dynamic> allScoreData,
  required BuildContext context,
}) async {
  double defaultheight = 1422;
  //请求玩家信息
  String playerdatastr = await requestPlayerInfo();
  Map<String, dynamic> playerdata = (jsonDecode(playerdatastr) as Map)['data'];

  List<Widget> resultchildren = [];

  //表格所需变量
  int levelallcount = 0;
  int ssspcount = 0;
  int ssscount = 0;
  int sspcount = 0;
  int sscount = 0;
  int spcount = 0;
  int scount = 0;
  int aaacount = 0;
  int othercount = 0;
  int completecount = 0;
  List resultMap = [];
  for (var i in songsdata['songs']) {
    for (var j in i['difficulties']) {
      if (j['level_value'] >= level[0] && j['level_value'] <= level[1]) {
        resultMap.add(i);
      }
    }
  }
  levelallcount = resultMap.length;

  List<Widget> picturelist = [];
  int rowcount = 0;
  int columncount = 0;
  for (var i in resultMap) {
    String versionname = '';
    String rank = '';
    Widget rankwidget = SizedBox.shrink();
    late double diff;
    for (var j in songsdata['versions']) {
      if (j['version'] == i['version']) {
        versionname = j['title'];
      }
    }
    for (var l in i['difficulties']) {
      if (l['level_value'] >= level[0] && l['level_value'] <= level[1]) {
        diff = l['level_value'].toDouble();
      }
    }
    for (var l in allScoreData['data']) {
      if (l['level'] == returnlevelString(level: level) && i['id'] == l['id']) {
        rank = l['rank'];
        completecount++;
        if (rank == 'sssp') {
          ssspcount++;
          rankwidget = Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: const Color.fromARGB(115, 158, 158, 158),
            child: Image.asset(width: 100, height: 100, rankImg(rank: rank)),
          );
        } else if (rank == 'sss') {
          ssscount++;
          rankwidget = Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: const Color.fromARGB(115, 158, 158, 158),
            child: Image.asset(width: 100, height: 100, rankImg(rank: rank)),
          );
        } else if (rank == 'ssp') {
          sspcount++;
          rankwidget = Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: const Color.fromARGB(115, 158, 158, 158),
            child: Image.asset(width: 100, height: 100, rankImg(rank: rank)),
          );
        } else if (rank == 'ss') {
          sscount++;
          rankwidget = Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: const Color.fromARGB(115, 158, 158, 158),
            child: Image.asset(width: 100, height: 100, rankImg(rank: rank)),
          );
        } else if (rank == 'sp') {
          spcount++;
          rankwidget = Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: const Color.fromARGB(115, 158, 158, 158),
            child: Image.asset(width: 100, height: 100, rankImg(rank: rank)),
          );
        } else if (rank == 's') {
          scount++;
          rankwidget = Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: const Color.fromARGB(115, 158, 158, 158),
            child: Image.asset(width: 100, height: 100, rankImg(rank: rank)),
          );
        } else if (rank == 'aaa') {
          aaacount++;
          rankwidget = Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: const Color.fromARGB(115, 158, 158, 158),
            child: Image.asset(width: 100, height: 100, rankImg(rank: rank)),
          );
        } else {
          othercount++;
          rankwidget = Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: const Color.fromARGB(115, 158, 158, 158),
            child: Image.asset(width: 100, height: 100, rankImg(rank: rank)),
          );
        }
      }
    }
    picturelist.add(
      InkWell(
        onTap: () async {
          interSongInfo(
            songbasedata: i,
            context: context,
            versionname: versionname,
          );
        },

        child: Card(
          // color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsetsGeometry.all(4),
                child: Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Image.network(
                      'https://assets2.lxns.net/chunithm/jacket/${i['id']}.png',
                      width: 100,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => Image.network(
                        width: 100,
                        height: 100,
                        'https://assets2.lxns.net/chunithm/jacket/${((i['difficulties'] as List).last as Map)['origin_id']}.png',
                        errorBuilder: (context, error, stackTrace) =>
                            Text('错误：${error.toString()}'),
                      ),
                    ),
                    rankwidget,
                  ],
                ),
              ),
              Text(
                cuttitle(title: i['title']),
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
              Text('$diff', style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
      ),
    );
    rowcount++;
    if (rowcount == 25) {
      resultchildren.add(
        Row(mainAxisAlignment: MainAxisAlignment.center, children: picturelist),
      );
      picturelist = [];
      rowcount = 0;
      columncount++;
    }
  }
  if (columncount == 0) {
    resultchildren.add(
      Row(mainAxisAlignment: MainAxisAlignment.center, children: picturelist),
    );
  }

  //头部信息
  resultchildren.insert(
    0,
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 170,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(right: 55),
                child: SizedBox(
                  width: 525,
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
                                  '${playerdata['trophy']['name']}',
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
                                color: ratingColor(
                                  rating: playerdata['rating'],
                                ),
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 3),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Image.network(
                          'https://assets2.lxns.net/chunithm/character/${playerdata['character']['id']}.png',
                          width: 175,
                          height: 175,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Card(
          color: const Color.fromARGB(194, 255, 255, 255),
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              top: 8,
              bottom: 8,
              left: 50,
              right: 50,
            ),
            child: Text(
              '${returnlevelString(level: level)}等级表',
              style: TextStyle(fontSize: 45, color: Colors.black),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsGeometry.only(left: 60),
          child: DataTable(
            decoration: BoxDecoration(color: Colors.white),
            border: TableBorder.all(color: Colors.black),
            columns: [
              DataColumn(
                label: Text(
                  '总数',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  'SSS+',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  'SSS',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  'SS+',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  'SS',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  'S+',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  'S',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  'AAA',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              DataColumn(
                label: Text(
                  '其他',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(
                    Text(
                      '$completecount/$levelallcount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$ssspcount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$ssscount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$sspcount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$sscount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$spcount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$scount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$aaacount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                  DataCell(
                    Text(
                      '$othercount',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );

  //底部信息
  resultchildren.add(
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '此等级表由chusearchsong（中二查歌）生成，生成时间：${DateTime.now()}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ],
    ),
  );

  //我操了，怎么那么多歌，1422高度都装不下
  if (columncount > 8) {
    defaultheight = defaultheight + 200 * (columncount - 8);
  }
  Widget result = Container(
    width: 2948,
    height: defaultheight,
    decoration: BoxDecoration(
      image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage('res/background.png'),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: resultchildren,
    ),
  );

  return result;
}
