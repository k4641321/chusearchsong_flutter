import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';

Future<Widget> fc50Body({
  required BuildContext context,
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> playerdata,
  required List allscoredata,
  required String thunderboltb50,
}) async {
  //查找所有AJ成绩
  List fcb50 = [];
  for (var i in allscoredata) {
    if (i['full_combo'] == 'fullcombo') {
      fcb50.add(i);
    }
  }
  fcb50.sort((a, b) => b['rating'].compareTo(a['rating']));
  // print(fcb50);
  // print(randomb50);
  double trophywidth = 525;
  if (playerdata['trophy']['name'].length > 17) {
    trophywidth = trophywidth + (playerdata['trophy']['name'].length - 17) * 10;
  }
  //先定义所需的变量
  List<Widget> b50body = [];
  Widget b50 = Column(children: b50body);
  Widget title = buildB50PlayerInfoWidget(playerdata);
  // final ScrollController _scrollController = ScrollController();

  //底部信息
  Widget fontter = buildB50Fontter('FC50');
  double b30Rating = 0;
  //b50绘制
  int total = 0;
  List<Widget> b50rowbody = [];
  Widget b50row = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: b50rowbody,
  );
  int row = 0;
  int songcount = 1;
  for (var i in fcb50) {
    b30Rating += i['rating'];
    if (total > 50) break;
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
    b50rowbody.add(
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
    total++;
  }
  if (b50rowbody.isNotEmpty) {
    b50body.add(b50row);
  }

  //b50文字
  Widget b30text = buildB50Text(
    'B50',
    (b30Rating / fcb50.length).toStringAsFixed(2),
  );

  //背景绘制
  double extraHeight = 0;
  double width = 5910 / 2;
  double height = 2900 / 2;

  if (thunderboltb50 == '横着的') {
    width = 5910 / 2 + 260 * fcb50.length;
    height = 325;
  }
  if (thunderboltb50 == "竖着的") {
    height = 2900 / 2;
    extraHeight = extraHeight + 200 * fcb50.length;
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
                Row(children: [title, b30text, b50]),
                fontter,
              ],
            )
          : Column(children: [title, b30text, b50, fontter]),
    ),
  );

  return result;
}
