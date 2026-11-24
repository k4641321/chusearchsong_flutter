import 'dart:developer';

import 'package:chusearchsong_flutter/function/list.dart';
import 'package:chusearchsong_flutter/function/toolsfun/overpowerprogressfun.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';

class Overpowerprogress extends StatefulWidget {
  const Overpowerprogress({super.key});

  @override
  State<Overpowerprogress> createState() => _OverpowerprogressState();
}

class _OverpowerprogressState extends State<Overpowerprogress> {
  ScrollController _scrollController = ScrollController();

  Map<String, dynamic> songsData = {};
  Map<dynamic, dynamic> overPowerData = {};

  List selectDifficulty = [];
  List selectedChartColor = [];
  List selectedGenre = ['-1'];
  List selectedVersion = ['-1'];
  List selectedOther = [];

  List difflist = [];
  List diffselectedlist = [];
  List playerAllScore = [];
  List<Widget> resultWidgets = [];

  List<Widget> diffWrapChildren = [];
  List<Widget> chartColorWrapChildren = [];
  List<Widget> genreWrapChildren = [];
  List<Widget> versionWrapChildren = [];
  List<Widget> otherWrapChildren = [];

  //难度显示
  IconData _showdiffIcon = Icons.arrow_drop_up_sharp;
  bool _showdiff = false;
  //谱面颜色
  IconData _showChartColorIcon = Icons.arrow_drop_up_sharp;
  bool _showChartColor = false;
  //流派显示
  IconData _showgenreIcon = Icons.arrow_drop_up_sharp;
  bool _showgenre = false;
  //版本显示
  IconData _showversionIcon = Icons.arrow_drop_up_sharp;
  bool _showversion = false;
  //其余筛选显示
  IconData _showotherIcon = Icons.arrow_drop_up_sharp;
  bool _showother = false;

  List<Widget> _update() {
    return buildOverPowerProgressResultChildren(
      selectedDiffList: selectDifficulty,
      selectedVersionList: selectedVersion,
      selectedGenreList: selectedGenre,
      overPowerData: overPowerData,
      playerAllScore: playerAllScore,
      songsData: songsData,
      specificNumber: false,
      context: context,
    );
  }

  void _buildDifficultyWrapWidget() {
    List<Widget> diffWrapChildrentmp = [];
    List<Widget> resultWidgetstmp = [];
    diffWrapChildrentmp = buildOverPowerProgressDifficultyWrapChildren(
      songsData: songsData,
      difflist: difflist,
      selectedDiffList: selectDifficulty,
      onChange: () => setState(() {}),
      onVersionSelected: (value) {
        if (selectDifficulty.contains(value)) {
          selectDifficulty.remove(value);
        } else {
          selectDifficulty.add(value);
        }

        resultWidgetstmp = _update();
        setState(() {
          resultWidgets = resultWidgetstmp;
        });
        log("${resultWidgets.length}");
        _buildDifficultyWrapWidget();
      },
    );
    setState(() {
      diffWrapChildren = diffWrapChildrentmp;
    });
  }

  void _buildChartColorWrapWidget() {
    List<Widget> diffWrapChildrentmp = [];
    List<Widget> resultWidgetstmp = [];
    diffWrapChildrentmp = buildOverPowerProgressDifficultyWrapChildren(
      songsData: songsData,
      difflist: difflist,
      selectedDiffList: selectDifficulty,
      onChange: () => setState(() {}),
      onVersionSelected: (value) {
        if (selectDifficulty.contains(value)) {
          selectDifficulty.remove(value);
        } else {
          selectDifficulty.add(value);
        }

        resultWidgetstmp = _update();

        setState(() {
          resultWidgets = resultWidgetstmp;
        });
        log("${resultWidgets.length}");
        _buildChartColorWrapWidget();
      },
    );
    setState(() {
      diffWrapChildren = diffWrapChildrentmp;
    });
  }

  void _buildVersionWrapWidget() {
    List<Widget> versionWrapChildrentmp = [];
    List<Widget> resultWidgetstmp = [];
    versionWrapChildrentmp = buildVersionWrapList(
      songsdata: songsData,
      currentVersion: selectedVersion,
      onChange: () => setState(() {}),
      onGenreSelected: (value) {
        if (selectedVersion.contains(value) && value != '-1') {
          selectedVersion.remove(value);
          selectedVersion.remove('-1');
        } else {
          selectedVersion.add(value);
          selectedVersion.remove('-1');
        }
        if (selectedVersion.isEmpty) {
          selectedVersion = ['-1'];
        } else if (value == '-1') {
          selectedVersion = ['-1'];
        }
        resultWidgetstmp = _update();

        setState(() {
          resultWidgets = resultWidgetstmp;
        });
        log("${resultWidgets.length}");
        _buildVersionWrapWidget();
        // print(selectedGenre);
      },
    );
    setState(() {
      versionWrapChildren = versionWrapChildrentmp;
    });
  }

