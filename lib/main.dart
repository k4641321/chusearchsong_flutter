import 'package:flutter/material.dart';
import 'pages/infopage.dart';
import 'pages/searchpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'chusearchsong', home: const MyHomePage());
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
  List<Widget> get _pages => [searchpagebox, infopagebox];
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
              title = '关于';
            }
          });
        },
        fixedColor: const Color.fromARGB(255, 255, 229, 84),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '搜索'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: '关于'),
        ],
      ),
    );
  }
}
