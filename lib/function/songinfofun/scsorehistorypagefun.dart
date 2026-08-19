import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import '../request.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

//此页面表格已经过AI优化

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
    double x = 0;
    int maxscore = 0;
    int minscore = 0;
    List date = [];
    // 反转数据，使图表从左到右按时间从旧到新排列
    List reversedScore = allscore.reversed.toList();
    for (var i in reversedScore) {
      spots.add(FlSpot(x, i['score'].toDouble()));
      x += 1;
      if (i['score'] > maxscore) {
        maxscore = i['score'];
      }
      if (i['score'] < minscore || minscore == 0) {
        minscore = i['score'];
      }
      date.add(i['play_time']);
    }

    // 日期标签格式化
    String fmtDate(dynamic t) {
      final d = DateTime.parse(t).toLocal();
      String mm = d.month.toString().padLeft(2, '0');
      String dd = d.day.toString().padLeft(2, '0');
      return '$mm-$dd';
    }

    int labelStep = (date.length / 6).ceil();
    if (labelStep < 1) labelStep = 1;

    int scoreRange = maxscore - minscore;
    if (scoreRange <= 0) scoreRange = 1;

    Widget lineChart = Padding(
      padding: const EdgeInsets.only(top: 100),
      child: SizedBox(
        height: 400,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: scoreRange / 4,
              getDrawingHorizontalLine: (value) =>
                  FlLine(color: Colors.grey.withOpacity(0.15), strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: Colors.grey.withOpacity(0.3)),
                bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipBorderRadius: BorderRadius.circular(8),
                tooltipPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                getTooltipItems: (touchedSpots) {
                  int idx = touchedSpots.last.x.toInt();
                  return [
                    LineTooltipItem(
                      '${touchedSpots.last.y.toInt()}\n',
                      TextStyle(
                        color: corlor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      children: [
                        if (idx >= 0 && idx < date.length)
                          TextSpan(
                            text: DateTime.parse(
                              date[idx],
                            ).toLocal().toString().substring(0, 16),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ];
                },
              ),
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 55,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        '${value.toInt()}',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: labelStep.toDouble(),
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= date.length) {
                      return const SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        fmtDate(date[index]),
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                curveSmoothness: 0.3,
                color: corlor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                        radius: 2.5,
                        color: corlor,
                        strokeWidth: 1.5,
                        strokeColor: Colors.white,
                      ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [corlor.withOpacity(0.3), corlor.withOpacity(0.0)],
                  ),
                ),
              ),
            ],
            minX: 0,
            maxX: allscore.length.toDouble(),
            minY: (minscore - scoreRange * 0.1).toDouble(),
            maxY: (maxscore + scoreRange * 0.1).toDouble(),
          ),
        ),
      ),
    );
    //历史成绩绘制
    for (var i in allscore) {
      cardList.add(
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: InkWell(
            child: Card(
              color: corlor,
              child: Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star),
                        Text(
                          '历史成绩',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
