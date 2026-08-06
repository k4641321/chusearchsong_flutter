import 'dart:io';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../request.dart';
import 'dart:convert';
import 'dart:math';

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

Future<Widget> randomb50Body({required BuildContext context}) async {
  final path = await getApplicationSupportDirectory();
  String songdatastr = await File('${path.path}/res/songs.json').readAsString();
  Map<String, dynamic> songsdata = jsonDecode(songdatastr);
  //请求全曲成绩数据
  String allsocresdatastr = await requestScore(token: await returnlxnstoken());
  List allscoredata = (jsonDecode(allsocresdatastr) as Map)['data'];
  //开抽
  List randomb50;
  final random = List.from(allscoredata);
  random.shuffle(Random());
  randomb50 = [];
  for (var i = 0; i < 50; i++) {
    var score = random.removeAt(0); // 取出并移除第一个元素
    if (score['level_index'] != 5) {
      randomb50.add(score);
    } else {
      i--;
    }
  }
  // print(randomb50);
  //请求玩家信息
  String playerdatastr = await requestPlayerInfo();
  Map<String, dynamic> playerdata = (jsonDecode(playerdatastr) as Map)['data'];
  double trophywidth = 525;
  if (playerdata['trophy']['name'].length > 17) {
    trophywidth = trophywidth + (playerdata['trophy']['name'].length - 17) * 10;
  }
  //先定义所需的变量
  List<Widget> b50body = [];
  Widget characterimage = SizedBox.shrink();
  if (playerdata['character'] != null) {
    characterimage = Image.network(
      'https://assets2.lxns.net/chunithm/character/${playerdata['character']['id']}.png',
      errorBuilder: (context, error, stackTrace) => Text('错误 $error'),
    );
  }
  Widget b50 = Column(children: b50body);
  Widget title = SizedBox(
    height: 170,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 55),
          child: SizedBox(
            width: trophywidth,
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
  Widget b30text = Row(
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
            'B50',
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
        '此随机B50由chusearchsong（中二查歌）生成，生成时间：${DateTime.now()}',
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
  for (var i in randomb50) {
    String songname;
    if ((i['song_name'] as String).length > 18) {
      songname = i['song_name'].substring(0, 18) + '...';
    } else {
      songname = i['song_name'];
    }

    b50rowbody.add(
      InkWell(
        onTap: () async {
          Map<String, dynamic>? songdata;
          String? versionname;
          for (var j in songsdata['songs']) {
            if (i['id'] == j['id']) {
              songdata = j;
              for (var k in songsdata['versions']) {
                if (j['version'] == k['version']) {
                  versionname = k['title'];
                  break;
                }
              }
              break;
            }
          }
          if (!context.mounted) return;
          if (songdata == null || versionname == null) return;
          await interSongInfo(
            songbasedata: songdata,
            context: context,
            versionname: versionname,
          );
        },
        child: SizedBox(
          width: 292,
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: EdgeInsetsGeometry.only(
                            top: 6,
                            // left: 6,
                            bottom: 6,
                            // right: 6,
                          ),
                          child: Image.network(
                            'https://assets2.lxns.net/chunithm/jacket/${i['id']}.png',
                            width: 135,
                            height: 135,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('图片加载失败');
                            },
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${i['level'].toString()}                  #$songcount',
                              // style: TextStyle(fontSize: ),
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white),
                            ),

                            Text(
                              i['score'].toString(),
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Rating: ${i['rating'].toString().length > 5 ? i['rating'].toString().substring(0, 5) : i['rating'].toString()}',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            Image.asset(rankImg(rank: i['rank']), height: 30),
                            Image.asset(
                              clearImg(clear: i['clear']),
                              height: 18,
                            ),
                            fullcomboImg(fullcombo: i['full_combo'] ?? '') !=
                                    null
                                ? Image.asset(
                                    fullcomboImg(fullcombo: i['full_combo'])!,
                                    height: 18,
                                  )
                                : SizedBox.shrink(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        songname,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
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
  //背景绘制
  Widget result = Container(
    width: 5896 / 2,
    height: 2844 / 2,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('res/background.png'),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(child: Column(children: [title, b30text, b50, fontter])),
  );

  return result;
}
