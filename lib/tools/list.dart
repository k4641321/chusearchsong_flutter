import 'dart:developer';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//加载歌曲数据
Future<Map<String, dynamic>> loadSongs() async {
  final directory = await getApplicationSupportDirectory();
  final file = File('${directory.path}/res/songs.json');
  final json = jsonDecode(await file.readAsString());
  return json;
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
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    menuHeight: 300.0,
    width: double.infinity,
    initialSelection: initialSelection ?? '-1',
    selectOnly: false,
    onSelected: onSelected,
    dropdownMenuEntries: const [
      DropdownMenuEntry<String>(label: '难度下限', value: '-1'),
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
      DropdownMenuEntry<String>(label: '难度上限', value: '-1'),
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
        DataCell(Text('990000~99999')),
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
        DataCell(Text('975000~98999')),
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
        DataCell(Text('000000~549999')),
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
        DataCell(
          Text(
            '绿',
            style: TextStyle(color: const Color.fromARGB(255, 0, 110, 9)),
          ),
        ),
        DataCell(Text('0.00~3.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '橙',
            style: TextStyle(color: const Color.fromARGB(255, 255, 136, 0)),
          ),
        ),
        DataCell(Text('4.00~6.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '红',
            style: TextStyle(color: const Color.fromARGB(255, 255, 0, 0)),
          ),
        ),
        DataCell(Text('7.00~9.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '紫',
            style: TextStyle(color: const Color.fromARGB(255, 95, 0, 95)),
          ),
        ),
        DataCell(Text('10.00~11.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '铜',
            style: TextStyle(color: const Color.fromARGB(255, 255, 123, 0)),
          ),
        ),
        DataCell(Text('12.00~13.24')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '银',
            style: TextStyle(color: const Color.fromARGB(255, 189, 189, 189)),
          ),
        ),
        DataCell(Text('13.25~14.49')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '金',
            style: TextStyle(color: const Color.fromARGB(255, 255, 217, 0)),
          ),
        ),
        DataCell(Text('14.50~15.24')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '铂金',
            style: TextStyle(color: const Color.fromARGB(255, 255, 230, 0)),
          ),
        ),
        DataCell(Text('15.25~15.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '彩虹',
            style: TextStyle(color: const Color.fromARGB(255, 204, 0, 255)),
          ),
        ),
        DataCell(Text('16.00~16.99')),
      ],
    ),
    DataRow(
      cells: [
        DataCell(
          Text(
            '彩虹(极)',
            style: TextStyle(color: const Color.fromARGB(255, 255, 0, 234)),
          ),
        ),
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
        DataCell(Text('${diff + 2.15}')),
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
        DataCell(Text('${diff + 2.0 + 0.1}')),
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
        DataCell(Text('${diff + 2.0 + 0.05}')),
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
        DataCell(Text('${diff + 2.0 + 0.02}')),
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
        DataCell(Text('${diff + 2.0}')),
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
        DataCell(Text('${diff + 1.5 + 0.4}')),
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
        DataCell(Text('${diff + 1.5 + 0.2}')),
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
        DataCell(Text('${diff + 1.5}')),
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
        DataCell(Text('${diff + 1.0 + 0.03}')),
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
        DataCell(Text('${diff + 1.0 + 0.01}')),
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
        DataCell(Text('${diff + 1.0}')),
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
        DataCell(Text('${diff + 0.9}')),
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
        DataCell(Text('${diff + 0.8}')),
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
        DataCell(Text('${diff + 0.7}')),
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
        DataCell(Text('${diff + 0.6}')),
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
        DataCell(Text('${diff + 0.4}')),
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
        DataCell(Text('${diff + 0.2}')),
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
        DataCell(Text('${diff + 0.0}')),
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
