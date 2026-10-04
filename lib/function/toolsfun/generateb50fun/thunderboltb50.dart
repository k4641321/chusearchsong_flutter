import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';

//雷霆50
Future<Widget> thunderboltb50Body({
  required BuildContext context,
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> playerdata,
  required Map<String, dynamic> b50data,
  required String type,
}) async {
  //先定义所需的变量
  double totalRating = 0;
  Widget characterimage = SizedBox.shrink();
  if (playerdata['character'] != null) {
    characterimage = Image.network(
      'https://assets2.lxns.net/chunithm/character/${playerdata['character']['id']}.png',
      errorBuilder: (context, error, stackTrace) => Text('错误 $error'),
    );
  }
  List<Widget> b30body = [];
  Widget b30 = Column(children: b30body);
  List<Widget> b20body = [];
  Widget b20 = Column(children: b20body);
  Widget s10 = SizedBox.shrink();
  double trophywidth = 525;
  if (playerdata['trophy']['name'].length > 17) {
    trophywidth = trophywidth + (playerdata['trophy']['name'].length - 17) * 10;
  }

  // final ScrollController _scrollController = ScrollController();
  //b30文字
  Widget b30text = buildB50Text("B30");

  //b30绘制
  List<Widget> b30rowbody = [];
  Widget b30row = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: b30rowbody,
  );
  int row = 0;
  int songcount = 1;
  for (var i in b50data['bests']) {
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
    if (type == '竖着的50') {
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
  if (type == '横着的50') {
    b30body.add(b30row);
    row = 0;
    b30rowbody = [];
    b30row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: b30rowbody,
    );
  }

  //b20文字
  Widget b20text = buildB50Text("B20");

  //b20绘制
  List<Widget> b20rowbody = [];
  Widget b20row = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: b20rowbody,
  );
  row = 0;
  for (var i in b50data['new_bests']) {
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
    if (type == '竖着的50') {
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
  if (type == '横着的50') {
    b20body.add(b20row);
    row = 0;
    b20rowbody = [];
    b20row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: b20rowbody,
    );
  }

  //s10文字
  Widget s10text = SizedBox.shrink();
  if (type == '带S10的50' || type == '带S10的理论50') {
    s10text = buildB50Text("S10");
    //s10绘制
    List<Widget> s10body = [];
    List<Widget> s10rowbody = [];
    Widget s10row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: s10rowbody,
    );
    row = 0;
    for (var i in b50data['selections']) {
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
      if (row == 9) {
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
      songcount++;
    }
    if (s10rowbody.isNotEmpty) {
      s10body.add(s10row);
    }
    s10 = Column(children: s10body);
  }

  //底部信息
  String theory50 = '';
  if (type != 'b50') {
    theory50 = type;
  }
  Widget fontter = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        '此 $theory50 B50由chusearchsong（中二查歌）生成，生成时间：${DateTime.now()}',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ],
  );
  if (type != 'b50' && type != '带S10的50') {
    totalRating = totalRating / songcount;
    playerdata['rating'] = double.parse(
      totalRating.toString().length > 5
          ? totalRating.toString().substring(0, 5)
          : totalRating.toString(),
    );
  }

  //玩家信息
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
  //背景绘制

  double extraHeight = 0;
  if (type == "带S10的50" || type == '带S10的理论50') {
    extraHeight = 300;
  }

  double width = 5896 / 2;
  if (type == '横着的50') {
    width = 5896 / 2 + 292 * 40;
  } else {
    width = 5896 / 8;
  }
  double height = 2844 / 2;
  if (type == "竖着的50") {
    height = 2844 / 2;
    extraHeight = 219 * 50;
  } else {
    height = 500;
  }

  Widget resultWidget = Column(
    children: [title, b30text, b30, b20text, b20, s10text, s10, fontter],
  );
  if (type == '横着的50') {
    resultWidget = Column(
      children: [
        title,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [b30text, b30, b20text, b20, s10text, s10],
        ),
        fontter,
      ],
    );
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
    child: Center(child: resultWidget),
  );

  return result;
}
