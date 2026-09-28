import 'dart:developer';
import 'dart:io';
import 'package:chusearchsong_flutter/function/infopagefun/infopagefun.dart';
import 'package:chusearchsong_flutter/function/request.dart';
import 'package:chusearchsong_flutter/function/writeandreadfun.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'function/commonfun.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/homepages/infopage.dart';
import 'pages/homepages/searchpage.dart';
import 'pages/homepages/favoritepage.dart';
import 'pages/homepages/toolspage.dart';
import 'dart:convert';
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
  /// 浅色主题 - 以黄色为主色调
  ColorScheme lightTheme = ColorScheme.fromSeed(
    seedColor: Colors.amber,
    brightness: Brightness.light,
  );

  /// 深色主题 - 以黄色为主色调
  ColorScheme darkTheme = ColorScheme.fromSeed(
    seedColor: Colors.amber,
    brightness: Brightness.dark,
  );

  ThemeMode _themeMode = ThemeMode.light;
  bool _useDynamicColor = true;
  int aplha = 255;
  String? _backgroundPath;

  Future<void> _loadTheme() async {
    try {
      Map<String, dynamic> config = await (await ReadData.create())
          .readConfig();
      if (!kIsWeb) {
        final path = await getApplicationSupportDirectory();
        if (!Directory('${path.path}/background').existsSync()) {
          Directory('${path.path}/background').create();
        }
        _backgroundPath = null;
        if (File('${path.path}/background/background.png').existsSync()) {
          _backgroundPath = '${path.path}/background/background.png';
        }
      }
      setState(() {
        _themeMode = config['theme'] == 'dark'
            ? ThemeMode.dark
            : ThemeMode.light;
        _useDynamicColor = config['enableDynamicColor'] ?? true;
        lightTheme = ColorScheme.fromSeed(
          seedColor: Color(config['themeColor'] ?? Colors.amber),
          brightness: Brightness.light,
        );
        darkTheme = ColorScheme.fromSeed(
          seedColor: Color(config['themeColor'] ?? Colors.amber),
          brightness: Brightness.dark,
        );
        if (config.containsKey('BackgroundSettings')) {
          if ((config['BackgroundSettings'] as Map).containsKey('Aplha')) {
            aplha = (config['BackgroundSettings'] as Map)['Aplha'];
          }
        }
      });
    } catch (e, strack) {
      log('_loadTheme 出错: $e\n$strack');
    }
    // print('更新');
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
            return SafeArea(
              top: false,
              bottom: true,
              child: Stack(
                children: [
                  if (_backgroundPath != null)
                    Positioned.fill(
                      child: Opacity(
                        opacity: aplha / 255,
                        child: Image.memory(
                          File(_backgroundPath!).readAsBytesSync(),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            _backgroundPath = null;
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                  child!,
                ],
              ),
            );
          },
          title: '中二查歌',
          theme: ThemeData(
            scaffoldBackgroundColor: _backgroundPath != null
                ? Colors.transparent
                : null,
            colorScheme: _useDynamicColor
                ? (lightDynamic ?? lightTheme)
                : lightTheme,
            useMaterial3: true,
            fontFamily: 'AlibabaPuHuiTi',
          ),
          darkTheme: ThemeData(
            scaffoldBackgroundColor: _backgroundPath != null
                ? Colors.transparent
                : null,
            colorScheme: _useDynamicColor
                ? (darkDynamic ?? darkTheme)
                : darkTheme,
            useMaterial3: true,
            fontFamily: 'AlibabaPuHuiTi',
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
  bool _isLoading = true;
  final _navBarKey = GlobalKey();

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
      Map<String, dynamic> config = await (await ReadData.create())
          .readConfig();
      List announcement = jsonDecode(await requestAnnouncement());
      int value;
      if (!config.containsKey('announcement')) {
        value = 0;
      } else {
        value = config['announcement']['value'] ?? 0;
      }
      if (value < announcement[0]['value']) {
        log('有新的公告');
        if (!mounted) return;
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text(announcement[0]['title']),
            content: Text(announcement[0]['content']),
            scrollable: true,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('确定'),
              ),
            ],
          ),
        );
        config['announcement']['date'] = announcement[0]['date'];
        config['announcement']['value'] = announcement[0]['value'];
        config['announcement']['read'] = true;
        (await WriteData.create()).writeConfig(config);
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
      Map<String, dynamic> config = await (await ReadData.create())
          .readConfig();
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
      final packageinfo = await PackageInfo.fromPlatform();
      Map<String, dynamic> config = await (await ReadData.create())
          .readConfig();
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
            scrollable: true,
            content: Text(
              (changeslog['changes'] as List).join('\n').toString(),
            ),
          ),
        );
        config['changeslogread'] = true;
        await (await WriteData.create()).writeConfig(config);
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Dataupdate.ifres(
        context: context,
        onProgress: (text) {
          setState(() {
            showtext.value = text;
          });
        },
      );
      showChangesLog();
      chechupdate();
      showannouncement();
      setState(() {
        _isLoading = false;
      });
      // postusecount();
    });
  }

  final showtext = ValueNotifier<String>('初始化');
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
    //脑子抽掉了，忘记做新下载测试了
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('res/icon.png', width: 80, height: 80),
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
              const SizedBox(height: 12),
              Text(showtext.value),
            ],
          ),
        ),
      );
    }

    // final RenderBox? box =
    //     _navBarKey.currentContext?.findRenderObject() as RenderBox?;
    // final height = box?.size.height;

    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.transparent),
      extendBody: true,
      // backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 25, left: 25, right: 25),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: NavigationBar(
            key: _navBarKey,
            // height: 70,
            shadowColor: Theme.of(context).colorScheme.primary.withAlpha(200),
            // shadowColor: Theme.of(
            //   context,
            // ).colorScheme.primaryContainer.withAlpha(150),
            elevation: 25,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primaryContainer.withAlpha(150),
            indicatorColor: Theme.of(
              context,
            ).colorScheme.primary.withAlpha(150),
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
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
            destinations: const [
              NavigationDestination(icon: Icon(Icons.search), label: '搜索'),
              NavigationDestination(icon: Icon(Icons.favorite), label: '收藏'),
              NavigationDestination(icon: Icon(Icons.build), label: '工具'),
              NavigationDestination(icon: Icon(Icons.info), label: '关于'),
            ],
          ),
        ),
      ),
    );
  }
}
