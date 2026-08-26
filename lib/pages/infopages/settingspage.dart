import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chusearchsong_flutter/function/infopagefun/settingspagefun.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'settingspage/lxnssettingspage.dart';
import 'settingspage/texttranslatesettingspage.dart';
import 'settingspage/mapsettingspage.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onThemeChanged;

  const SettingsPage({super.key, this.onThemeChanged});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ScrollController _scrollController = ScrollController();
  bool chartproxy = false;
  bool autocheckupdate = false;
  String darkmode = 'light';

  Future<void> darkmodechange() async {
    final path = await getApplicationSupportDirectory();
    final config = File('${path.path}/config.json');
    final configStr = config.readAsStringSync();
    final configJson = json.decode(configStr);
    if (darkmode == 'light') {
      darkmode = 'dark';
      try {
        configJson['theme'] = 'dark';
        config.writeAsStringSync(json.encode(configJson));
      } catch (e) {
        log('$e', name: 'infopage', level: 500);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('切换失败')));
      }
    } else if (darkmode == 'dark') {
      darkmode = 'light';
      try {
        configJson['theme'] = 'light';
        config.writeAsStringSync(json.encode(configJson));
      } catch (e) {
        log('$e', name: 'infopage', level: 500);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('切换失败')));
      }
    }
    if (!mounted) return;
    setState(() {});
    widget.onThemeChanged?.call();
  }

  Future<void> confirmdarkmode() async {
    final path = await getApplicationSupportDirectory();
    try {
      String configStr = await File('${path.path}/config.json').readAsString();
      Map<String, dynamic> config = json.decode(configStr);
      if (config['theme'] == 'light') {
        darkmode = 'light';
      } else if (config['theme'] == 'dark') {
        darkmode = 'dark';
      }
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误，配置文件不存在')));
    }
  }

  Future<void> init() async {
    try {
      final path = await getApplicationSupportDirectory();
      Map<String, dynamic> config = jsonDecode(
        await File('${path.path}/config.json').readAsString(),
      );
      setState(() {
        chartproxy = config['chartproxy'];
        if (!config.containsKey('autocheckupdate')) {
          return;
        } else {
          autocheckupdate = config['autocheckupdate'];
        }
      });
    } catch (e, strack) {
      log('$e\n$strack', name: 'settingspage.dart', level: 1000);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误：$e\$strack')));
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    confirmdarkmode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer.withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(
                                      right: 10,
                                      left: 5,
                                    ),
                                    child: Icon(Icons.translate, size: 35),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '翻译设置',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '配置腾讯机器翻译参数',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TextTranslateSettingsPage(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer.withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(
                                      right: 10,
                                      left: 5,
                                    ),
                                    child: Icon(Icons.token, size: 35),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '落雪设置',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '配置落雪Token',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LxnsSettingsPage(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer.withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(left: 10),
                                    child: Icon(Icons.vpn_key, size: 35),
                                  ),
                                  Expanded(
                                    child: SwitchListTile(
                                      title: Text('谱面预览加速（实验性'),
                                      subtitle: Text('vercel过来的我不确定彳亍不彳亍'),
                                      value: chartproxy,
                                      onChanged: (value) async {
                                        try {
                                          setState(() => chartproxy = value);
                                          await changeChartProxy(
                                            state: chartproxy,
                                          );
                                        } catch (e, strack) {
                                          log('$e\n$strack');
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('错误：$e\n$strack'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer.withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(5),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(left: 10),
                                    child: Icon(
                                      Icons.update_outlined,
                                      size: 35,
                                    ),
                                  ),
                                  Expanded(
                                    child: SwitchListTile(
                                      title: Text('自动检查更新'),
                                      subtitle: Text('启动时是否自动检查更新'),
                                      value: autocheckupdate,
                                      onChanged: (value) async {
                                        try {
                                          setState(
                                            () => autocheckupdate = value,
                                          );
                                          final path =
                                              await getApplicationSupportDirectory();
                                          Map<String, dynamic> config =
                                              jsonDecode(
                                                await File(
                                                  '${path.path}/config.json',
                                                ).readAsString(),
                                              );
                                          config['autocheckupdate'] =
                                              autocheckupdate;
                                          await File(
                                            '${path.path}/config.json',
                                          ).writeAsString(jsonEncode(config));
                                        } catch (e, strack) {
                                          log('$e\n$strack');
                                          if (!context.mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text('错误：$e\n$strack'),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: darkmodechange,
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer.withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(
                                      right: 10,
                                      left: 5,
                                    ),
                                    child: Icon(Icons.brightness_4, size: 35),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '主题模式',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '切换主题模式,当前为：$darkmode',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Card(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer.withAlpha(150),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsetsGeometry.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(
                                      right: 10,
                                      left: 5,
                                    ),
                                    child: Icon(Icons.map, size: 35),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '地图设置',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '设置首选地图',
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MapSettingsPage(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
