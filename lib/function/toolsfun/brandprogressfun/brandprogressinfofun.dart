import 'package:cached_network_image/cached_network_image.dart';
import 'package:chusearchsong_flutter/function/fun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:flutter/material.dart';

Future<List<Widget>> buildBrandProgressWidgets({
  required Map<String, dynamic> songsData,
  required Map<String, dynamic> brandinfo,
  required List playhistory,
  required int diffindex,
  required bool isshow,
  required BuildContext context,
}) async {
  List<Widget> result = [];
  //先整理一遍要求曲目
  List requiredSongs = [];
  for (var i in brandinfo['required'][0]['songs']) {
    for (var j in songsData['songs']) {
      if (i['id'] == j['id']) {
        requiredSongs.add(j);
      }
    }
  }
  //按定数分类
  Map<String, dynamic> requiredSongsFilter = {};

  for (var i in requiredSongs) {
    if (!requiredSongsFilter.containsKey(
      i['difficulties'][diffindex]['level'],
    )) {
      requiredSongsFilter[i['difficulties'][diffindex]['level']] = [i];
    } else {
      requiredSongsFilter[i['difficulties'][diffindex]['level']].add(i);
    }
  }
  //排个序
  List sortKeys = [];
  for (var i in requiredSongsFilter.keys) {
    sortKeys.add(double.parse(i.replaceAll('+', '.5')));
  }
  sortKeys.sort((a, b) => b.compareTo(a));
  // print(sortKeys);
  int requireddifflegth = brandinfo['required'][0]['difficulties'].length;
  int requiredScore = 0;
  String requiredFullCombo = '';
  String requiredFullChain = '';
  int totalcomplete = 0;
  if (brandinfo['required'][0].containsKey('rank')) {
    requiredScore = returnRequiredScore(brandinfo['required'][0]['rank']);
  } else if (brandinfo['required'][0].containsKey('full_combo')) {
    requiredFullCombo = brandinfo['required'][0]['full_combo'];
  } else if (brandinfo['required'][0].containsKey('full_chain')) {
    requiredFullChain = brandinfo['required'][0]['full_chain'];
  }
  for (var i in sortKeys) {
    List<Widget> children = [];
    String key;
    if (i.toString().contains('.5')) {
      key = i.toString().replaceAll('.5', '+');
    } else {
      key = i.toString().replaceAll('.0', '');
    }
    for (var j in requiredSongsFilter[key]) {
      String versionname = '';
      Widget rank = SizedBox.shrink();
      int score = 0;
      int complete = 0;
      bool iscontinue = false;
      for (var k in playhistory) {
        if (k['id'] == j['id'] && k['level_index'] == diffindex) {
          score = k['score'];
          if (requiredScore != 0 && score >= requiredScore) {
            totalcomplete++;
            complete++;
            if (!isshow) {
              iscontinue = true;
            }
          } else if (requiredFullCombo != '' &&
              returnfcList(requiredFullCombo).contains(k['full_combo'])) {
            totalcomplete++;
            complete++;
            if (!isshow) {
              iscontinue = true;
            }
          } else if (requiredFullChain != '' &&
              returnFullChainList(k['full_chain']).contains(k['full_chain'])) {
            totalcomplete++;
            complete++;
            if (!isshow) {
              iscontinue = true;
            }
          }
          rank = SizedBox(
            width: 75,
            height: 75,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(127, 157, 157, 157),
              ),
              child: Image.asset(
                width: 75,
                height: 75,
                rankImg(rank: k['rank']),
              ),
            ),
          );
        }
      }
      if (iscontinue) continue;

      for (var k in songsData['versions']) {
        if (k['version'] == j['version']) {
          versionname = k['title'];
          break;
        }
      }
      children.add(
        InkWell(
          onTap: () {
            interSongInfo(
              songbasedata: j,
              context: context,
              versionname: versionname,
            );
          },
          child: Padding(
            padding: EdgeInsetsGeometry.all(5),
            child: Container(
              decoration: BoxDecoration(color: diffcolor(diffindex: diffindex)),
              padding: EdgeInsets.all(5),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    width: 75,
                    height: 75,
                    imageUrl:
                        'https://assets2.lxns.net/chunithm/jacket/${j['id']}.png',
                    errorWidget: (context, error, stackTrace) => Text('图片加载失败'),
                  ),

                  rank,
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: complete == 0
                        ? SizedBox.shrink()
                        : Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(124, 0, 0, 0),
                            ),
                            width: 75,
                            height: 20,
                            child: Text(
                              '$complete / $requireddifflegth',
                              style: TextStyle(color: Colors.orange),
                              textAlign: TextAlign.center,
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
    result.add(
      Card(
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text:
                          'Lv.${i.toString().replaceAll('.5', '+').replaceAll('.0', '')}',
                      children: [
                        TextSpan(
                          text:
                              '\t(${(requiredSongsFilter[key] as List).length} 首)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
              Wrap(children: children),
            ],
          ),
        ),
      ),
    );
    //总难度完成情况添加
  }
  result.insert(
    0,
    Card(
      child: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Text(
          '总完成情况 $totalcomplete / ${brandinfo['required'][0]['songs'].length}',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    ),
  );
  return result;
}

int returnRequiredScore(String rank) {
  switch (rank) {
    case 'sssp':
      return 1009000;
    case 'sss':
      return 1007500;
    case 'ssp':
      return 1005000;
    case 'ss':
      return 1000000;
    case 'sp':
      return 990000;
    case 's':
      return 975000;
    default:
      return 975000;
  }
}

List returnfcList(String fc) {
  switch (fc) {
    case 'fullcombo':
      return ['fullcombo'];
    case 'alljustice':
      return ['alljusticecritical', 'alljustice'];
    case 'alljusticecritical':
      return ['alljusticecritical'];
    default:
      return [];
  }
}

List returnFullChainList(String fc) {
  switch (fc) {
    case 'fullchain':
      return ['fullchain'];
    case 'fullchain2':
      return ['fullchain', 'fullchain2'];
    default:
      return [];
  }
}
