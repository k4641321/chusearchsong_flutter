import 'package:flutter/material.dart';
import 'dart:developer';

class SongInfoPage extends StatelessWidget {
  final Map<String, dynamic> song;
  final String versionname;
  final List<DataRow> rowsData;
  final List<Widget> information;
  final int songid;
  const SongInfoPage({
    super.key,
    required this.song,
    required this.versionname,
    required this.rowsData,
    required this.information,
    required this.songid,
  });

  @override
  Widget build(BuildContext context) {
    const columnsdata = [
      DataColumn(label: Text('level')),
      DataColumn(label: Text('tap')),
      DataColumn(label: Text('hold')),
      DataColumn(label: Text('slide')),
      DataColumn(label: Text('air')),
      DataColumn(label: Text('flick')),
      DataColumn(label: Text('total')),
      DataColumn(label: Text('谱师')),
    ];
    final ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        title: Text('${song['title']}    - 歌曲详情'),
        backgroundColor: const Color.fromARGB(255, 255, 229, 84),
        actions: [
          IconButton(
            onPressed: () => ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('急什么，在写了'))),
            icon: Icon(Icons.favorite),
          ),
        ],
      ),
      body: Scrollbar(
        controller: controller,
        interactive: true,
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              Center(
                child: Image.network(
                  'https://assets2.lxns.net/chunithm/jacket/$songid.png',
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('图片加载失败');
                  },
                ),
              ),
              Center(
                child: Text(
                  '分类： ${song['genre']}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  '版本： $versionname',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  'BPM:  ${song['bpm']}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  '曲师： ${song['artist']}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Text('其余信息：', style: const TextStyle(fontSize: 20)),
                    Column(children: information),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: columnsdata,
                  rows: rowsData,
                  showBottomBorder: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
