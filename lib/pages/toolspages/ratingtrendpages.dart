import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RatingTrendPages extends StatefulWidget {
  final List data1;
  final List data2;
  const RatingTrendPages({super.key, required this.data1, required this.data2});

  @override
  State<RatingTrendPages> createState() => _RatingTrendPagesState();
}

class _RatingTrendPagesState extends State<RatingTrendPages> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Rating趋势")),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.widthOf(context) * 1.5,
                height: MediaQuery.heightOf(context) * 0.8,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(15),
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      lineBarsData: [LineChartBarData(spots: widget.data1[0])],
                      minX: 0,
                      minY: 0,
                      maxX: widget.data1[2],
                      maxY: widget.data1[1],
                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            interval: 1,
                            getTitlesWidget: (double value, TitleMeta meta) {
                              double index = 0;
                              String lable = '';
                              for (var i in widget.data2) {
                                ++index;
                                if (value == index) {
                                  lable = i['date'];
                                }
                              }
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  lable,
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          drawBelowEverything: false,
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 50,
                            // interval: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
