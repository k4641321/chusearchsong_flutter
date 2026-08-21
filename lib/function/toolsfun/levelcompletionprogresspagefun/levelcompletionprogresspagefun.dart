import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/toolsfun/viewallgradespagefun.dart';
import 'package:flutter/material.dart';
import 'dart:developer';
import '../../fun.dart';
import '../generateb50fun/generateb50.dart';

Widget buildLevelDropdownMenu({required ValueChanged<dynamic>? onSelected}) {
  const List<DropdownMenuEntry> dropdownMenuEntries = [
    DropdownMenuEntry(value: [0, 0.9], label: '0'),
    DropdownMenuEntry(value: [1, 1.9], label: '1'),
    DropdownMenuEntry(value: [2, 2.9], label: '2'),
    DropdownMenuEntry(value: [3, 3.9], label: '3'),
    DropdownMenuEntry(value: [4, 4.9], label: '4'),
    DropdownMenuEntry(value: [5, 5.9], label: '5'),
    DropdownMenuEntry(value: [6, 6.9], label: '6'),
    DropdownMenuEntry(value: [7, 7.4], label: '7'),
    DropdownMenuEntry(value: [7.5, 7.9], label: '7+'),
    DropdownMenuEntry(value: [8, 8.4], label: '8'),
    DropdownMenuEntry(value: [8.5, 8.9], label: '8+'),
    DropdownMenuEntry(value: [9, 9.4], label: '9'),
    DropdownMenuEntry(value: [9.5, 9.9], label: '9+'),
    DropdownMenuEntry(value: [10, 10.4], label: '10'),
    DropdownMenuEntry(value: [10.5, 10.9], label: '10+'),
    DropdownMenuEntry(value: [11, 11.4], label: '11'),
    DropdownMenuEntry(value: [11.5, 11.9], label: '11+'),
    DropdownMenuEntry(value: [12, 12.4], label: '12'),
    DropdownMenuEntry(value: [12.5, 12.9], label: '12+'),
    DropdownMenuEntry(value: [13, 13.4], label: '13'),
    DropdownMenuEntry(value: [13.5, 13.9], label: '13+'),
    DropdownMenuEntry(value: [14, 14.4], label: '14'),
    DropdownMenuEntry(value: [14.5, 14.9], label: '14+'),
    DropdownMenuEntry(value: [15, 15.4], label: '15'),
    DropdownMenuEntry(value: [15.5, 15.9], label: '15+'),
    DropdownMenuEntry(value: [16, 16.4], label: '16'),
    DropdownMenuEntry(value: [16.5, 16.9], label: '16+'),
  ];
  return DropdownMenu(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: const [1, 1.9],
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: dropdownMenuEntries,
  );
}

Widget buildsongList({
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> allScoreData,
  required List level,
  required BuildContext context,
  required ScrollController scrollController,
}) {
  String playhistory({
    required int score,
    required double rating,
    required String rank,
  }) {
    if (score == 0 || rating == 0.0 || rank == '') {
      return '';
    } else {
      return '\n成绩：$score | Rating：$rating | 评级：${rank.replaceFirst('p', '+')}';
    }
  }

  List songresultMap = [];
  //先筛选难度
  for (var i in songsData['songs']) {
    for (var j in i['difficulties']) {
      if (j['level_value'] >= level[0] && j['level_value'] <= level[1]) {
        songresultMap.add(i);
      }
    }
  }
  // print(songresultMap);

  //生成组件
  List<Widget> songresultWidget = [];
  log('添加组件');
  // print(songresult);
  //表格所需变量
  int levelallcount = songresultMap.length;
  int ssspcount = 0;
  int ssscount = 0;
  int sspcount = 0;
  int sscount = 0;
  int spcount = 0;
  int scount = 0;
  int aaacount = 0;
  int othercount = 0;
  int completecount = 0;
  for (var i in songresultMap) {
    List<Widget> songInfoDiffs = [];
    String versionname = '';
    int score = 0;
    double rating = 0;
    String rank = '';
    int songid = i['id'];
    for (var j in songsData['versions']) {
      if (j['version'] == i['version']) {
        versionname = j['title'];
      }
    }
    for (var k in i['difficulties']) {
      if (k['level_value'] >= level[0] && k['level_value'] <= level[1]) {
        songInfoDiffs.add(
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.all(Radius.circular(5)),
            ),
            color: diffcolor(diffindex: k['difficulty']),
            child: Padding(
              padding: EdgeInsetsGeometry.only(
                left: 8,
                right: 8,
                top: 3,
                bottom: 3,
              ),
              child: Text(
                '${returnDiffName(k['difficulty'])} - ${k['level_value']}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
        for (var l in allScoreData['data']) {
          if (k['difficulty'] == l['level_index'] && i['id'] == l['id']) {
            score = l['score'];
            rating = l['rating'].toDouble();
            rank = l['rank'];
            completecount++;
            if (rank == 'sssp') {
              ssspcount++;
            } else if (rank == 'sss') {
              ssscount++;
            } else if (rank == 'ssp') {
              sspcount++;
            } else if (rank == 'ss') {
              sscount++;
            } else if (rank == 'sp') {
              spcount++;
            } else if (rank == 's') {
              scount++;
            } else if (rank == 'aaa') {
              aaacount++;
            } else {
              othercount++;
            }
          }
        }
      }
      if ((k as Map<String, dynamic>).containsKey('origin_id')) {
        songid = k['origin_id'];
      }
    }

    songresultWidget.add(
      InkWell(
        // key: ValueKey(songItem['id']),
        onTap: () async {
          interSongInfo(
            songbasedata: i,
            context: context,
            versionname: versionname,
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          child: Padding(
            padding: EdgeInsetsGeometry.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(right: 0),
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://assets2.lxns.net/chunithm/jacket/$songid.png',
                        width: 95,
                        height: 95,
                        errorWidget: (context, url, error) => Text('加载失败'),
                      ),
                    ),
                    Wrap(children: songInfoDiffs),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.only(left: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '#${i['id']}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${i['title']}',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${i['artist']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${i['genre']} - $versionname',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        score == 0
                            ? SizedBox.shrink()
                            : Text(
                                '成绩：$score | Rating：$rating | 评级：${rank.replaceAll('p', '+')}',
                                style: TextStyle(color: returnColor(score)),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final ScrollController scrollController2 = ScrollController();

  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: Scrollbar(
              controller: scrollController2,
              child: SingleChildScrollView(
                controller: scrollController2,
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('总数')),
                    DataColumn(label: Text('SSS+')),
                    DataColumn(label: Text('SSS')),
                    DataColumn(label: Text('SS+')),
                    DataColumn(label: Text('SS')),
                    DataColumn(label: Text('S+')),
                    DataColumn(label: Text('S')),
                    DataColumn(label: Text('AAA')),
                    DataColumn(label: Text('其他')),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('$completecount/$levelallcount')),
                        DataCell(Text('$ssspcount')),
                        DataCell(Text('$ssscount')),
                        DataCell(Text('$sspcount')),
                        DataCell(Text('$sscount')),
                        DataCell(Text('$spcount')),
                        DataCell(Text('$scount')),
                        DataCell(Text('$aaacount')),
                        DataCell(Text('$othercount')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      Expanded(
        child: ListView.builder(
          controller: scrollController,
          itemBuilder: (context, index) => songresultWidget[index],
          itemCount: songresultWidget.length,
        ),
      ),
    ],
  );
}
