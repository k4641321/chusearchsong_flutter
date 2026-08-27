import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';

Widget buildDropDownMenu(ValueChanged onSelected) {
  List<DropdownMenuEntry> dropdownMenuEntries = [
    DropdownMenuEntry(value: 'MAS定数', label: 'MAS定数'),
    DropdownMenuEntry(value: 'EXP定数', label: 'EXP定数'),
    DropdownMenuEntry(value: 'ADV定数', label: 'ADV定数'),
    DropdownMenuEntry(value: 'BAS定数', label: 'BAS定数'),
    DropdownMenuEntry(value: 'ULT定数', label: 'ULT定数'),
    DropdownMenuEntry(value: 'World\'s End星数', label: 'World\'s End星数'),
    DropdownMenuEntry(value: 'BPM', label: 'BPM'),
    DropdownMenuEntry(value: '音符总数', label: '音符总数'),
    DropdownMenuEntry(value: 'Tap数量', label: 'Tap数量'),
    DropdownMenuEntry(value: 'Hold数量', label: 'Hold数量'),
    DropdownMenuEntry(value: 'Slide数量', label: 'Slide数量'),
    DropdownMenuEntry(value: 'Air数量', label: 'Air数量'),
    DropdownMenuEntry(value: 'Flick数量', label: 'Flick数量'),
  ];

  return DropdownMenu(
    initialSelection: dropdownMenuEntries[0].value,
    width: double.maxFinite,
    selectOnly: true,
    menuHeight: 300,
    onSelected: onSelected,
    dropdownMenuEntries: dropdownMenuEntries,
  );
}

List<Widget> sortSongs({
  required BuildContext context,
  required Map<String, dynamic> songs,
  required List zxzrSongs,
  required String type,
  required bool reverse,
  required int diffindex,
}) {
  List<Widget> widgets = [];
  List notecountlist = [];
  if (type == 'BPM') {
    if (reverse) {
      (songs['songs'] as List).sort((a, b) => b['bpm'].compareTo(a['bpm']));
    } else {
      (songs['songs'] as List).sort((a, b) => a['bpm'].compareTo(b['bpm']));
    }
  } else if (type.contains('定数') || type.contains('星数')) {
    List result = [];
    int difflength = 3;
    int diffindex = 3;

    switch (type) {
      case 'World\'s End星数':
        difflength = 1;
        diffindex = 0;
        break;
      case 'ULT定数':
        difflength = 5;
        diffindex = 4;
        break;
      case 'MAS定数':
        diffindex = 3;
        break;
      case 'EXP定数':
        diffindex = 2;
        break;
      case 'ADV定数':
        diffindex = 1;
        break;
      case 'BAS定数':
        diffindex = 0;
        break;
    }
    for (var i in songs['songs']) {
      if (i['difficulties'].length >= difflength && type != 'World\'s End星数') {
        result.add(i);
      } else if (type == 'World\'s End星数') {
        if (i['difficulties'].length == 1) {
          result.add(i);
        }
      } else {
        continue;
      }
    }
    if (reverse) {
      if (type != 'World\'s End星数') {
        result.sort(
          ((a, b) =>
              (b['difficulties'] as List)[diffindex]['level_value'].compareTo(
                (a['difficulties'] as List)[diffindex]['level_value'],
              )),
        );
      } else {
        result.sort(
          ((a, b) => (b['difficulties'] as List)[diffindex]['star'].compareTo(
            (a['difficulties'] as List)[diffindex]['star'],
          )),
        );
      }
    } else {
      if (type != 'World\'s End星数') {
        result.sort(
          ((a, b) =>
              (a['difficulties'] as List)[diffindex]['level_value'].compareTo(
                (b['difficulties'] as List)[diffindex]['level_value'],
              )),
        );
      } else {
        result.sort(
          ((a, b) => (a['difficulties'] as List)[diffindex]['star'].compareTo(
            (b['difficulties'] as List)[diffindex]['star'],
          )),
        );
      }
    }
    songs['songs'] = result;
  } else if (type.contains('数量') || type.contains('总数')) {
    List result = [];
    String noteKey;
    if (type.contains('音符总数')) {
      noteKey = 'total';
    } else if (type.contains('Tap')) {
      noteKey = 'tap';
    } else if (type.contains('Hold')) {
      noteKey = 'hold';
    } else if (type.contains('Slide')) {
      noteKey = 'slide';
    } else if (type.contains('Air')) {
      noteKey = 'air';
    } else if (type.contains('Flick')) {
      noteKey = 'flick';
    } else {
      noteKey = 'total';
    }

    zxzrSongs.sort((a, b) {
      int chartlength = 4;
      if (diffindex == 4) {
        chartlength = 5;
      } else if (diffindex == 5) {
        chartlength = 1;
      }
      bool aHasChart = (a['charts'] as List).length >= chartlength;
      bool bHasChart = (b['charts'] as List).length >= chartlength;

      if (!aHasChart && !bHasChart) return 0;
      if (!aHasChart) return 1;
      if (!bHasChart) return -1;

      int aValue = 0;
      if ([0, 1, 2, 3].contains(diffindex)) {
        aValue = (a['charts'] as List)[diffindex]['notecounts'][noteKey] ?? 0;
      } else if (diffindex == 4 && (a['charts'] as List).length == 5) {
        aValue = (a['charts'] as List)[diffindex]['notecounts'][noteKey] ?? 0;
      } else if (diffindex == 5 && (a['charts'] as List).length == 1) {
        aValue = (a['charts'] as List).last['notecounts'][noteKey] ?? 0;
      }

      int bValue = 0;
      if ([0, 1, 2, 3].contains(diffindex)) {
        bValue = (b['charts'] as List)[diffindex]['notecounts'][noteKey] ?? 0;
      } else if (diffindex == 4 && (b['charts'] as List).length == 5) {
        bValue = (b['charts'] as List)[diffindex]['notecounts'][noteKey] ?? 0;
      } else if (diffindex == 5 && (b['charts'] as List).length == 1) {
        bValue = (b['charts'] as List).last['notecounts'][noteKey] ?? 0;
      }

      if (reverse) {
        return bValue.compareTo(aValue);
      } else {
        return aValue.compareTo(bValue);
      }
    });

    for (var i in zxzrSongs) {
      for (var j in songs['songs']) {
        if (i['id'] == j['id']) {
          if (diffindex == 5 && (i['charts'] as List).length == 1) {
            result.add(j);
            if ((i['charts'] as List).length == 1) {
              notecountlist.add(i['charts'].last['notecounts'][noteKey]);
            } else {
              notecountlist.add(null);
            }
          } else if ([0, 1, 2, 3].contains(diffindex)) {
            result.add(j);
            if ((i['charts'] as List).length == 4) {
              notecountlist.add(i['charts'][diffindex]['notecounts'][noteKey]);
            } else {
              notecountlist.add(null);
            }
          } else if (diffindex == 4 && (i['charts'] as List).length == 5) {
            result.add(j);
            if ((i['charts'] as List).length == 5) {
              notecountlist.add(i['charts'][diffindex]['notecounts'][noteKey]);
            } else {
              notecountlist.add(null);
            }
          }
        }
      }
    }
    songs['songs'] = result;
  }
  int index = 0;
  for (var i in songs['songs']) {
    late String versionname;
    for (var j in songs['versions']) {
      if (i['version'] == j['version']) {
        versionname = j['title'];
        break;
      }
    }

    widgets.add(
      returnSortSongCard(
        songbasedata: i,
        versionname: versionname,
        context: context,
        type: type,
        notecountlist: notecountlist,
        index: index,
      ),
    );
    index++;
  }
  return widgets;
}

