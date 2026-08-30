import 'dart:developer';

import 'package:flutter/material.dart';

List<DataRow> calculate({required int total, required bool countdown}) {
  List<DataRow> rows = [];
  // double onetap = 1010000 / total;
  double jc = 1010000 / total;
  double j = 10000 / total;
  double a = 500000 / total;
  // double m = 0;

  int tapm = 0;
  int tapa = 0;
  int tapj = 0;

  void countdownall() {
    if (countdown == true) {
      if (tapm != 0) {
        --tapm;
      }
      if (tapa != 0) {
        --tapa;
      }
      if (tapj != 0) {
        tapj = tapj - 146;
        if (tapj < 0) {
          tapj = 0;
        }
      }
    }
  }

  void reset() {
    tapm = 0;
    tapa = 0;
    tapj = 0;
  }

  void ifjgreaterthantotal() {
    if (tapj >= total) {
      tapj = 0;
    }
  }

  reset();
  //SSS+
  log('SSS+');
  log('jc: $jc');
  log('j: $j');
  tapj = 1000 ~/ j;
  log('tapj: $tapj');
  tapm = 1000 ~/ jc;
  log('tapm: $tapm');
  tapa = 1000 ~/ a;
  log('tapa: $tapa');
  tapj = 1000 ~/ j;
  ifjgreaterthantotal();
  countdownall();
  rows.add(
    DataRow(
      cells: [
        DataCell(Text('SSS+')),
        DataCell(Text('最多可有: $tapm 个M / $tapa 个A / $tapj 个J')),
      ],
    ),
  );
  //SSS
  reset();
  log('SSS');
  log('jc: $jc');
  tapm = 2500 ~/ jc;
  log('tapm: $tapm');
  tapa = 2500 ~/ a;
  log('tapa: $tapa');
  tapj = 2500 ~/ j;
  ifjgreaterthantotal();
  countdownall();
  rows.add(
    DataRow(
      cells: [
        DataCell(Text('SSS')),
        DataCell(Text('最多可有: $tapm 个M / $tapa 个A / $tapj 个J')),
      ],
    ),
  );
  //SS+
  reset();
  log('SS+');
  log('jc: $jc');
  tapm = 5000 ~/ jc;
  log('tapm: $tapm');
  tapa = 5000 ~/ a;
  log('tapa: $tapa');
  tapj = 5000 ~/ j;
  ifjgreaterthantotal();
  countdownall();
  rows.add(
    DataRow(
      cells: [
        DataCell(Text('SS+')),
        DataCell(Text('最多可有: $tapm 个M / $tapa 个A / $tapj 个J')),
      ],
    ),
  );
  //SS
  reset();
  log('SS');
  log('jc: $jc');
  tapm = 10000 ~/ jc;
  log('tapm: $tapm');
  tapa = 10000 ~/ a;
  log('tapa: $tapa');
  tapj = 10000 ~/ j;
  ifjgreaterthantotal();
  countdownall();
  rows.add(
    DataRow(
      cells: [
        DataCell(Text('SS')),
        DataCell(Text('最多可有: $tapm 个M / $tapa 个A / $tapj 个J')),
      ],
    ),
  );
  //S+
  reset();
  log('S+');
  log('jc: $jc');
  tapm = 20000 ~/ jc;
  log('tapm: $tapm');
  tapa = 20000 ~/ a;
  log('tapa: $tapa');
  tapj = 20000 ~/ j;
  ifjgreaterthantotal();
  countdownall();
  rows.add(
    DataRow(
      cells: [
        DataCell(Text('S+')),
        DataCell(Text('最多可有: $tapm 个M / $tapa 个A / $tapj 个J')),
      ],
    ),
  );

  //S
  reset();
  log('S');
  log('jc: $jc');
  tapm = 35000 ~/ jc;
  log('tapm: $tapm');
  tapa = 35000 ~/ a;
  log('tapa: $tapa');
  tapj = 35000 ~/ j;
  ifjgreaterthantotal();
  countdownall();
  rows.add(
    DataRow(
      cells: [
        DataCell(Text('S')),
        DataCell(Text('最多可有: $tapm 个M / $tapa 个A / $tapj 个J')),
      ],
    ),
  );
  return rows;
}
