import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:developer';

Future<Map<String, dynamic>> getSongInfo(int id) async {
  final response = await get(
    Uri.parse('https://maimai.lxns.net/api/v0/chunithm/song/$id'),
  );

  Map<String, dynamic> songInfo = jsonDecode(response.body);
  return songInfo;
}

Future<List<DataRow>> returnSongInfo(int id) async {
  List<DataCell> diff0 = [];
  List<DataCell> diff1 = [];
  List<DataCell> diff2 = [];
  List<DataCell> diff3 = [];
  List<DataCell> diff4 = [];
  List<DataRow> rowsData = [];
  try {
    Map<String, dynamic> songInfo = await getSongInfo(id);
    // print(songInfo);
    for (var i in songInfo['difficulties']) {
      switch (i['difficulty']) {
        case 0:
          diff0.add(DataCell(Text('${i['level_value']}')));
          diff0.add(DataCell(Text('${i['notes']['tap']}')));
          diff0.add(DataCell(Text('${i['notes']['hold']}')));
          diff0.add(DataCell(Text('${i['notes']['slide']}')));
          diff0.add(DataCell(Text('${i['notes']['air']}')));
          diff0.add(DataCell(Text('${i['notes']['flick']}')));
          diff0.add(DataCell(Text('${i['notes']['total']}')));
          diff0.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff0));
        case 1:
          diff1.add(DataCell(Text('${i['level_value']}')));
          diff1.add(DataCell(Text('${i['notes']['tap']}')));
          diff1.add(DataCell(Text('${i['notes']['hold']}')));
          diff1.add(DataCell(Text('${i['notes']['slide']}')));
          diff1.add(DataCell(Text('${i['notes']['air']}')));
          diff1.add(DataCell(Text('${i['notes']['flick']}')));
          diff1.add(DataCell(Text('${i['notes']['total']}')));
          diff1.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff1));
        case 2:
          diff2.add(DataCell(Text('${i['level_value']}')));
          diff2.add(DataCell(Text('${i['notes']['tap']}')));
          diff2.add(DataCell(Text('${i['notes']['hold']}')));
          diff2.add(DataCell(Text('${i['notes']['slide']}')));
          diff2.add(DataCell(Text('${i['notes']['air']}')));
          diff2.add(DataCell(Text('${i['notes']['flick']}')));
          diff2.add(DataCell(Text('${i['notes']['total']}')));
          diff2.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff2));
        case 3:
          diff3.add(DataCell(Text('${i['level_value']}')));
          diff3.add(DataCell(Text('${i['notes']['tap']}')));
          diff3.add(DataCell(Text('${i['notes']['hold']}')));
          diff3.add(DataCell(Text('${i['notes']['slide']}')));
          diff3.add(DataCell(Text('${i['notes']['air']}')));
          diff3.add(DataCell(Text('${i['notes']['flick']}')));
          diff3.add(DataCell(Text('${i['notes']['total']}')));
          diff3.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff3));
        case 4:
          diff4.add(DataCell(Text('${i['level_value']}')));
          diff4.add(DataCell(Text('${i['notes']['tap']}')));
          diff4.add(DataCell(Text('${i['notes']['hold']}')));
          diff4.add(DataCell(Text('${i['notes']['slide']}')));
          diff4.add(DataCell(Text('${i['notes']['air']}')));
          diff4.add(DataCell(Text('${i['notes']['flick']}')));
          diff4.add(DataCell(Text('${i['notes']['total']}')));
          diff4.add(DataCell(Text('${i['note_designer']}')));
          rowsData.add(DataRow(cells: diff4));
        default:
          List<DataCell> nodata = [
            DataCell(Text('无数据')),
            DataCell(Text('或者')),
            DataCell(Text('网络')),
            DataCell(Text('错误')),
            DataCell(Text('error')),
            DataCell(Text('error')),
            DataCell(Text('error')),
            DataCell(Text('error')),
          ];
          rowsData.add(DataRow(cells: nodata));
      }
    }
  } catch (e) {
    List<DataCell> nodata = [
      DataCell(Text('无数据')),
      DataCell(Text('或者')),
      DataCell(Text('网络')),
      DataCell(Text('错误')),
      DataCell(Text('error')),
      DataCell(Text('error')),
      DataCell(Text('error')),
      DataCell(Text('error')),
    ];
    rowsData.add(DataRow(cells: nodata));
    log('error $e', name: 'songinfopage.dart', level: 1000);
    return rowsData;
  }
  return rowsData;
}
