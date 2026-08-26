import 'dart:io';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:math';

Future<Widget> randomb50Body({
  required BuildContext context,
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> playerdata,
  required List allscoredata,
}) async {
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
    double fontSize = 14;
    if (i['clear'] == 'catastrophy' && i['full_combo'] == null) {
      fontSize = 6;
    } else if (i['clear'] == 'absolute' && i['full_combo'] == null) {
      fontSize = 8;
    }
    b50rowbody.add(
      InkWell(
        onTap: () async {
          Map<String, dynamic>? songdata;
          String? versionname;
          for (var j in songsData['songs']) {
            if (i['id'] == j['id']) {
              songdata = j;
              for (var k in songsData['versions']) {
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
                                'https://assets2.lxns.net/chunithm/jacket/${i['id']}.png',
                                width: 115,
                                height: 115,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text('图片加载失败');
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.only(
                              left: 10,
                              bottom: 5,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '#$songcount',
                                  // style: TextStyle(fontSize: ),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                      255,
                                      216,
                                      216,
                                      216,
                                    ),
                                    fontSize: 10,
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
                                    i['full_combo'] != null
                                        ? Padding(
                                            padding: EdgeInsetsGeometry.only(
                                              left: 5,
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
                                                padding:
                                                    EdgeInsetsGeometry.only(
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
