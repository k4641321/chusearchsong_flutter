import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:path_provider/path_provider.dart';

class Generateimage extends StatefulWidget {
  const Generateimage({super.key});

  @override
  State<Generateimage> createState() => _GenerateimageState();
}

class _GenerateimageState extends State<Generateimage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _globalKey = GlobalKey();

  bool readWarning = false;
  int row = 5;
  int column = 5;
  List tablecontent = [];
  List<Widget> table = [];
  List tablecontentColors = [];
  List tablecontentFontSize = [];
  List tablecontentBackground = [];
  double containerWidth = 100;
  double containerHeight = 100;
  double paddingLeft = 5;
  double paddingTop = 5;
  double paddingRight = 5;
  double paddingBottom = 5;
  double borderWidth = 1;
  String title = '中二节奏Bingo';
  String subtitle = '连成一条线证明你是资深中二玩家!';
  String tabulator = '制表人：';
  String formfiller = '填表人：';
  List titleColorList = [
    Colors.black.toARGB32(),
    Colors.black.toARGB32(),
    Colors.black.toARGB32(),
    Colors.black.toARGB32(),
  ];

  Future<ui.Image?> captureWidget(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    return await boundary.toImage(pixelRatio: 1.0);
  }

  Future<void> _update() async {
    try {
      if (readWarning == false && row >= 100 || column >= 100) {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('警告'),
            content: const Text('数值过大，卡死我不负责，点 取消 还能反悔'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('确定'),
              ),
            ],
          ),
        );
        if (result != true) return;
        if (result == true) readWarning = true;
      }
      // tablecontent.clear();
      List<Widget> table2 = [];
      List<Widget> result = [];
      int oldtablecontentlength = tablecontent.length;

      if (row == 0 || column == 0) return;
      if (tablecontent.length < row * column) {
        for (var i = 0; i < row * column - oldtablecontentlength; i++) {
          tablecontent.add(i);
          tablecontentColors.add(Colors.black.toARGB32());
          tablecontentFontSize.add(18);
          tablecontentBackground.add(Colors.white.toARGB32());
        }
      }
      for (var i = 0; i < row * column + 1; i++) {
        final idx = i;
        if (idx == 0) {
          table2.add(
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(titleColorList[0]),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Color(titleColorList[1])),
                    ),
                  ],
                ),
                SizedBox(width: 15),
                Column(
                  children: [
                    Text(
                      tabulator,
                      style: TextStyle(
                        // fontSize: 25,
                        // fontWeight: FontWeight.bold,
                        color: Color(titleColorList[2]),
                      ),
                    ),
                    Text(
                      formfiller,
                      style: TextStyle(color: Color(titleColorList[3])),
                    ),
                  ],
                ),
              ],
            ),
          );
          continue;
        }
        result.add(
          InkWell(
            onTap: () async {
              try {
                int colorint = tablecontentColors[idx - 1];
                double fontsize = tablecontentFontSize[idx - 1].toDouble();
                int backgroundcolor = tablecontentBackground[idx - 1];
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    scrollable: true,
                    title: Text('输入内容'),
                    content: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: tablecontent[idx - 1].toString(),
                                autofocus: true,
                                maxLines: null,
                                onChanged: (v) =>
                                    tablecontent[idx - 1] = v, // 边输入边记录
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('字体大小'),
                            Expanded(
                              child: TextFormField(
                                initialValue: tablecontentFontSize[idx - 1]
                                    .toString(),
                                onChanged: (value) {
                                  if (double.tryParse(value) != null) {
                                    fontsize = double.parse(value);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('字体颜色：'),
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      scrollable: true,
                                      title: Text('选择颜色'),
                                      content: ColorPicker(
                                        pickerColor: Color(colorint),
                                        onColorChanged: (value) =>
                                            colorint = value.toARGB32(),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            return;
                                          },
                                          child: Text('取消'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // tablecontent[i] = 'test';
                                            Navigator.of(context).pop();

                                            // _update();
                                          },
                                          child: Text('确定'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: SweepGradient(
                                      colors: [
                                        Colors.red,
                                        Colors.orange,
                                        Colors.yellow,
                                        Colors.green,
                                        Colors.cyan,
                                        Colors.blue,
                                        Colors.purple,
                                        Colors.pink,
                                      ],
                                    ),
                                  ),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('背景颜色：'),
                            ClipRRect(
                              borderRadius: BorderRadiusGeometry.all(
                                Radius.circular(15),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      scrollable: true,
                                      title: Text('选择颜色'),
                                      content: ColorPicker(
                                        pickerColor: Color(backgroundcolor),
                                        onColorChanged: (value) =>
                                            backgroundcolor = value.toARGB32(),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            return;
                                          },
                                          child: Text('取消'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // tablecontent[i] = 'test';
                                            Navigator.of(context).pop();

                                            // _update();
                                          },
                                          child: Text('确定'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: SweepGradient(
                                      colors: [
                                        Colors.red,
                                        Colors.orange,
                                        Colors.yellow,
                                        Colors.green,
                                        Colors.cyan,
                                        Colors.blue,
                                        Colors.purple,
                                        Colors.pink,
                                      ],
                                    ),
                                  ),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          return;
                        },
                        child: Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          // tablecontent[i] = 'test';
                          tablecontentColors[idx - 1] = colorint;
                          tablecontentFontSize[idx - 1] = fontsize;
                          tablecontentBackground[idx - 1] = backgroundcolor;
                          Navigator.of(context).pop();
                          _update();
                        },
                        child: Text('确定'),
                      ),
                    ],
                  ),
                );
                await _update();
              } catch (e, s) {
                log('$e\n$s');
                if (!mounted) return;
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('错误 $e\n$s')));
                return;
              }
            },
            child: Container(
              width: containerWidth,
              height: containerHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: borderWidth),
                color: Color(tablecontentBackground[idx - 1]),
              ),
              child: Center(
                child: Text(
                  (tablecontent[idx - 1]).toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(tablecontentColors[idx - 1]),
                    fontSize: tablecontentFontSize[idx - 1].toDouble(),
                  ),
                ),
              ),
            ),
          ),
        );
        if (i % row == 0) {
          table2.add(Row(children: result));
          result = [];
        }
      }

      setState(() {
        table = table2;
      });
    } catch (e, s) {
      log('$e\n$s');
      setState(() {
        table = [Text('错误：$e\n$s')];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('图片生成')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(
                height: 500,
                child: InteractiveViewer(
                  maxScale: 3.0,
                  minScale: 0.1,
                  boundaryMargin: EdgeInsets.all(double.infinity),
                  constrained: false,
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsetsGeometry.only(
                          left: paddingLeft,
                          right: paddingRight,
                          bottom: paddingBottom,
                          top: paddingTop,
                        ),
                        child: Column(children: table),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Text(
                '设置',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _update(),
                      child: Text('更新图片'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        final children = [
                          _buildSelectWidget(
                            context,
                            '字体大小',
                            tablecontentFontSize,
                            _update,
                          ),
                          _buildColorSelectWidget(
                            context,
                            '字体颜色',
                            tablecontentColors,
                            _update,
                          ),
                          _buildColorSelectWidget(
                            context,
                            '背景颜色',
                            tablecontentBackground,
                            _update,
                          ),
                        ];
                        showDialog(
                          context: context,
                          builder: (context) =>
                              SimpleDialog(children: children),
                        );
                      },

                      child: Text('一键设置'),
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        try {
                          if (kIsWeb) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('网页不支持分享')));
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (context) => SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(),
                            ),
                          );
                          final image = await captureWidget(_globalKey);
                          final byteData = await image?.toByteData(
                            format: .png,
                          );
                          final pngBytes = byteData?.buffer.asUint8List();
                          if (pngBytes == null) return;
                          final path = await getApplicationSupportDirectory();
                          if (!Directory('${path.path}/tmp').existsSync()) {
                            Directory(
                              '${path.path}/tmp',
                            ).createSync(recursive: true);
                          }
                          File(
                            '${path.path}/tmp/bingo.png',
                          ).writeAsBytesSync(pngBytes);
                          if (!context.mounted) return;
                          await FilePicker.saveFile(
                            dialogTitle: '保存Bingo',
                            fileName: 'bingo.png',
                            bytes: pngBytes,
                            type: FileType.custom,
                            allowedExtensions: ['png'],
                          );
                          if (!context.mounted) return;
                          Navigator.pop(context);
                        } catch (e, s) {
                          log('$e\n$s');
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('错误：$e\n$s')));
                          Navigator.pop(context);
                        }
                      },
                      child: Text('保存图片'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('标题'),
                  Expanded(
                    child: TextFormField(
                      initialValue: title,
                      onChanged: (value) {
                        title = value;
                        _update();
                      },
                    ),
                  ),
                  _buildTitleColorPicker(
                    context,
                    () => _update(),
                    titleColorList,
                    0,
                  ),
                  Text('副标题'),
                  Expanded(
                    child: TextFormField(
                      initialValue: subtitle,
                      onChanged: (value) {
                        subtitle = value;
                        _update();
                      },
                    ),
                  ),
                  _buildTitleColorPicker(
                    context,
                    () => _update(),
                    titleColorList,
                    1,
                  ),
                ],
              ),
              Row(
                children: [
                  Text('填表人'),
                  Expanded(
                    child: TextFormField(
                      initialValue: tabulator,
                      onChanged: (value) {
                        tabulator = value;
                        _update();
                      },
                    ),
                  ),
                  _buildTitleColorPicker(
                    context,
                    () => _update(),
                    titleColorList,
                    2,
                  ),
                  Text('制表人'),
                  Expanded(
                    child: TextFormField(
                      initialValue: formfiller,
                      onChanged: (value) {
                        formfiller = value;
                        _update();
                      },
                    ),
                  ),
                  _buildTitleColorPicker(
                    context,
                    () => _update(),
                    titleColorList,
                    3,
                  ),
                ],
              ),
              Row(
                children: [
                  Text('表格宽（格）'),
                  Expanded(
                    child: TextFormField(
                      initialValue: row.toString(),
                      onChanged: (value) {
                        if (int.tryParse(value) != null) {
                          row = int.parse(value);
                        }
                        _update();
                      },
                    ),
                  ),
                  Text('表格高（格）'),
                  Expanded(
                    child: TextFormField(
                      initialValue: column.toString(),
                      onChanged: (value) {
                        if (int.tryParse(value) != null) {
                          column = int.parse(value);
                        }
                        _update();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('格子宽'),
                  Expanded(
                    child: TextFormField(
                      initialValue: containerWidth.toString(),
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          containerWidth = double.parse(value);
                        }
                        _update();
                      },
                    ),
                  ),
                  Text('格子高'),
                  Expanded(
                    child: TextFormField(
                      initialValue: containerHeight.toString(),
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          containerHeight = double.parse(value);
                        }
                        _update();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('左边距'),
                  Expanded(
                    child: TextFormField(
                      initialValue: paddingLeft.toString(),
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          paddingLeft = double.parse(value);
                        }
                        _update();
                      },
                    ),
                  ),
                  Text('右边距'),
                  Expanded(
                    child: TextFormField(
                      initialValue: paddingRight.toString(),
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          paddingRight = double.parse(value);
                        }
                        _update();
                      },
                    ),
                  ),
                  Text('上边距'),
                  Expanded(
                    child: TextFormField(
                      initialValue: paddingTop.toString(),
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          paddingTop = double.parse(value);
                        }
                        _update();
                      },
                    ),
                  ),
                  Text('下边距'),
                  Expanded(
                    child: TextFormField(
                      initialValue: paddingBottom.toString(),
                      onChanged: (value) {
                        if (double.tryParse(value) != null) {
                          paddingBottom = double.parse(value);
                        }
                        _update();
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        try {
                          final result = await FilePicker.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['json'],
                            withData: true,
                          );
                          if (result == null || result.files.isEmpty) return;

                          final Uint8List? bytes = result.files.first.bytes;
                          if (bytes == null) return;
                          final String content = utf8.decode(bytes);
                          final Map<String, dynamic> data =
                              jsonDecode(content) as Map<String, dynamic>;

                          setState(() {
                            // 文本
                            title = data['title'] as String? ?? title;
                            subtitle = data['subtitle'] as String? ?? subtitle;
                            tabulator =
                                data['tabulator'] as String? ?? tabulator;
                            formfiller =
                                data['formfiller'] as String? ?? formfiller;

                            // 四个标题颜色
                            titleColorList[0] =
                                data['titleColor'] as int? ?? titleColorList[0];
                            titleColorList[1] =
                                data['formfillerColor'] as int? ??
                                titleColorList[1];
                            titleColorList[2] =
                                data['tabulatorColor'] as int? ??
                                titleColorList[2];
                            titleColorList[3] =
                                data['subtitleColor'] as int? ??
                                titleColorList[3];

                            // 列表
                            tablecontent =
                                data['tablecontent'] as List? ?? tablecontent;
                            tablecontentColors =
                                data['tablecontentColors'] as List? ??
                                tablecontentColors;
                            tablecontentBackground =
                                data['tablecontentBackground'] as List? ??
                                tablecontentBackground;
                            tablecontentFontSize =
                                data['tablecontentFontSize'] as List? ??
                                tablecontentFontSize;

                            // 尺寸（double）
                            paddingLeft =
                                (data['paddingLeft'] as num?)?.toDouble() ??
                                paddingLeft;
                            paddingRight =
                                (data['paddingRight'] as num?)?.toDouble() ??
                                paddingRight;
                            paddingTop =
                                (data['paddingTop'] as num?)?.toDouble() ??
                                paddingTop;
                            paddingBottom =
                                (data['paddingBottom'] as num?)?.toDouble() ??
                                paddingBottom;
                            containerWidth =
                                (data['containerWidth'] as num?)?.toDouble() ??
                                containerWidth;
                            containerHeight =
                                (data['containerHeight'] as num?)?.toDouble() ??
                                containerHeight;

                            // 行列（int）
                            row = (data['row'] as num?)?.toInt() ?? row;
                            column =
                                (data['column'] as num?)?.toInt() ?? column;
                          });

                          if (!mounted) return;
                          await _update();
                        } catch (e, s) {
                          log('$e\n$s');
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('错误，可能文件格式不正确')),
                          );
                        }
                      },
                      child: Text('导入配置'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        Map<String, dynamic> data = {
                          "title": title,
                          "titleColor": titleColorList[0],
                          "formfiller": formfiller,
                          "formfillerColor": titleColorList[1],
                          "tabulator": tabulator,
                          "tabulatorColor": titleColorList[2],
                          "subtitle": subtitle,
                          "subtitleColor": titleColorList[3],
                          "tablecontent": tablecontent,
                          "tablecontentColors": tablecontentColors,
                          "tablecontentBackground": tablecontentBackground,
                          "tablecontentFontSize": tablecontentFontSize,

                          "paddingLeft": paddingLeft,
                          "paddingRight": paddingRight,
                          "paddingTop": paddingTop,
                          "paddingBottom": paddingBottom,

                          "containerWidth": containerWidth,
                          "containerHeight": containerHeight,

                          "row": row,
                          "column": column,
                        };
                        await FilePicker.saveFile(
                          dialogTitle: '保存配置',
                          fileName: 'BingoConfig.json',
                          type: FileType.custom,
                          allowedExtensions: ['json'],
                          bytes: Utf8Encoder().convert(jsonEncode(data)),
                        );
                      },
                      child: Text('导出配置'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildTitleColorPicker(
  BuildContext context,
  Function update,
  List titleColorList,
  int index,
) {
  return ClipRRect(
    borderRadius: BorderRadiusGeometry.all(Radius.circular(15)),
    child: InkWell(
      onTap: () async {
        int colorint = Colors.black.toARGB32();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            scrollable: true,
            title: Text('选择颜色'),
            content: ColorPicker(
              pickerColor: Color(colorint),
              onColorChanged: (value) => colorint = value.toARGB32(),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  return;
                },
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  // tablecontent[i] = 'test';
                  Navigator.of(context).pop();
                  titleColorList[index] = colorint;
                  update();
                },
                child: Text('确定'),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: SweepGradient(
            colors: [
              Colors.red,
              Colors.orange,
              Colors.yellow,
              Colors.green,
              Colors.cyan,
              Colors.blue,
              Colors.purple,
              Colors.pink,
            ],
          ),
        ),
        height: 40,
        width: 40,
      ),
    ),
  );
}

Widget _buildSelectWidget(
  BuildContext context,
  String type,
  List targetList, // 要批量修改的列表
  Function update,
) {
  return ListTile(
    title: Text(type),
    trailing: const Icon(Icons.chevron_right),
    onTap: () async {
      double value = 18;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Text('设置$type'),
          content: TextFormField(
            initialValue: '18',
            onChanged: (v) {
              if (double.tryParse(v) != null) {
                value = double.parse(v);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                for (int i = 0; i < targetList.length; i++) {
                  targetList[i] = value;
                }
                Navigator.pop(context);
                Navigator.pop(context);
                update();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildColorSelectWidget(
  BuildContext context,
  String type,
  List targetList,
  Function update,
) {
  return ListTile(
    title: Text(type),
    onTap: () async {
      int color = Colors.black.toARGB32();
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          scrollable: true,
          title: Text('设置$type'),
          content: ColorPicker(
            pickerColor: Color(color),
            onColorChanged: (v) => color = v.toARGB32(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                for (int i = 0; i < targetList.length; i++) {
                  targetList[i] = color;
                }
                Navigator.pop(context);
                Navigator.pop(context);
                update();
              },
              child: const Text('确定'),
            ),
          ],
        ),
      );
    },
  );
}
