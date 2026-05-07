import 'package:flutter/material.dart';

// 流派
Widget buildGenreDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    menuHeight: 300.0,
    initialSelection: initialSelection ?? '-1',
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: const [
      DropdownMenuEntry<String>(label: '分类', value: '-1'),
      DropdownMenuEntry<String>(label: '流行 & 动漫', value: '0'),
      DropdownMenuEntry<String>(label: 'niconico', value: '2'),
      DropdownMenuEntry<String>(label: '东方Project', value: '3'),
      DropdownMenuEntry<String>(label: '原创', value: '5'),
      DropdownMenuEntry<String>(label: '其他游戏', value: '6'),
      DropdownMenuEntry<String>(label: '彩绿', value: '7'),
      DropdownMenuEntry<String>(label: '音击舞萌', value: '9'),
    ],
  );
}

// 版本
Widget buildVersionDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    menuHeight: 300.0,
    initialSelection: initialSelection ?? '-1',
    selectOnly: true,
    onSelected: onSelected,
    dropdownMenuEntries: const [
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
    ],
  );
}

// 难度下限
Widget buildDifficultyDownDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    menuHeight: 300.0,
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
            style: TextStyle(color: const Color.fromARGB(255, 251, 255, 0)),
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