Widget returnSortSongCard({
  required Map<String, dynamic> songbasedata,
  required String versionname,
  required BuildContext context,
  required String type,
  required List notecountlist,
  required int index,
}) {
  int originid = songbasedata['id'];
  List<Widget> songInfoDiffs = [];
  Widget other = SizedBox.shrink();
  if (type == 'BPM') {
    other = Text('BPM: ${songbasedata['bpm']}');
  } else if (type == 'World\'s End星数') {
    other = Text('星数: ${songbasedata['difficulties'][0]['star']}');
  } else if (type.contains('数量') || type.contains('总数')) {
    if (notecountlist.isEmpty) {
      other = Text('数量: null');
    } else {
      if (index > notecountlist.length) {
        index = notecountlist.length - 1;
      }
      other = Text('数量: ${notecountlist[index]}');
    }
  }

  if (((songbasedata['difficulties'] as List).last as Map).containsKey(
    'origin_id',
  )) {
    originid = songbasedata['difficulties'].last['origin_id'];
  }
  for (var k in songbasedata['difficulties']) {
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
            k['level_value'].toString(),
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
  return InkWell(
    // key: ValueKey(songItem['id']),
    onTap: () async {
      interSongInfo(
        songbasedata: songbasedata,
        context: context,
        versionname: versionname,
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
      child: Padding(
        padding: EdgeInsetsGeometry.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(right: 10),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://assets2.lxns.net/chunithm/jacket/$originid.png',
                    width: 105,
                    height: 105,
                    errorWidget: (context, url, error) => Text('加载失败'),
                  ),
                ),
                other,
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,

                    children: [
                      Text(
                        '#${songbasedata['id']}',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${songbasedata['title']}',
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
                          '${songbasedata['artist']}',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${songbasedata['genre']} - $versionname',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Wrap(children: songInfoDiffs),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
