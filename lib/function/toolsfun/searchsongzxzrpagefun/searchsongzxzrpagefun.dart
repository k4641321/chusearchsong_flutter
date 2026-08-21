import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

//加载歌曲数据
Future<List> loadSongs() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/res/zxzrsongs.json');
  final json = jsonDecode(await file.readAsString());
  return json;
}

//流派
Future<Widget> buildGenreDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) async {
  Set genreList = {};
  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  try {
    List data = await loadSongs();
    dropdownMenuEntries.add(
      DropdownMenuEntry<String>(label: '分类', value: '-1'),
    );
    for (var i in data) {
      genreList.add(i['genre']);
    }
    for (var i in genreList) {
      dropdownMenuEntries.add(DropdownMenuEntry<String>(label: i, value: i));
    }
  } catch (e) {
    log('创建流派失败 $e 返回默认流派列表');
    dropdownMenuEntries = const [
      DropdownMenuEntry<String>(label: '分类', value: '-1'),
      DropdownMenuEntry<String>(label: 'POPS & ANIME', value: 'POPS & ANIME'),
      DropdownMenuEntry<String>(label: 'niconico', value: 'niconico'),
      DropdownMenuEntry<String>(label: '東方Project', value: '東方Project'),
      DropdownMenuEntry<String>(label: 'ORIGINAL', value: 'ORIGINAL'),
      DropdownMenuEntry<String>(label: 'VARIETY', value: 'VARIETY'),
      DropdownMenuEntry<String>(label: 'イロドリミドリ', value: 'イロドリミドリ'),
      DropdownMenuEntry<String>(label: 'ゲキマイ', value: 'ゲキマイ'),
    ];
  }

  return DropdownMenu<String>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? '-1',
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: dropdownMenuEntries,
  );
}

// 版本
Future<Widget> buildVersionDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) async {
  Set versionList = {};
  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  try {
    List data = await loadSongs();
    dropdownMenuEntries.add(
      DropdownMenuEntry<String>(label: '版本', value: '-1'),
    );
    for (var i in data) {
      if (i['version'] == null) {
        continue;
      }
      versionList.add(i['version']);
    }
    for (var i in versionList) {
      dropdownMenuEntries.add(DropdownMenuEntry<String>(label: i, value: i));
    }
  } catch (e) {
    log('创建版本失败 $e 返回默认版本列表');

    dropdownMenuEntries = const [
      DropdownMenuEntry<String>(label: '版本', value: '-1'),
      DropdownMenuEntry<String>(label: 'CHUNITHM', value: '10000'),
      DropdownMenuEntry<String>(label: 'CHUNITHM PLUS', value: '10500'),
      DropdownMenuEntry<String>(label: 'CHUNITHM AIR', value: '11000'),
      DropdownMenuEntry<String>(label: 'CHUNITHM AIR PLUS', value: '11500'),
      DropdownMenuEntry<String>(label: 'CHUNITHM STAR', value: '12000'),
      DropdownMenuEntry<String>(label: 'CHUNITHM STAR PLUS', value: '12500'),
      DropdownMenuEntry<String>(label: 'CHUNITHM AMAZON', value: '13000'),
      DropdownMenuEntry<String>(label: 'CHUNITHM AMAZON PLUS', value: '13500'),
      DropdownMenuEntry<String>(label: 'CHUNITHM CRYSTAL', value: '14000'),
      DropdownMenuEntry<String>(label: 'CHUNITHM CRYSTAL PLUS', value: '14500'),
      DropdownMenuEntry<String>(label: 'CHUNITHM PARADISE', value: '15000'),
      DropdownMenuEntry<String>(
        label: 'CHUNITHM PARADISE LOST',
        value: '15500',
      ),
      DropdownMenuEntry<String>(label: 'CHUNITHM NEW', value: '20000'),
      DropdownMenuEntry<String>(label: 'CHUNITHM NEW PLUS', value: '20500'),
      DropdownMenuEntry<String>(label: 'CHUNITHM SUN', value: '21000'),
      DropdownMenuEntry<String>(label: 'CHUNITHM SUN PLUS', value: '21500'),
      DropdownMenuEntry<String>(label: 'CHUNITHM LUMINOUS', value: '22000'),
      DropdownMenuEntry<String>(
        label: 'CHUNITHM LUMINOUS PLUS',
        value: '22500',
      ),
      DropdownMenuEntry<String>(label: 'CHUNITHM VERSE', value: '23000'),
    ];
  }
  return DropdownMenu<String>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? '-1',
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: dropdownMenuEntries,
  );
}

// //进入歌曲详情页
// Future<void> interSongInfo({
//   required Map<String, dynamic> songbasedata,
//   required BuildContext context,
//   required String versionname,
// }) async {
//   // List<DataRow> songData = [];
//   // List<Widget> songData = [];
//   List<Widget> information = [];
//   final difficulties = (songbasedata['difficulties'] as List?) ?? [];
//   final lastWithOrigin = difficulties.lastWhere(
//     (d) => d is Map && d.containsKey('origin_id'),
//     orElse: () => null,
//   );
//   int songid = lastWithOrigin?['origin_id'] ?? songbasedata['id'];

//   if (information.isEmpty) {
//     information.add(Text('无信息', style: const TextStyle(fontSize: 15)));
//   }
//   information.insert(
//     0,
//     (Row(children: [Icon(Icons.info_outline), Text('其余信息')])),
//   );

//   //别名加载
//   if (!context.mounted) return;
//   List<Widget> alias = await returnAlias(
//     id: songbasedata['id'],
//     context: context,
//   );
//   if (!context.mounted) return;
//   await Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => SongInfoPage(
//         songbasedata: songbasedata,
//         versionname: versionname,
//         originid: songid,
//         // information: information,
//         alias: alias,
//       ),
//     ),
//   );
//   // log('未完成 ${i['id']}');
// }
