import 'package:flutter/material.dart';

import 'generateb50fun/generateb50.dart';

//返回英文难度列表，称号使用
List<Widget> returnEnglishDiff({
  required List difficulties,
  required bool isComplete,
  List? requireddifficulties,
}) {
  List<Widget> result = [];
  if (isComplete == true) {
    for (var i in difficulties) {
      switch (i) {
        case 0:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('BASIC'),
              ),
            ),
          );
        case 1:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('ADVANCED'),
              ),
            ),
          );
        case 2:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('EXPERT'),
              ),
            ),
          );
        case 3:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('MASTER'),
              ),
            ),
          );
        case 4:
          difficulties.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('ULTIMATE'),
              ),
            ),
          );
        case 5:
          difficulties.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('Worlds\'End'),
              ),
            ),
          );
        default:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('未知'),
              ),
            ),
          );
      }
    }
  } else if (isComplete == false && requireddifficulties != null) {
    requireddifficulties.removeWhere(difficulties.contains);
    for (var i in requireddifficulties) {
      switch (i) {
        case 0:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('BASIC'),
              ),
            ),
          );
        case 1:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('ADVANCED'),
              ),
            ),
          );
        case 2:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('EXPERT'),
              ),
            ),
          );
        case 3:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('MASTER'),
              ),
            ),
          );
        case 4:
          difficulties.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('ULTIMATE'),
              ),
            ),
          );
        case 5:
          difficulties.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('Worlds\'End'),
              ),
            ),
          );
        default:
          result.add(
            Card(
              color: diffcolor(diffindex: i),
              child: Padding(
                padding: EdgeInsetsGeometry.only(
                  left: 8,
                  right: 8,
                  top: 3,
                  bottom: 3,
                ),
                child: Text('未知'),
              ),
            ),
          );
      }
    }
  }
  return result;
}
