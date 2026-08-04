import 'dart:developer';

import 'package:chusearchsong_flutter/function/infopagefun/infopagefun.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/homepages/infopage.dart';
import 'pages/homepages/searchpage.dart';
import 'pages/homepages/favoritepage.dart';
import 'pages/homepages/toolspage.dart';
import 'function/fun.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:dynamic_color/dynamic_color.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  Future<void> _loadTheme() async {
    final path = await getApplicationSupportDirectory();
    final file = File('${path.path}/config.json');
    if (await file.exists()) {
      String configStr = await file.readAsString();
      Map<String, dynamic> config = await json.decode(configStr);
      setState(() {
        _themeMode = config['theme'] == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light;
      });
    }
  }

  void _handleThemeChanged() {
    _loadTheme();
  }

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          builder: (context, child) {
            return SafeArea(top: false, bottom: true, child: child!);
          },
          title: 'chusearchsong',
          theme: ThemeData(
            colorScheme: lightDynamic ?? lightTheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic ?? darkTheme,
            useMaterial3: true,
          ),
          themeMode: _themeMode,
          home: MyHomePage(handleThemeChanged: _handleThemeChanged),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  final VoidCallback? handleThemeChanged;

  const MyHomePage({super.key, required this.handleThemeChanged});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> postusecount() async {
    try {
      String result = await requestuscount();
      log(result);
    } catch (e, strack) {
      log('$e\n$strack');
    }
  }

  Future<void> showannouncement() async {
    try {
      Map<String, dynamic> config = await loadConfig();
      List announcement = jsonDecode(await requestAnnouncement());
      config['announcement']['value'] ?? 0;
      if (config['announcement']['value'] < announcement[0]['value']) {
        log('有新的公告');
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(announcement[0]['title']),
            content: Text(announcement[0]['content']),
          ),
        );
        config['announcement']['date'] = announcement[0]['date'];
        config['announcement']['value'] = announcement[0]['value'];
        config['announcement']['read'] = true;
        saveConfig(config);
      } else {
        log('没有新的公告');
      }
    } catch (e, strack) {
      log('$e\n$strack');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误$e\n$strack')));
    }
  }

  Future<void> chechupdate() async {
    try {
      Map<String, dynamic> config = await loadConfig();
      if (!config.containsKey('autocheckupdate')) {
        log('跳过更新检查');
        return;
      }
      if (config['autocheckupdate'] == true) {
        bool result = await checkforupdates();
        if (result) {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('发现新版本，是否前往下载？'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('取消'),
                ),
                TextButton(
                  onPressed: () async {
                    // 执行操作
                    Navigator.of(context).pop();
                    await lanuchdownload(context: context);
                  },
                  child: Text('确认'),
                ),
              ],
            ),
          );
        }
      } else {
        return;
      }
    } catch (e, strack) {
      log('$e\n$strack');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误$e\n$strack')));
    }
  }

  Future<void> showChangesLog() async {
    try {
      final ScrollController controller = ScrollController();
      final packageinfo = await PackageInfo.fromPlatform();
      Map<String, dynamic> config = await loadConfig();
      if (config['version'] == packageinfo.version &&
          config['changeslogread'] == false) {
        List requestresult = jsonDecode(await requestChangeslog());
        Map<String, dynamic> changeslog = requestresult[0];
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              '${changeslog['title']} - ${changeslog['description']}',
            ),
            content: SizedBox(
              height: MediaQuery.heightOf(context) * 0.7,
              child: Scrollbar(
                controller: controller,
                child: SingleChildScrollView(
                  controller: controller,
                  child: Text(
                    (changeslog['changes'] as List).join('\n').toString(),
                  ),
                ),
              ),
            ),
          ),
        );
        config['changeslogread'] = true;
        saveConfig(config);
      }
    } catch (e, strack) {
      log('$e\n$strack');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('错误：$e\n$strack')));
    }
  }

  @override
  void initState() {
    super.initState();
    // postusecount();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ifres(context: context);
      showChangesLog();
      chechupdate();
      showannouncement();
    });
  }

  String title = '搜索';
  int _currentIndex = 0;
  // Widget infopagebox =
  Widget searchpagebox = SearchPage();
  Widget favoritepagebox = FavoritePage();
  Widget toolspagebox = ToolPage();
  List<Widget> get _pages => [
    searchpagebox,
    favoritepagebox,
    toolspagebox,
    // infopagebox,
    Info(onThemeChanged: widget.handleThemeChanged),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 0) {
              title = '搜索';
            } else if (index == 1) {
              title = '收藏';
            } else if (index == 2) {
              title = '工具';
            } else if (index == 3) {
              title = '关于';
            }
          });
        },
        unselectedItemColor: Theme.of(context).colorScheme.secondary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '收藏'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: '工具'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: '关于'),
        ],
      ),
    );
  }
}
