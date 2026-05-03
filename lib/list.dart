import 'package:flutter/material.dart';

// 流派
Widget buildGenreDropdownMenu({
  String? initialSelection,
  ValueChanged<String?>? onSelected,
}) {
  return DropdownMenu<String>(
    initialSelection: initialSelection ?? '分类',
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
