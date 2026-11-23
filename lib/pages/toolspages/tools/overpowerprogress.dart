import 'dart:developer';

import 'package:chusearchsong_flutter/function/toolsfun/overpowerprogressfun.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/material.dart';

class Overpowerprogress extends StatefulWidget {
  const Overpowerprogress({super.key});

  @override
  State<Overpowerprogress> createState() => _OverpowerprogressState();
}

class _OverpowerprogressState extends State<Overpowerprogress> {
  Map<String, dynamic> songsData = {};
  Map<dynamic, dynamic> overPowerData = {};
  List selectDifficulty = [];
  List<Widget> diffWrapChildren = [];
  List difflist = [];
  List diffselectedlist = [];
  List playerAllScore = [];
  List<Widget> resultWidgets = [];

  IconData _showdiffIcon = Icons.arrow_drop_up_sharp;
  bool _showdiff = false;

  void _buildVersionWrapWidget() {
    List<Widget> diffWrapChildrentmp = [];
    List<Widget> resultWidgetstmp = [];
    diffWrapChildrentmp = buildOverPowerProgressVersionWrapChildren(
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

        resultWidgetstmp = buildOverPowerProgressResultChildren(
          selectedDiffList: selectDifficulty,
          overPowerData: overPowerData,
          playerAllScore: playerAllScore,
          songsData: songsData,
          specificNumber: false,
          context: context,
        );

        setState(() {
          resultWidgets = resultWidgetstmp;
        });
        log("${resultWidgets.length}");
        _buildVersionWrapWidget();
      },
    );
    setState(() {
      diffWrapChildren = diffWrapChildrentmp;
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
    _buildVersionWrapWidget();
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
      body: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _showdiff = !_showdiff;
                if (_showdiffIcon == Icons.arrow_drop_down) {
                  _showdiffIcon = Icons.arrow_drop_up;
                } else {
                  _showdiffIcon = Icons.arrow_drop_down;
                }
              });
            },
            child: Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '难度',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(_showdiffIcon),
                ],
              ),
            ),
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
          Expanded(child: ListView(children: resultWidgets)),
        ],
      ),
    );
  }
}
