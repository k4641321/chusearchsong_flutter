import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../function/toolsfun/ratingcalculatorpagefun.dart';

//麻痹的，开始学不知道，现在知道可以不用加<String>，来不及改了

String fix2dp(double value) {
  final truncated = (value * 100).truncate();
  final sign = truncated < 0 ? '-' : '';
  final abs = truncated.abs();
  return '$sign${abs ~/ 100}.${(abs % 100).toString().padLeft(2, '0')}';
}

//加载歌曲数据
Future<Map<String, dynamic>> loadSongs() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/res/songs.json');
  final json = jsonDecode(await file.readAsString());
  return json;
}

//加载别名数据
Future<Map<String, dynamic>> loadAlias() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/res/alias.json');
  final json = jsonDecode(await file.readAsString());
  return json;
}

//版本Wrap列表
List<Widget> buildVersionWrapList({
  required Map<String, dynamic> songsdata,
  required List currentVersion,
  required VoidCallback onChange,
  required ValueChanged onGenreSelected,
}) {
  List<Widget> wrapList = [];
  try {
    wrapList.add(
      FilterChip(
        label: Text('版本'),
        selected: currentVersion.contains('-1'),
        onSelected: (value) {
          onGenreSelected('-1');
          onChange();
        },
      ),
    );
    for (var i in songsdata['versions']) {
      wrapList.add(
        FilterChip(
          label: Text(i['title']),
          selected: currentVersion.contains(i['version'].toString()),
          onSelected: (_) {
            onGenreSelected(i['version'].toString());
            onChange();
          },
        ),
      );
    }
  } catch (e) {
    log('创建流派失败 $e 返回默认流派列表');
    wrapList = [
      FilterChip(
        label: Text('版本'),
        selected: currentVersion.contains('-1'),
        onSelected: (_) {
          onGenreSelected('-1');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM'),
        selected: currentVersion.contains('10000'),
        onSelected: (_) {
          onGenreSelected('10000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM PLUS'),
        selected: currentVersion.contains('10500'),
        onSelected: (_) {
          onGenreSelected('10500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM AIR'),
        selected: currentVersion.contains('11000'),
        onSelected: (_) {
          onGenreSelected('11000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM AIR PLUS'),
        selected: currentVersion.contains('11500'),
        onSelected: (_) {
          onGenreSelected('11500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM STAR'),
        selected: currentVersion.contains('12000'),
        onSelected: (_) {
          onGenreSelected('12000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM STAR PLUS'),
        selected: currentVersion.contains('12500'),
        onSelected: (_) {
          onGenreSelected('12500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM AMAZON'),
        selected: currentVersion.contains('13000'),
        onSelected: (_) {
          onGenreSelected('13000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM AMAZON PLUS'),
        selected: currentVersion.contains('13500'),
        onSelected: (_) {
          onGenreSelected('13500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM CRYSTAL'),
        selected: currentVersion.contains('14000'),
        onSelected: (_) {
          onGenreSelected('14000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM CRYSTAL PLUS'),
        selected: currentVersion.contains('14500'),
        onSelected: (_) {
          onGenreSelected('14500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM PARADISE'),
        selected: currentVersion.contains('15000'),
        onSelected: (_) {
          onGenreSelected('15000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM PARADISE LOST'),
        selected: currentVersion.contains('15500'),
        onSelected: (_) {
          onGenreSelected('15500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM NEW'),
        selected: currentVersion.contains('20000'),
        onSelected: (_) {
          onGenreSelected('20000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM NEW PLUS'),
        selected: currentVersion.contains('20500'),
        onSelected: (_) {
          onGenreSelected('20500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM SUN'),
        selected: currentVersion.contains('21000'),
        onSelected: (_) {
          onGenreSelected('21000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM SUN PLUS'),
        selected: currentVersion.contains('21500'),
        onSelected: (_) {
          onGenreSelected('21500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM LUMINOUS'),
        selected: currentVersion.contains('22000'),
        onSelected: (_) {
          onGenreSelected('22000');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM LUMINOUS PLUS'),
        selected: currentVersion.contains('22500'),
        onSelected: (_) {
          onGenreSelected('22500');
          onChange();
        },
      ),
      FilterChip(
        label: Text('CHUNITHM VERSE'),
        selected: currentVersion.contains('23000'),
        onSelected: (_) {
          onGenreSelected('23000');
          onChange();
        },
      ),
    ];
  }
  return wrapList;
}

//流派Wrap列表
List<Widget> buildGenreWrapList({
  required Map<String, dynamic> songsdata,

  required List currentGenre,
  required VoidCallback onChange,
  required ValueChanged onGenreSelected,
}) {
  List<Widget> wrapList = [];
  try {
    wrapList.add(
      FilterChip(
        label: Text('分类'),
        selected: currentGenre.contains('-1'),
        onSelected: (value) {
          onGenreSelected('-1');
          onChange();
        },
      ),
    );
    for (var i in songsdata['genres']) {
      wrapList.add(
        FilterChip(
          label: Text(i['genre']),
          selected: currentGenre.contains(i['id'].toString()),
          onSelected: (_) {
            onGenreSelected(i['id'].toString());
            onChange();
          },
        ),
      );
    }
  } catch (e) {
    log('创建流派失败 $e 返回默认流派列表');
    wrapList = [
      FilterChip(
        label: Text('分类'),
        selected: currentGenre.contains('-1'),
        onSelected: (_) {
          onGenreSelected('-1');
          onChange();
        },
      ),
      FilterChip(
        label: Text('流行 & 动漫'),
        selected: currentGenre.contains('0'),
        onSelected: (_) {
          onGenreSelected('0');
          onChange();
        },
      ),
      FilterChip(
        label: Text('niconico'),
        selected: currentGenre.contains('2'),
        onSelected: (_) {
          onGenreSelected('2');
          onChange();
        },
      ),
      FilterChip(
        label: Text('东方Project'),
        selected: currentGenre.contains('3'),
        onSelected: (_) {
          onGenreSelected('3');
          onChange();
        },
      ),
      FilterChip(
        label: Text('原创'),
        selected: currentGenre.contains('5'),
        onSelected: (_) {
          onGenreSelected('5');
          onChange();
        },
      ),
      FilterChip(
        label: Text('其他游戏'),
        selected: currentGenre.contains('6'),
        onSelected: (_) {
          onGenreSelected('6');
          onChange();
        },
      ),
      FilterChip(
        label: Text('彩绿'),
        selected: currentGenre.contains('7'),
        onSelected: (_) {
          onGenreSelected('7');
          onChange();
        },
      ),
      FilterChip(
        label: Text('音击舞萌'),
        selected: currentGenre.contains('9'),
        onSelected: (_) {
          onGenreSelected('9');
          onChange();
        },
      ),
    ];
  }
  return wrapList;
}

// 流派
Future<Widget> buildGenreDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) async {
  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  try {
    Map<String, dynamic> data = await loadSongs();
    dropdownMenuEntries.add(
      DropdownMenuEntry<String>(label: '分类', value: '-1'),
    );
    for (var i in data['genres']) {
      dropdownMenuEntries.add(
        DropdownMenuEntry<String>(label: i['genre'], value: i['id'].toString()),
      );
    }
  } catch (e) {
    log('创建流派失败 $e 返回默认流派列表');
    dropdownMenuEntries = const [
      DropdownMenuEntry<String>(label: '分类', value: '-1'),
      DropdownMenuEntry<String>(label: '流行 & 动漫', value: '0'),
      DropdownMenuEntry<String>(label: 'niconico', value: '2'),
      DropdownMenuEntry<String>(label: '东方Project', value: '3'),
      DropdownMenuEntry<String>(label: '原创', value: '5'),
      DropdownMenuEntry<String>(label: '其他游戏', value: '6'),
      DropdownMenuEntry<String>(label: '彩绿', value: '7'),
      DropdownMenuEntry<String>(label: '音击舞萌', value: '9'),
    ];
  }

  return DropdownMenu<String>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? '-1',
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: dropdownMenuEntries,
    decorationBuilder: (context, controller) => InputDecoration(),
  );
}

// 版本
Future<Widget> buildVersionDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) async {
  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  try {
    Map<String, dynamic> data = await loadSongs();
    dropdownMenuEntries.add(
      DropdownMenuEntry<String>(label: '版本', value: '-1'),
    );
    for (var i in data['versions']) {
      dropdownMenuEntries.add(
        DropdownMenuEntry<String>(
          label: i['title'],
          value: i['version'].toString(),
        ),
      );
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

// 难度下限
Widget buildDifficultyDownDropdownMenu({
  required TextEditingController ccontroller,
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? '-1',
    selectOnly: false,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,}')),
    ],
    onSelected: onSelected,
    controller: ccontroller,
    dropdownMenuEntries: const [
      DropdownMenuEntry<String>(label: '难度下限', value: '-1'),
      DropdownMenuEntry<String>(label: '0', value: '0'),
      DropdownMenuEntry<String>(label: '1', value: '1'),
      DropdownMenuEntry<String>(label: '2', value: '2'),
      DropdownMenuEntry<String>(label: '3', value: '3'),
      DropdownMenuEntry<String>(label: '4', value: '4'),
      DropdownMenuEntry<String>(label: '5', value: '5'),
      DropdownMenuEntry<String>(label: '6', value: '6'),
      DropdownMenuEntry<String>(label: '7', value: '7'),
      DropdownMenuEntry<String>(label: '7+', value: '7.5'),
      DropdownMenuEntry<String>(label: '8', value: '8'),
      DropdownMenuEntry<String>(label: '8+', value: '8.5'),
      DropdownMenuEntry<String>(label: '9', value: '9'),
      DropdownMenuEntry<String>(label: '9+', value: '9.5'),
      DropdownMenuEntry<String>(label: '10', value: '10'),
      DropdownMenuEntry<String>(label: '10+', value: '10.5'),
      DropdownMenuEntry<String>(label: '11', value: '11'),
      DropdownMenuEntry<String>(label: '11+', value: '11.5'),
      DropdownMenuEntry<String>(label: '12', value: '12'),
      DropdownMenuEntry<String>(label: '12+', value: '12.5'),
      DropdownMenuEntry<String>(label: '13', value: '13'),
      DropdownMenuEntry<String>(label: '13+', value: '13.5'),
      DropdownMenuEntry<String>(label: '14', value: '14'),
      DropdownMenuEntry<String>(label: '14+', value: '14.5'),
      DropdownMenuEntry<String>(label: '15', value: '15'),
      DropdownMenuEntry<String>(label: '15+', value: '15.5'),
      DropdownMenuEntry<String>(label: '16', value: '16'),
    ],
  );
}

// 难度上限
Widget buildDifficultyUpDropdownMenu({
  required TextEditingController ccontroller,
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? '-1',
    selectOnly: false,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,}')),
    ],
    onSelected: onSelected,
    controller: ccontroller,
    dropdownMenuEntries: const [
      DropdownMenuEntry<String>(label: '难度上限', value: '-1'),
      DropdownMenuEntry<String>(label: '0', value: '0'),
      DropdownMenuEntry<String>(label: '1', value: '1'),
      DropdownMenuEntry<String>(label: '2', value: '2'),
      DropdownMenuEntry<String>(label: '3', value: '3'),
      DropdownMenuEntry<String>(label: '4', value: '4'),
      DropdownMenuEntry<String>(label: '5', value: '5'),
      DropdownMenuEntry<String>(label: '6', value: '6'),
      DropdownMenuEntry<String>(label: '7', value: '7'),
      DropdownMenuEntry<String>(label: '7+', value: '7.9'),
      DropdownMenuEntry<String>(label: '8', value: '8'),
      DropdownMenuEntry<String>(label: '8+', value: '8.9'),
      DropdownMenuEntry<String>(label: '9', value: '9'),
      DropdownMenuEntry<String>(label: '9+', value: '9.9'),
      DropdownMenuEntry<String>(label: '10', value: '10'),
      DropdownMenuEntry<String>(label: '10+', value: '10.9'),
      DropdownMenuEntry<String>(label: '11', value: '11'),
      DropdownMenuEntry<String>(label: '11+', value: '11.9'),
      DropdownMenuEntry<String>(label: '12', value: '12'),
      DropdownMenuEntry<String>(label: '12+', value: '12.9'),
      DropdownMenuEntry<String>(label: '13', value: '13'),
      DropdownMenuEntry<String>(label: '13+', value: '13.9'),
      DropdownMenuEntry<String>(label: '14', value: '14'),
      DropdownMenuEntry<String>(label: '14+', value: '14.9'),
      DropdownMenuEntry<String>(label: '15', value: '15'),
      DropdownMenuEntry<String>(label: '15+', value: '15.9'),
      DropdownMenuEntry<String>(label: '16', value: '16.4'),
      DropdownMenuEntry<String>(label: '16+', value: '16.9'),
    ],
  );
}

//是否游玩
Widget buildIfPlayDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? '-1',
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: const [
      DropdownMenuEntry<String>(label: '全部', value: '-1'),
      DropdownMenuEntry<String>(label: '已游玩', value: '1'),
      DropdownMenuEntry<String>(label: '未游玩', value: '0'),
    ],
  );
}

//是否游玩
Widget buildSpecialFilterDropdownMenu({
  int? initialSelection,
  ValueChanged<int?>? onSelected,
}) {
  return DropdownMenu<int>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? 0,
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: const [
      DropdownMenuEntry<int>(label: '不启用特殊筛选', value: 0),
      DropdownMenuEntry<int>(label: '启用特殊筛选', value: 1),
    ],
  );
}

//评级
Widget buildRankDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? '-1',
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: const [
      DropdownMenuEntry<String>(label: '评级', value: '-1'),
      DropdownMenuEntry<String>(label: 'D', value: 'd'),
      DropdownMenuEntry<String>(label: 'C', value: 'c'),
      DropdownMenuEntry<String>(label: 'B', value: 'b'),
      DropdownMenuEntry<String>(label: 'BB', value: 'bb'),
      DropdownMenuEntry<String>(label: 'BBB', value: 'bbb'),
      DropdownMenuEntry<String>(label: 'A', value: 'a'),
      DropdownMenuEntry<String>(label: 'AA', value: 'aa'),
      DropdownMenuEntry<String>(label: 'AAA', value: 'aaa'),
      DropdownMenuEntry<String>(label: 'S', value: 's'),
      DropdownMenuEntry<String>(label: 'S+', value: 'sp'),
      DropdownMenuEntry<String>(label: 'SS', value: 'ss'),
      DropdownMenuEntry<String>(label: 'SS+', value: 'ssp'),
      DropdownMenuEntry<String>(label: 'SSS', value: 'sss'),
      DropdownMenuEntry<String>(label: 'SSS+', value: 'sssp'),
    ],
  );
}

List<DataRow> rankList() {
  List<DataRow> rowsData = [];
  rowsData = [
    DataRow(
      cells: [
        DataCell(
          Text(
            'SSS+',
            style: TextStyle(color: const Color.fromARGB(255, 225, 0, 255)),
          ),
        ),
        DataCell(Text('1009000~1010000')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'SSS',
            style: TextStyle(color: const Color.fromARGB(255, 225, 0, 255)),
          ),
        ),
        DataCell(Text('1007500~1008999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'SS+',
            style: TextStyle(color: const Color.fromARGB(255, 225, 0, 255)),
          ),
        ),
        DataCell(Text('1005000~1007499')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'SS',
            style: TextStyle(color: const Color.fromARGB(255, 225, 0, 255)),
          ),
        ),
        DataCell(Text('1000000~1004999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'S+',
            style: TextStyle(color: const Color.fromARGB(255, 225, 0, 255)),
          ),
        ),
        DataCell(Text('990000~999999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'S',
            style: TextStyle(color: const Color.fromARGB(255, 225, 0, 255)),
          ),
        ),
        DataCell(Text('975000~989999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'AAA',
            style: TextStyle(color: const Color.fromARGB(255, 255, 174, 0)),
          ),
        ),
        DataCell(Text('950000~974999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'AA',
            style: TextStyle(color: const Color.fromARGB(255, 255, 174, 0)),
          ),
        ),
        DataCell(Text('925000~949999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'A',
            style: TextStyle(color: const Color.fromARGB(255, 255, 174, 0)),
          ),
        ),
        DataCell(Text('900000~924999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'BBB',
            style: TextStyle(color: const Color.fromARGB(255, 0, 81, 255)),
          ),
        ),
        DataCell(Text('800000~899999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'BB',
            style: TextStyle(color: const Color.fromARGB(255, 0, 81, 255)),
          ),
        ),
        DataCell(Text('700000~799999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'B',
            style: TextStyle(color: const Color.fromARGB(255, 0, 81, 255)),
          ),
        ),
        DataCell(Text('600000~699999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'C',
            style: TextStyle(color: const Color.fromARGB(255, 0, 110, 9)),
          ),
        ),
        DataCell(Text('500000~599999')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'D',
            style: TextStyle(color: const Color.fromARGB(255, 97, 97, 97)),
          ),
        ),
        DataCell(Text('000000~449999')),
      ],
    ),
  ];
  return rowsData;
}

List<DataRow> determineList() {
  List<DataRow> rowsData = [
    DataRow(
      cells: [
        DataCell(
          Text(
            'JUSTICE CRITICAL',
            style: TextStyle(color: const Color.fromARGB(255, 255, 230, 0)),
          ),
        ),
        DataCell(Text('101%')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'JUSTICE',
            style: TextStyle(color: const Color.fromARGB(255, 255, 187, 0)),
          ),
        ),
        DataCell(Text('100%')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'ATTACK',
            style: TextStyle(color: const Color.fromARGB(255, 0, 110, 9)),
          ),
        ),
        DataCell(Text('50%')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            'MISS',
            style: TextStyle(color: const Color.fromARGB(255, 97, 97, 97)),
          ),
        ),
        DataCell(Text('0%')),
      ],
    ),
  ];
  return rowsData;
}

List<DataRow> ratingColor() {
  List<DataRow> rowsData = [
    DataRow(
      cells: [
        DataCell(Text('绿', style: TextStyle(color: Colors.green))),
        DataCell(Text('0.00~3.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('橙', style: TextStyle(color: Colors.orange))),
        DataCell(Text('4.00~6.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('红', style: TextStyle(color: Colors.red))),
        DataCell(Text('7.00~9.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('紫', style: TextStyle(color: Colors.deepPurple))),
        DataCell(Text('10.00~11.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('铜', style: TextStyle(color: Colors.deepOrange))),
        DataCell(Text('12.00~13.24')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('银', style: TextStyle(color: Colors.grey))),
        DataCell(Text('13.25~14.49')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('金', style: TextStyle(color: Colors.yellow))),
        DataCell(Text('14.50~15.24')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('铂金', style: TextStyle(color: Colors.amber))),
        DataCell(Text('15.25~15.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('彩虹', style: TextStyle(color: Colors.purple))),
        DataCell(Text('16.00~16.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(Text('彩虹(极)', style: TextStyle(color: Colors.purpleAccent))),
        DataCell(Text('17.00~')),
      ],
    ),
  ];
  return rowsData;
}

List<DataRow> ratingCalculator({
  required double diff,
  required BuildContext context,
}) {
  List<DataRow> rowsData = [
    DataRow(
      cells: [
        DataCell(
          Text(
            '1010000',
            style: TextStyle(color: const Color.fromARGB(255, 0, 136, 11)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1010000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1008500',
            style: TextStyle(color: const Color.fromARGB(255, 0, 162, 255)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1008500', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1008000',
            style: TextStyle(color: const Color.fromARGB(255, 0, 162, 255)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1008000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1007750',
            style: TextStyle(color: const Color.fromARGB(255, 0, 162, 255)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1007750', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1007500',
            style: TextStyle(color: const Color.fromARGB(255, 0, 162, 255)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1007500', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1007000',
            style: TextStyle(color: const Color.fromARGB(255, 255, 230, 0)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1007000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1006000',
            style: TextStyle(color: const Color.fromARGB(255, 255, 230, 0)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1006000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1005000',
            style: TextStyle(color: const Color.fromARGB(255, 255, 230, 0)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1005000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1003000',
            style: TextStyle(color: const Color.fromARGB(255, 255, 230, 0)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1003000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1001000',
            style: TextStyle(color: const Color.fromARGB(255, 255, 230, 0)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1001000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '1000000',
            style: TextStyle(color: const Color.fromARGB(255, 255, 230, 0)),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '1000000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),

    DataRow(
      cells: [
        DataCell(
          Text(
            '997500',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '997500', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '995000',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '995000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '992500',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '992500', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '990000',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '990000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '985000',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '985000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '980000',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '980000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '975000',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        DataCell(
          Text(
            fix2dp(
              calculatorRating(scorestr: '975000', diffstr: diff.toString()),
            ),
          ),
        ),
      ],
    ),
  ];
  return rowsData;
}

Future<List<DropdownMenuEntry<String>>> getlobby() async {
  List<DropdownMenuEntry<String>> dropdownMenuEntries = [];
  final dataPath = await getApplicationSupportDirectory();
  String lobbyDataStr = await File(
    '${dataPath.path}/res/location.json',
  ).readAsString();
  final lobbyDataJson = json.decode(lobbyDataStr) as List;
  final Set<String> location = {};
  for (var i in lobbyDataJson) {
    location.add(i['province']);
  }
  dropdownMenuEntries.add(DropdownMenuEntry<String>(value: '全部', label: '全部'));
  for (var i in location) {
    dropdownMenuEntries.add(DropdownMenuEntry<String>(value: i, label: i));
  }
  return dropdownMenuEntries;
}
