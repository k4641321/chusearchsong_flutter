import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'request.dart';
import 'package:flutter/material.dart';
import 'request.dart';
import 'dart:convert';

Future<List<Widget>> getLineChartAndCard({
  required BuildContext context,
  required int id,
  required int diffindex,
  required Color corlor,
  // required void Function(int index) onSpotTouched,
}) async {
  try {
    List<Widget> result = [];
    List<Widget> cardList = [];
    String allscorestr = await requestSongHistory(id: id, diff: diffindex);
    List allscore = jsonDecode(allscorestr)['data'];

    //表格绘制
    List<FlSpot> spots = [];
    double x = 1;
    int maxscore = 0;
    int minscore = 0;
    List date = [];
    for (var i in allscore) {
      spots.add(FlSpot(x, i['score'].toDouble()));
      x += 1;
      if (i['score'] > maxscore) {
        maxscore = i['score'];
      }
      if (i['score'] < minscore || minscore == 0) {
        minscore = i['score'];
      }
      date.insert(0, i['play_time']);
    }

    Widget lineChart = Padding(
      padding: const EdgeInsets.only(top: 100),
      child: SizedBox(
        height: 400,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              // touchCallback:
              //     (FlTouchEvent event, LineTouchResponse? touchResponse) {
              //       if (event is FlTapUpEvent &&
              //           touchResponse?.lineBarSpots?.isNotEmpty == true) {
              //         int index =
              //             touchResponse!.lineBarSpots!.last.x.toInt() - 1;
              //         onSpotTouched(index); // 告诉父组件"用户点了第几个"
              //       }
              //     },
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  List<LineTooltipItem> result = [
                    LineTooltipItem(
                      '${touchedSpots.last.y.toInt()}\n${DateTime.parse(date[date.length - touchedSpots.last.x.toInt()]).toLocal().toString()}',
                      TextStyle(color: Colors.black),
                    ),
                  ];
                  return result;
                },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                drawBelowEverything: false,
                sideTitles: SideTitles(
                  minIncluded: false,
                  showTitles: true,
                  reservedSize: 50,
                ),
              ),
              bottomTitles: AxisTitles(
                drawBelowEverything: false,
                sideTitles: SideTitles(
                  interval: 1,
                  showTitles: true,
                  reservedSize: 90,
                  minIncluded: false,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt() - 1;
                    if (index >= date.length) {
                      index = date.length - 1;
                    } else if (index < 0) {
                      index = 0;
                    }
                    if (index >= 0 && index < date.length) {
                      return SideTitleWidget(
                        meta: meta,
                        child: Transform.rotate(
                          angle: 45 * (3.1415926535 / 180), // 45度转弧度
                          child: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              DateTime.parse(date[index]).toLocal().toString(),
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                    // print(index);
                  },
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(reservedSize: 100, showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [LineChartBarData(spots: spots)],
            minX: 0,
            maxX: allscore.length.toDouble() + 1,
            minY: minscore.toDouble(),
            maxY: maxscore.toDouble(),
          ),
        ),
      ),
    );
    //历史成绩绘制
    for (var i in allscore) {
      cardList.add(
        InkWell(
          child: Card(
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Column(
                children: [
                  Row(children: [Icon(Icons.star), Text('历史成绩')]),
                  Text('Score:   ${i['score']}'),
                  const Divider(),
                  Text('Rating:   ${i['rating']}'),
                  const Divider(),
                  Text('Over Power:   ${i['over_power']}'),
                  const Divider(),
                  Text('Clear:   ${i['clear']}'),
                  const Divider(),
                  Text('Full Combo:   ${i['full_combo']}'),
                  const Divider(),
                  Text('Full Chain:   ${i['full_chain']}'),
                  const Divider(),
                  Text(
                    'Rank:   ${(i['rank'] as String).replaceFirst('p', '+')}',
                  ),
                  const Divider(),
                  Text(
                    'Play time:   ${DateTime.parse(i['play_time']).toLocal()}',
                  ),
                  const Divider(),
                  Text(
                    'Update time:   ${DateTime.parse(i['upload_time']).toLocal()}',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    result.add(lineChart);
    result.add(Column(children: cardList));

    return result;
  } catch (e, stackTrace) {
    log('$e\n$stackTrace', name: 'scorehistorypagefun.dart', level: 1000);
    return [Text('获取失败'), Text('获取失败')];
  }
}
