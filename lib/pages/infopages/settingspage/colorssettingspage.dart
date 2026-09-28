import 'dart:io';

import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class Colorssettingspage extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const Colorssettingspage({super.key, required this.onBackPressed});

  @override
  State<Colorssettingspage> createState() => _ColorssettingspageState();
}

class _ColorssettingspageState extends State<Colorssettingspage> {
  bool dynamicColor = true;
  final ScrollController _scrollController = ScrollController();

  /// 开关类菜单项
  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isFirst,
    required bool isLast,
  }) {
    final borderRadius = BorderRadius.vertical(
      top: isFirst ? const Radius.circular(15) : Radius.zero,
      bottom: isLast ? const Radius.circular(15) : Radius.zero,
    );

    return Material(
      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(120),
      borderRadius: borderRadius,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        child: SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: Icon(icon, size: 28),
          title: Text(title, style: const TextStyle(fontSize: 16)),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          value: value,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 0,
      indent: 58,
      color: Theme.of(context).colorScheme.onSurface.withAlpha(30),
    );
  }

  Widget _buildColorPicker(Color color) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
      child: InkWell(
        onTap: () async {
          Map<String, dynamic> config = await (await ReadData.create())
              .readConfig();
          config['themeColor'] = color.toARGB32();
          (await WriteData.create()).writeConfig(config);
          widget.onBackPressed!();
        },

        child: Stack(
          children: [Container(color: color, height: 40, width: 40)],
        ),
      ),
    );
  }

  Future<void> init() async {
    Map<String, dynamic> config = await (await ReadData.create()).readConfig();
    setState(() {
      dynamicColor = config['enableDynamicColor'] ?? true;
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('颜色设置')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
            child: Column(
              children: [
                Text('颜色预览'),
                SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(15),
                        child: Text('primary'),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.secondary,
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(15),
                        child: Text('secondary'),
                      ),
                    ),
                    Container(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(15),
                        child: Text('primaryContainer'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('主题色'),
                SizedBox(height: 10),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: [
                    _buildColorPicker(Colors.red),
                    _buildColorPicker(Colors.orange),
                    _buildColorPicker(Colors.yellow),
                    _buildColorPicker(Colors.green),
                    _buildColorPicker(Colors.cyan),
                    _buildColorPicker(Colors.blue),
                    _buildColorPicker(Colors.purple),
                    _buildColorPicker(Colors.pink),
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () async {
                          Color color = Colors.red;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('选择颜色'),
                              content: ColorPicker(
                                pickerColor: color,
                                onColorChanged: (value) {
                                  color = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('取消'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Map<String, dynamic> config =
                                        await (await ReadData.create())
                                            .readConfig();
                                    config['themeColor'] = color.toARGB32();
                                    (await WriteData.create()).writeConfig(
                                      config,
                                    );
                                    widget.onBackPressed!();
                                    if (!context.mounted) return;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('确定'),
                                ),
                              ],
                            ),
                          );
                        },

                        child: Stack(
                          children: [
                            Container(
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
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Text('背景图片'),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          if (kIsWeb) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('网页不支持')));
                            return;
                          }
                          final chooseImage = await FilePicker.pickFiles(
                            dialogTitle: '选择背景图片',
                            type: FileType.image,
                            withData: true,
                          );
                          if (chooseImage != null &&
                              chooseImage.files.first.bytes != null) {
                            if (!context.mounted) return;
                            showDialog(
                              context: context,
                              builder: (context) {
                                double aplha = 255;
                                return StatefulBuilder(
                                  builder: (context, setDialogState) {
                                    return AlertDialog(
                                      title: Text('预览'),
                                      content: Column(
                                        children: [
                                          Image.memory(
                                            color: Colors.white.withAlpha(
                                              aplha.toInt(),
                                            ),
                                            colorBlendMode: BlendMode.dstATop,
                                            chooseImage.files.first.bytes!,
                                          ),
                                          Slider(
                                            value: aplha,
                                            min: 0,
                                            max: 255,
                                            onChanged: (value) {
                                              setDialogState(
                                                () => aplha = value,
                                              ); // ← 用对话框自己的 setState
                                            },
                                          ),
                                          Text('$aplha'),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('取消'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Map<String, dynamic> config =
                                                await (await ReadData.create())
                                                    .readConfig();
                                            if (!config.containsKey(
                                              'BackgroundSettings',
                                            )) {
                                              config['BackgroundSettings'] = {};
                                            }
                                            config['BackgroundSettings']['Aplha'] =
                                                aplha.toInt();
                                            (await WriteData.create())
                                                .writeConfig(config);
                                            final path =
                                                await getApplicationSupportDirectory();
                                            if (!Directory(
                                              '${path.path}/background',
                                            ).existsSync()) {
                                              Directory(
                                                '${path.path}/background',
                                              ).create();
                                            }
                                            await File(
                                              '${path.path}/background/background.png',
                                            ).writeAsBytes(
                                              chooseImage.files.first.bytes!,
                                            );
                                            if (!context.mounted) return;

                                            Navigator.of(context).pop();
                                            widget.onBackPressed!();
                                          },
                                          child: Text('确定'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          }
                        },
                        child: Text('选择背景图片'),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          if (kIsWeb) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text('网页不支持')));
                            return;
                          }
                          final path = await getApplicationSupportDirectory();
                          if (!Directory(
                            '${path.path}/background',
                          ).existsSync()) {
                            Directory('${path.path}/background').create();
                          }
                          if (File(
                            '${path.path}/background/background.png',
                          ).existsSync()) {
                            await File(
                              '${path.path}/background/background.png',
                            ).delete();
                          }
                          widget.onBackPressed!();
                        },
                        child: Text('清除背景图片'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                _buildSwitchItem(
                  icon: Icons.palette,
                  title: '动态配色',
                  subtitle: '是否启用动态配色',
                  value: dynamicColor,
                  onChanged: (value) async {
                    Map<String, dynamic> config =
                        await (await ReadData.create()).readConfig();
                    config['enableDynamicColor'] = value;
                    (await WriteData.create()).writeConfig(config);
                    setState(() {
                      dynamicColor = value;
                      widget.onBackPressed!();
                    });
                  },
                  isFirst: true,
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
