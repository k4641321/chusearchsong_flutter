import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/infopage.dart';
import 'pages/searchpage.dart';
import 'pages/favoritepage.dart';
import 'pages/toolspage.dart';

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
