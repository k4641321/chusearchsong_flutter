import 'package:flutter/material.dart';

import 'generateb50fun/generateb50.dart';

//返回英文难度列表，称号使用
List<Widget> returnEnglishDiff({
  required List difficulties,
  required bool isComplete,
  List? requireddifficulties,
}) {
  String diffName(int diff) {
    switch (diff) {
      case 0:
        return 'BASIC';
      case 1:
        return 'ADVANCED';
      case 2:
        return 'EXPERT';
      case 3:
        return 'MASTER';
      case 4:
        return 'ULTIMA';
      case 5:
        return "World's End";
      default:
        return '未知';
    }
  }

  Widget diffCard(int diff) {
    return Card(
      color: diffcolor(diffindex: diff),
      child: Padding(
        padding: EdgeInsetsGeometry.only(left: 8, right: 8, top: 3, bottom: 3),
        child: Text(diffName(diff), style: TextStyle(color: Colors.white)),
      ),
    );
  }

  final List<int> listToShow;
  if (isComplete) {
    listToShow = List<int>.from(difficulties);
  } else {
    // 用副本计算，避免修改调用方传入的 requireddifficulties
    listToShow = List<int>.from(requireddifficulties ?? const <int>[])
      ..removeWhere((e) => difficulties.contains(e));
  }

  return [for (var i in listToShow) diffCard(i)];
}

Color returnFullChainBackgroundColor(String fullchain) {
  switch (fullchain) {
    case 'fullchain':
      return Colors.blueGrey;
    case 'fullchain2':
      return Colors.yellow;
    default:
      return Colors.transparent;
  }
}

Color returnFullComboBackgroundColor(String fullcombo) {
  switch (fullcombo) {
    case 'alljusticecritical':
      return Colors.deepPurple;
    case 'alljustice':
      return Colors.purple;
    case 'fullcombo':
      return Colors.orange;
    default:
      return Colors.transparent;
  }
}
