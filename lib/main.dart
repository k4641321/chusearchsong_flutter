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
      Map<String, dynamic> config = json.decode(configStr);
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
  @override
  void initState() {
    super.initState();
    ifres(context: context);
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
        backgroundColor: Theme.of(context).colorScheme.primaryFixedDim,
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
        // backgroundColor: const Color.fromARGB(255, 255, 229, 84),
        unselectedItemColor: Theme.of(context)
            .colorScheme
            .primaryFixedDim, //const Color.fromARGB(255, 250, 231, 125),
        selectedItemColor: Theme.of(
          context,
        ).colorScheme.primary, //const Color.fromARGB(255, 255, 217, 0),
        // fixedColor: const Color.fromARGB(255, 255, 217, 0),
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
