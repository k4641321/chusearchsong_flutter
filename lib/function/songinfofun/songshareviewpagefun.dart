import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chusearchsong_flutter/function/request.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<Widget> returnSongShareView({required int songid}) async {
  List<Widget> result = [];
  Map<String, dynamic> songdata = await getSongInfo(songid);

  String returndiffenglish({required int diffindex}) {
    switch (diffindex) {
      case 0:
        return 'BASIC';
      case 1:
        return 'ADVANCED';
      case 2:
        return 'EXPERT';
      case 3:
        return 'MASTER';
      case 4:
        return 'ULTIMATE';
      case 5:
        return 'WORLD\'S END';
      default:
        return 'ERROR';
    }
  }

  Color returndiffbgcolor({required int diffindex}) {
    switch (diffindex) {
      case 0:
        return Colors.lightGreen;
      case 1:
        return Colors.yellow;
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

  Future<String> returnVersionName({required int versionvalue}) async {
    String versiontitle = '获取失败';
    final directory = await getApplicationSupportDirectory();
    Map<String, dynamic> songdata = await jsonDecode(
      File('${directory.path}/res/songs.json').readAsStringSync(),
    );
    for (var i in songdata['versions']) {
      if (i['version'] == versionvalue) {
        versiontitle = i['title'];
      }
    }
    return versiontitle;
  }

  String cutNoteDesigner({required String designer}) {
    if (designer.length > 7) {
      return '${designer.substring(0, 7)}...';
    } else {
      return designer;
    }
  }

  String cutartist({required String artist}) {
    if (artist.length > 25) {
      return '${artist.substring(0, 25)}...';
    } else {
      return artist;
    }
  }

  //曲名
  result.add(
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          color: const Color.fromARGB(255, 101, 180, 255),
          child: Padding(
            padding: EdgeInsetsGeometry.only(
              left: 20,
              right: 20,
              top: 10,
              bottom: 10,
            ),
            child: Text(
              songdata['title'],
              style: TextStyle(color: Colors.black, fontSize: 60),
              maxLines: 1,
              textWidthBasis: TextWidthBasis.longestLine,
            ),
          ),
        ),
      ],
    ),
  );

  List<Widget> result2 = [];
  //曲绘加载
  result2.add(
    Padding(
      padding: EdgeInsetsGeometry.all(60),
      child: Image.network(
        'https://assets2.lxns.net/chunithm/jacket/${songdata['id']}.png',
        height: 700,
        width: 700,
        fit: BoxFit.fill,
        errorBuilder: (context, error, stackTrace) {
          try {
            final difficulties = songdata['difficulties'] as List;
            final originId =
                (difficulties.first as Map)['origin_id'] ?? songdata['id'];
            return Image.network(
              'https://assets2.lxns.net/chunithm/jacket/$originId.png',
              height: 700,
              width: 700,
              fit: BoxFit.fill,
            );
          } catch (e, strack) {
            log(' $e\n$strack');
            return Text(
              '错误 $e\n$strack',
              style: TextStyle(color: Colors.black),
            );
          }
        },
      ),
    ),
  );

  List<Widget> result3 = [];
  //曲目信息
  result3.add(
    Text(
      '曲师：${cutartist(artist: songdata['artist'])}',
      style: TextStyle(color: Colors.black, fontSize: 45),
      maxLines: 1,
    ),
  );
  result3.add(
    Text(
      '分类：${songdata['genre']}',
      style: TextStyle(color: Colors.black, fontSize: 45),
    ),
  );
  result3.add(
    Text(
      'BPM：${songdata['bpm']}',
      style: TextStyle(color: Colors.black, fontSize: 45),
    ),
  );
  result3.add(
    Text(
      '版本：${await returnVersionName(versionvalue: songdata['version'])}',
      style: TextStyle(color: Colors.black, fontSize: 45),
    ),
  );
  if (((songdata['difficulties'] as List).last as Map).containsKey('kanji')) {
    result3.add(
      Text(
        '属性：${(songdata['difficulties'] as List).last['kanji']}',
        style: TextStyle(color: Colors.black, fontSize: 45),
      ),
    );
  }
  if (((songdata['difficulties'] as List).last as Map).containsKey('star')) {
    result3.add(
      Text(
        '星数：${(songdata['difficulties'] as List).last['star']}',
        style: TextStyle(color: Colors.black, fontSize: 45),
      ),
    );
  }

  //谱面信息构建
  List<DataColumn> dataColumn = [
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('难度', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('定数', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('谱师', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text(
          'Total',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('Tap', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text(
          'Hold',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text(
          'Slide',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text('Air', style: TextStyle(color: Colors.black, fontSize: 30)),
      ),
    ),
    DataColumn(
      label: Padding(
        padding: EdgeInsetsGeometry.only(
          top: 3,
          bottom: 3,
          left: 15,
          right: 15,
        ),
        child: Text(
          'Flick',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
    ),
  ];

  List<DataRow> dataRow = [];
  for (var i in songdata['difficulties']) {
    dataRow.add(
      DataRow(
        cells: [
          DataCell(
            SizedBox(
              width: double.infinity,
              child: Container(
                color: returndiffbgcolor(diffindex: i['difficulty']),
                alignment: Alignment.center,
                padding: EdgeInsetsGeometry.only(
                  top: 8,
                  bottom: 8,
                  left: 15,
                  right: 15,
                ),
                child: Text(
                  returndiffenglish(diffindex: i['difficulty']),
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['level_value'].toString(),
                textAlign: TextAlign.end,
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                cutNoteDesigner(designer: i['note_designer']),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notes']['total'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notes']['tap'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notes']['hold'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notes']['slide'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notes']['air'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
          DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['notes']['flick'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
  DataTable difftable = DataTable(
    decoration: BoxDecoration(color: Colors.white),
    border: TableBorder.all(color: Colors.black),
    horizontalMargin: 0,
    columnSpacing: 0,
    dataRowMinHeight: 0,
    dataRowMaxHeight: 80,
    columns: dataColumn,
    rows: dataRow,
  );
  // result3.add(const SizedBox(height: 100));
  result3.add(difftable);

  //成绩
  try {
    Map<String, dynamic> songscore = jsonDecode(
      await requestSongBests(token: await returnlxnstoken(), songid: songid),
    );

    List<DataRow> scorerow = [];
    List<DataCell> scorecell = [
      DataCell(
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Text(
            '成绩',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ),
      ),
    ];
    List<DataCell> scorecell2 = [
      DataCell(
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Text(
            '评级',
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ),
      ),
    ];
    List<DataColumn> scorecolumn = [DataColumn(label: Text(''))];

    for (var i in songdata['difficulties']) {
      scorecolumn.add(
        DataColumn(
          label: Container(
            color: returndiffbgcolor(diffindex: i['difficulty']),
            alignment: Alignment.center,
            padding: EdgeInsetsGeometry.only(
              top: 8,
              bottom: 8,
              left: 15,
              right: 15,
            ),
            child: Text(
              returndiffenglish(diffindex: i['difficulty']),
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
        ),
      );
      scorecell.add(
        DataCell(
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Text(
              '无成绩',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ),
        ),
      );
      scorecell2.add(
        DataCell(
          Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Text(
              '无评级',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ),
        ),
      );
    }

    scorerow.add(DataRow(cells: scorecell));
    scorerow.add(DataRow(cells: scorecell2));
    // print(songscore['data']);
    for (var i in songscore['data']) {
      switch (i['level_index']) {
        case 0:
          scorecell[1] = DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['score'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          );
          scorecell2[1] = DataCell(
            Image.asset(rankImg(rank: i['rank']), width: 125),
          );
        case 1:
          scorecell[2] = DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['score'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          );
          scorecell2[2] = DataCell(
            Image.asset(rankImg(rank: i['rank']), width: 125),
          );
        case 2:
          scorecell[3] = DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['score'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          );
          scorecell2[3] = DataCell(
            Image.asset(rankImg(rank: i['rank']), width: 125),
          );
        case 3:
          scorecell[4] = DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['score'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          );
          scorecell2[4] = DataCell(
            Image.asset(rankImg(rank: i['rank']), width: 125),
          );
        case 4:
          scorecell[5] = DataCell(
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Text(
                i['score'].toString(),
                style: TextStyle(color: Colors.black, fontSize: 30),
              ),
            ),
          );
          scorecell2[5] = DataCell(
            Image.asset(rankImg(rank: i['rank']), width: 125),
          );
      }
    }

    DataTable scoretable = DataTable(
      decoration: BoxDecoration(color: Colors.white),
      border: TableBorder.all(color: Colors.black),
      horizontalMargin: 0,
      columnSpacing: 0,
      dataRowMinHeight: 0,
      dataRowMaxHeight: 80,
      columns: scorecolumn,
      rows: scorerow,
    );
    result3.add(
      Padding(padding: EdgeInsetsGeometry.only(top: 10), child: scoretable),
    );
  } catch (e) {
    log('无成绩');
  }

  result2.add(
    Column(mainAxisAlignment: MainAxisAlignment.start, children: result3),
  );
  result.add(
    Row(mainAxisAlignment: MainAxisAlignment.start, children: result2),
  );

  result.add(
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            '   #${songdata['id']}     此歌曲信息成绩由chusearchsong生成，生成时间 ${DateTime.now().toString()}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    ),
  );
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    // crossAxisAlignment: CrossAxisAlignment.center,
    children: result,
  );
}
