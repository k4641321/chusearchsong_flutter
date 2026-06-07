import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RatingTrendPages extends StatefulWidget {
  final List data;
  const RatingTrendPages({super.key, required this.data});

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
                width: MediaQuery.widthOf(context) * 0.9,
                height: MediaQuery.heightOf(context) * 0.8,
                child: Padding(
                  padding: EdgeInsetsGeometry.all(15),
                  child: LineChart(
                    LineChartData(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      lineBarsData: [LineChartBarData(spots: widget.data[0])],
                      minX: 0,
                      minY: 0,
                      maxX: widget.data[2],
                      maxY: widget.data[1],
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
                            reservedSize: 30,
                            interval: 1,
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
