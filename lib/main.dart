import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/infopage.dart';
import 'pages/searchpage.dart';
import 'pages/favoritepage.dart';
import 'pages/toolspage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../tools/request.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return SafeArea(top: false, bottom: true, child: child!);
      },
      title: 'chusearchsong',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _ifres() async {
    try {
      final directory = await getApplicationSupportDirectory();

      final path = Directory('${directory.path}/res');
      if (!path.existsSync()) {
        path.createSync(recursive: true);
      }
      if (!File('${path.path}/songs.json').existsSync() |
          !File('${path.path}/alias.json').existsSync() |
          !File('${path.path}/location.json').existsSync()) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('提示'),
              content: Text('初次启动，将下载数据，并创建必要文件'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('确定'),
                ),
              ],
            );
          },
        );
        // 下载歌曲数据
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('开始下载歌曲基本数据'), duration: Duration(seconds: 1)),
        );
        await File('${path.path}/songs.json').create();
        await File(
          '${path.path}/songs.json',
        ).writeAsString(await requestSongData());
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
        );
        log('保存到 ${path.path}/songs.json');
        // 下载歌曲别名数据
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('开始下载歌曲别名数据'), duration: Duration(seconds: 1)),
        );
        await File('${path.path}/alias.json').create();
        await File(
          '${path.path}/alias.json',
        ).writeAsString(await requestAliasData());
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
        );
        log('保存到 ${path.path}/alias.json');
        // 下载机厅数据
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('开始下载机厅数据'), duration: Duration(seconds: 1)),
        );
        await File('${path.path}/location.json').create();
        await File(
          '${path.path}/location.json',
        ).writeAsString(await requestLobbyData());
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
        );
        log('保存到 ${path.path}/location.json');
      }
      print(directory);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('下载失败，请检查网络'), duration: Duration(seconds: 1)),
      );
      log('$e', name: 'main', level: 2000);
    }
    try {
      final directory = await getApplicationSupportDirectory();
      final path = Directory('${directory.path}/files');
      if (!path.existsSync()) {
        path.createSync(recursive: true);
      }
      if (!mounted) return;

      if (!File('${path.path}/favorite.json').existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('开始创建收藏文件'), duration: Duration(seconds: 1)),
        );
        File('${path.path}/favorite.json').createSync();
        File('${path.path}/favorite.json').writeAsStringSync('[]');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('完成'), duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('创建失败'), duration: Duration(seconds: 1)),
      );
      log('$e', name: 'main', level: 2000);
    }
  }

  @override
  void initState() {
    super.initState();
    _ifres();
  }

  String title = '搜索';
  int _currentIndex = 0;
  final infopagebox = Info();
  Widget searchpagebox = SearchPage();
  Widget favoritepagebox = FavoritePage();
  Widget toolspagebox = ToolPage();
  List<Widget> get _pages => [
    searchpagebox,
    favoritepagebox,
    toolspagebox,
    infopagebox,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
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
        unselectedItemColor: const Color.fromARGB(255, 250, 231, 125),
        selectedItemColor: const Color.fromARGB(255, 255, 217, 0),
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