  void _buildGenreWrapWidget() {
    List<Widget> genreWrapChildrentmp = [];
    List<Widget> resultWidgetstmp = [];
    genreWrapChildrentmp = buildGenreWrapList(
      songsdata: songsData,
      currentGenre: selectedGenre,
      onChange: () => setState(() {}),
      onGenreSelected: (value) {
        if (selectedGenre.contains(value) && value != '-1') {
          selectedGenre.remove(value);
          selectedGenre.remove('-1');
        } else {
          selectedGenre.add(value);
          selectedGenre.remove('-1');
        }
        if (selectedGenre.isEmpty) {
          selectedGenre = ['-1'];
        } else if (value == '-1') {
          selectedGenre = ['-1'];
        }
        resultWidgetstmp = _update();

        setState(() {
          resultWidgets = resultWidgetstmp;
        });
        log("${resultWidgets.length}");
        _buildGenreWrapWidget();
        // print(selectedGenre);
      },
    );
    setState(() {
      genreWrapChildren = genreWrapChildrentmp;
    });
  }

  void init() {
    songsData = SongDataStore.instance.songsData;
    playerAllScore = SongDataStore.instance.playerAllScore;
    Set diffset = {};
    overPowerData = calculationOverPowerData(songsData: songsData);
    for (var i in songsData['songs']) {
      for (var j in i['difficulties']) {
        diffset.add(double.parse((j['level'] as String).replaceAll('+', '.5')));
      }
    }
    // print(diffset);
    difflist = diffset.toList()..sort((a, b) => (b as double).compareTo(a));
    _buildDifficultyWrapWidget();
    _buildVersionWrapWidget();
    _buildGenreWrapWidget();
    // print(calculationOverPowerData(songsData: songsData));
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Over Power进度')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,

          child: Column(
            children: [
              _buildOptionWidget(
                iconData: _showdiffIcon,
                showText: '等级',
                onshow: () {
                  setState(() {
                    _showdiff = !_showdiff;
                    if (_showdiff) {
                      _showdiffIcon = Icons.arrow_drop_down;
                    } else {
                      _showdiffIcon = Icons.arrow_drop_up;
                    }
                  });
                },
              ),
              _showdiff
                  ? Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Wrap(
                        spacing: 5.0,
                        runSpacing: 3.0,
                        children: diffWrapChildren,
                      ),
                    )
                  : SizedBox.shrink(),
              _buildOptionWidget(
                iconData: _showChartColorIcon,
                showText: '谱面',
                onshow: () {
                  setState(() {
                    _showChartColor = !_showChartColor;
                    if (_showChartColor) {
                      _showChartColorIcon = Icons.arrow_drop_down;
                    } else {
                      _showChartColorIcon = Icons.arrow_drop_up;
                    }
                  });
                },
              ),

              _showChartColor ? Wrap(children: []) : SizedBox.shrink(),
              _buildOptionWidget(
                iconData: _showgenreIcon,
                showText: '流派',
                onshow: () {
                  setState(() {
                    _showgenre = !_showgenre;
                    if (_showgenre) {
                      _showgenreIcon = Icons.arrow_drop_down;
                    } else {
                      _showgenreIcon = Icons.arrow_drop_up;
                    }
                  });
                },
              ),
              _showgenre
                  ? Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: genreWrapChildren,
                    )
                  : SizedBox.shrink(),
              _buildOptionWidget(
                iconData: _showversionIcon,
                showText: '版本',
                onshow: () {
                  setState(() {
                    _showversion = !_showversion;
                    if (_showversion) {
                      _showversionIcon = Icons.arrow_drop_down;
                    } else {
                      _showversionIcon = Icons.arrow_drop_up;
                    }
                  });
                },
              ),
              _showversion
                  ? Wrap(
                      spacing: 5.0,
                      runSpacing: 3.0,
                      children: versionWrapChildren,
                    )
                  : SizedBox.shrink(),
              _buildOptionWidget(
                iconData: _showotherIcon,
                showText: '其他',
                onshow: () {
                  setState(() {
                    _showother = !_showother;
                    if (_showother) {
                      _showotherIcon = Icons.arrow_drop_down;
                    } else {
                      _showotherIcon = Icons.arrow_drop_up;
                    }
                  });
                },
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: resultWidgets,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildOptionWidget({
  required IconData iconData,
  required VoidCallback onshow,
  required String showText,
}) {
  return InkWell(
    onTap: () {
      onshow();
    },
    child: Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              showText,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Icon(iconData),
        ],
      ),
    ),
  );
}
