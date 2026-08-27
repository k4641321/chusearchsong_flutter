import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../../function/toolsfun/generateb50fun/generateb50.dart';
import 'package:file_picker/file_picker.dart';

//懒得翻文档了，我又不会设计ui，让ai美化了

class RatingTrendPages extends StatefulWidget {
  final List data1;
  final List data2;
  const RatingTrendPages({super.key, required this.data1, required this.data2});

  @override
  State<RatingTrendPages> createState() => _RatingTrendPagesState();
}

class _RatingTrendPagesState extends State<RatingTrendPages> {
  final ScrollController _scrollController = ScrollController();
  Widget playerinfo = SizedBox.shrink();
  final GlobalKey _globalKey = GlobalKey();

  Map<double, String> _buildDateMap() {
    final map = <double, String>{};
    double index = 0;
    for (final item in widget.data2) {
      ++index;
      map[index] = item['date'] as String;
    }
    return map;
  }

  Future<void> loadplayerinfo() async {
    try {
      final path = await getApplicationSupportDirectory();
      final file = File('${path.path}/res/playerinfo.json');
      Map playerdata = await jsonDecode(await file.readAsString())['data'];
      Widget title = SizedBox(
        height: 170,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(left: 55),
              child: SizedBox(
                width: 525,
                height: 225,
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Card(
                            color: trophyColor(
                              trophy: playerdata['trophy']['color'],
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.only(
                                left: 60,
                                right: 60,
                                top: 5,
                                bottom: 5,
                              ),
                              child: Text(
                                '${playerdata['trophy']['name']}',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsGeometry.only(left: 15),
                            child: Text(
                              'Lv.${playerdata['level']}  ${playerdata['name']}',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          Text(
                            'Rating:   ${playerdata['rating']}',

                            style: TextStyle(
                              fontSize: 25,
                              color: ratingColor(rating: playerdata['rating']),
                              shadows: [
                                Shadow(color: Colors.black, blurRadius: 3),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Image.network(
                        'https://assets2.lxns.net/chunithm/character/${playerdata['character']['id']}.png',
                        width: 175,
                        height: 175,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      setState(() {
        playerinfo = title;
      });
    } catch (e) {
      log('$e');
      return;
    }
  }

  Future<ui.Image?> captureWidget(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return await boundary.toImage(pixelRatio: 2.0); // pixelRatio 控制清晰度
  }

  @override
  void didChangeDependencies() {
    loadplayerinfo();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final dateMap = _buildDateMap();
    final spots = widget.data1[0] as List<FlSpot>;

    // 根据数据量动态计算图表宽度，每个数据点至少 60px
    final double chartWidth = spots.length * 60.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rating趋势"),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                final image = await captureWidget(_globalKey);
                final byteData = await image?.toByteData(format: .png);
                final pngBytes = byteData?.buffer.asUint8List();
                final path = await getApplicationSupportDirectory();
                if (!Directory('${path.path}/tmp').existsSync()) {
                  Directory('${path.path}/tmp').create(recursive: true);
                }
                File(
                  '${path.path}/tmp/ratingtrend.png',
                ).writeAsBytesSync(pngBytes!);
                if (!context.mounted) return;
                // final platform = Theme.of(context).platform;
                // if (platform == TargetPlatform.windows ||
                //     platform == TargetPlatform.linux) {
                await FilePicker.saveFile(
                  dialogTitle: '保存Rating趋势',
                  fileName: 'ratingtrend.png',
                  bytes: pngBytes,
                  type: FileType.custom,
                  allowedExtensions: ['png'],
                );
                // } else {
                //   await SharePlus.instance.share(
                //     ShareParams(
                //       files: [XFile('${path.path}/tmp/ratingtrend.png')],
                //     ),
                //   );
                // }
              } catch (e, strack) {
                log('$e \n $strack');
                if (!context.mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('错误 $e\n$strack')));
              }
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: RepaintBoundary(
                  key: _globalKey,
                  child: Column(
                    children: [
                      Row(children: [playerinfo]),
                      SizedBox(
                        width: chartWidth,
                        height: constraints.maxHeight * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              minY: 0,
                              maxX: widget.data1[2] as double,
                              maxY: (widget.data1[1] as double) * 1.05,
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: _calcInterval(
                                  widget.data1[1] as double,
                                ),
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: theme.colorScheme.outlineVariant
                                      .withAlpha(80),
                                  strokeWidth: 1,
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                  left: BorderSide(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                ),
                              ),
                              lineTouchData: LineTouchData(
                                handleBuiltInTouches: true,
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (_) =>
                                      theme.colorScheme.inverseSurface,
                                  getTooltipItems: (touchedSpots) {
                                    return touchedSpots.map((spot) {
                                      final date = dateMap[spot.x] ?? '';
                                      return LineTooltipItem(
                                        '$date\n${spot.y.toStringAsFixed(2)}',
                                        TextStyle(
                                          color: theme
                                              .colorScheme
                                              .onInverseSurface,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: true,
                                  curveSmoothness: 0.3,
                                  color: primaryColor,
                                  barWidth: 2.5,
                                  dotData: FlDotData(
                                    show: spots.length < 30,
                                    getDotPainter: (spot, _, _, _) =>
                                        FlDotCirclePainter(
                                          radius: 3,
                                          color: primaryColor,
                                          strokeWidth: 1,
                                          strokeColor:
                                              theme.colorScheme.surface,
                                        ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        primaryColor.withAlpha(60),
                                        primaryColor.withAlpha(0),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 60,
                                    interval: 1,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                          final label = dateMap[value] ?? '';
                                          return SideTitleWidget(
                                            meta: meta,
                                            child: Transform.rotate(
                                              angle: 0.785, // 45° in radians
                                              child: Text(
                                                label,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 52,
                                    interval: _calcInterval(
                                      widget.data1[1] as double,
                                    ),
                                    getTitlesWidget: (value, meta) => Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                    ),
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
            ),
          );
        },
      ),
    );
  }

  double _calcInterval(double maxY) {
    if (maxY <= 5) return 0.5;
    if (maxY <= 20) return 2;
    if (maxY <= 100) return 10;
    if (maxY <= 500) return 50;
    return (maxY / 8).ceilToDouble();
  }
}
