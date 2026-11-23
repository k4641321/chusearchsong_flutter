import 'dart:developer';

import 'package:chusearchsong_flutter/function/commonfun.dart';
import 'package:chusearchsong_flutter/function/toolsfun/generateb50fun/generateb50.dart';
import 'package:chusearchsong_flutter/function/toolsfun/ratingcalculatorpagefun.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

List<Widget> buildOverPowerProgressVersionWrapChildren({
  required Map<String, dynamic> songsData,
  required List difflist,
  required List selectedDiffList,
  required VoidCallback onChange,
  required ValueChanged onVersionSelected,
}) {
  List<Widget> wrapList = [];
  for (var i in difflist) {
    wrapList.add(
      FilterChip(
        label: Text(i.toString().replaceAll(".0", '').replaceAll(".5", "+")),
        onSelected: (_) {
          onVersionSelected(i);
          onChange();
          // print(selectedDiffList);
        },
        selected: selectedDiffList.contains(i),
      ),
    );
  }

  return wrapList;
}

Map<dynamic, dynamic> calculationOverPowerData({
  required Map<dynamic, dynamic> songsData,
}) {
  Map<dynamic, dynamic> data = {};
  for (var i in songsData['songs']) {
    for (var j in i['difficulties']) {
      if (j['difficulty'] == 5) continue;
      if (data.containsKey(j['level_value'])) {
        data[j['level_value']]['total'] =
            data[j['level_value']]['total'] +
            calculationOverPower(
              level: j['level_value'].toDouble(),
              score: 1010000,
              type: 'AJC',
            );
        data[j['level_value']]['songs'].add({
          "id": i['id'],
          "difficulty": j['difficulty'],
          "level_value": j['level_value'],
          "songbasedata": i,
        });
      } else {
        data[j['level_value']] = {"total": 0, "songs": []};
        data[j['level_value']]['total'] = calculationOverPower(
          level: j['level_value'].toDouble(),
          score: 1010000,
          type: 'AJC',
        );
        data[j['level_value']]['songs'].add({
          "id": i['id'],
          "difficulty": j['difficulty'],
          "level_value": j['level_value'],
          "songbasedata": i,
        });
      }
    }
  }
  return data;
}

double calculationOverPower({
  required int score,
  required double level,
  required String type,
}) {
  double xz1 = 0;
  double xz2 = (score - 1007500) * 0.0015;

  switch (type) {
    case 'FC':
      xz1 = 0.5;
      break;
    case 'AJ':
      xz1 = 1.0;
      break;
    case 'AJC':
      xz1 = 1.25;
      break;
    case 'None':
      xz1 = 0;
      break;
  }

  //AJC
  if (score == 1010000) {
    return (level + 2) * 5 + (1.25 + 3.75);
  } else if (score >= 1007501) {
    return (level + 2) * 5 + xz1 + xz2;
  } else {
    return calculatorRating(
              scorestr: score.toString(),
              diffstr: level.toString(),
            ) *
            5 +
        xz1;
  }
}

List<Widget> buildOverPowerProgressResultChildren({
  required List selectedDiffList,
  required Map overPowerData,
  required List playerAllScore,
  required Map<String, dynamic> songsData,
  required bool specificNumber,
  required BuildContext context,
}) {
  // log('${selectedDiffList}');
  List<Widget> resultchildren = [];
  for (var i in selectedDiffList) {
    List<Widget> cardWrapList = [];
    for (var j = 0; j < 5; j++) {
      double diffvalue = i + j;
      if (!overPowerData.keys.contains(diffvalue)) continue;
      for (var k in overPowerData[(i + j).toDouble()]['songs']) {
        List playerOverPowerList = [];
        for (var l in playerAllScore) {
          if (l['id'] == k['id']) {
            playerOverPowerList.add({
              "level_index": l['level_index'],
              "over_power": l['over_power'],
            });
          }
        }
        playerOverPowerList.sort((a, b) {
          if (a['over_power'] > b['over_power']) {
            return -1;
          } else if (a['over_power'] < b['over_power']) {
            return 1;
          } else {
            return 0;
          }
        });
        double playerOverPower = 0;
        if (playerOverPowerList.isNotEmpty) {
          if ((playerOverPowerList.first as Map)['level_index'] ==
              k['difficulty']) {
            playerOverPower = ((playerOverPowerList.first as Map)['over_power']
                .toDouble());
          }
        }

        cardWrapList.add(
          InkWell(
            onTap: () async {
              interSongInfo(
                songbasedata: k['songbasedata'],
                songsData: songsData,
                context: context,
              );
            },
            child: Container(
              color: diffcolor(diffindex: k['difficulty']),
              child: Padding(
                padding: EdgeInsetsGeometry.all(5),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        buildImageWidget(
                          url:
                              'https://assets2.lxns.net/chunithm/jacket/${k['id']}.png',
                          width: 75,
                          height: 75,
                          fit: BoxFit.fill,
                        ),
                      ],
                    ),
                    Text(
                      'OP: ${playerOverPower == 0 ? '' : "${playerOverPower.toStringAsFixed(2)}  / "}${calculationOverPower(score: 1010000, level: k['level_value'].toDouble(), type: 'AJC')}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: playerOverPower == 0 ? 14 : 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
    resultchildren.add(
      Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Card(
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Lv.${i.toString().replaceAll('.0', '').replaceAll('.5', '+')}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 3,
                  runSpacing: 3,
                  children: cardWrapList,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  // log('${resultchildren.length}');
  return resultchildren;
}
